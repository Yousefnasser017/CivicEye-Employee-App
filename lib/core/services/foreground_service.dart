// ignore_for_file: unused_field, unused_element

import 'dart:async';
import 'dart:math';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/services/notification_helper.dart';
import 'package:civiceye/core/services/report_notification_handler.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:civiceye/core/api/report_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:civiceye/core/services/notifications_storage.dart';
import 'package:civiceye/core/services/notification_counter.dart';

/// هذا الكلاس مسؤول عن معالجة المهام في الخلفية
class ReliableBackgroundTaskHandler extends TaskHandler {
  static final ReliableBackgroundTaskHandler _instance =
      ReliableBackgroundTaskHandler._internal();
  factory ReliableBackgroundTaskHandler() => _instance;
  ReliableBackgroundTaskHandler._internal();

  StreamSubscription<String>? _wsSubscription;
  StreamSubscription<ConnectivityResult>? _networkSubscription;
  bool _isConnected = false;
  Timer? _keepAliveTimer;
  Timer? _reconnectTimer;
  Timer? _healthCheckTimer;
  final _maxReconnectAttempts = 10;
  int _reconnectAttempts = 0;
  final _webSocketService = StompWebSocketService();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    try {
      // 1. تهيئة الإشعارات
      await NotificationHelper.init();
      await NotificationHelper.initEmployee();

      // 2. مراقبة حالة الاتصال
      _setupNetworkMonitoring();

      // 3. الاتصال بالـ WebSocket
      await _connectWebSocket();

      // 4. إعداد مؤقت للحفاظ على الاتصال
      _setupKeepAlive();

      // 5. إعداد فحص صحة الاتصال
      _setupHealthCheck();

      // 6. تحديث حالة الخدمة
      await FlutterForegroundTask.updateService(
        notificationTitle: 'CivicEye',
        notificationText: 'جاري الاستماع للبلاغات الجديدة...',
      );
    } catch (e) {
      print('Error in onStart: $e');
      _handleStartupError();
    }
  }

  void _setupNetworkMonitoring() {
    _networkSubscription?.cancel();
    _networkSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        print('[Background] Network available, attempting to connect...');
        _connectWebSocket();
      } else {
        print('[Background] Network unavailable');
        _handleConnectionError();
      }
    });
  }

  void _setupHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!_isConnected) {
        _connectWebSocket();
      } else {
        _webSocketService.sendKeepAlive();
      }
    });
  }

  Future<void> _connectWebSocket() async {
    if (_isConnected) return;

    try {
      await _webSocketService.connect();
      _isConnected = true;
      _reconnectAttempts = 0;

      _wsSubscription?.cancel();
      _wsSubscription = _webSocketService.reportStream.listen(
        _handleIncomingMessage,
        onError: (error) {
          print('[Background] WebSocket Error: $error');
          _handleConnectionError();
        },
        onDone: () {
          print('[Background] WebSocket Connection Closed');
          _handleConnectionError();
        },
      );

      print('[Background] WebSocket connected successfully');
    } catch (e) {
      print('[Background] Connection Error: $e');
      _handleConnectionError();
    }
  }

  void _setupKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (_isConnected) {
        _webSocketService.sendKeepAlive();
      } else {
        _connectWebSocket();
      }
    });
  }

  Future<void> _handleIncomingMessage(String msg) async {
    int? reportId;
    try {
      print('[Background] Received new report: $msg');

      // 1. تحليل الرسالة
      final regExp = RegExp(r'Report #(\d+)');
      final match = regExp.firstMatch(msg);
      if (match == null) return;

      reportId = int.tryParse(match.group(1) ?? '');
      if (reportId == null) return;

      // 2. جلب تفاصيل البلاغ
      final report = await ReportApi.getReportDetails(reportId);

      // 3. تجهيز الإشعار
      final since = ReportNotificationHandler.getTimeAgo(report.createdAt);
      final notificationBody =
          'بلاغ: ${report.title}\nالمدينة: ${report.cityName}\n$since';

      // 4. عرض الإشعار
      await NotificationHelper.showNotification(
        'بلاغ جديد',
        notificationBody,
        reportId: reportId.toString(),
      );

      // 5. حفظ الإشعار
      await NotificationsStorage.addNotification({
        'title': 'بلاغ جديد',
        'body': notificationBody,
        'time': DateTime.now().toIso8601String(),
        'reportId': reportId.toString(),
      });

      // 6. تحديث العداد
      await NotificationCounter.updateCount(() async {
        final notifications = await NotificationsStorage.getNotifications();
        return notifications.length;
      });
    } catch (e) {
      print('[Background] Error handling message: $e');
      await NotificationHelper.showNotification(
        'بلاغ جديد',
        'تم تعيين بلاغ جديد. (تعذر جلب التفاصيل)',
        reportId: reportId?.toString(),
      );
    }
  }

  void _handleConnectionError() {
    _isConnected = false;
    _tryReconnect();
  }

  Future<void> _tryReconnect() async {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('[Background] Max reconnect attempts reached');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: pow(2, _reconnectAttempts).toInt());

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      await _connectWebSocket();
    });
  }

  void _handleStartupError() {
    print('[Background] Failed to start background task');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isFinished) async {
    _keepAliveTimer?.cancel();
    _reconnectTimer?.cancel();
    _healthCheckTimer?.cancel();
    await _wsSubscription?.cancel();
    await _networkSubscription?.cancel();
    _isConnected = false;
    _webSocketService.dispose();
  }

  @override
  void onNotificationPressed() {
    // يمكن إضافة منطق إضافي هنا عند الضغط على الإشعار
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    // التحقق من حالة الاتصال وإعادة الاتصال إذا لزم الأمر
    if (!_isConnected) {
      await _connectWebSocket();
    }
  }
}
