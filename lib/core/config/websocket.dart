// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


import 'dart:async';

class StompWebSocketService {
  static final StompWebSocketService _instance =
      StompWebSocketService._internal();

  factory StompWebSocketService() => _instance;

  StompWebSocketService._internal();

  late StompClient _client;
  bool _connected = false;
  int _reconnectAttempts = 0;

  bool get isConnected => _connected;

  // StreamController لبث البلاغات الجديدة
  final StreamController<String> _reportController =
      StreamController<String>.broadcast();
  Stream<String> get reportStream => _reportController.stream;

  Future<void> connect() async {
    final jwtToken = await LocalStorageHelper.getJwtToken();
    if (jwtToken == null) {
      print(' JWT token not found in LocalStorageHelper!');
      return;
    } else {
      print('✅ JWT token retrieved: $jwtToken');
    }

    if (_connected) {
      print(' Already connected');
      return;
    }

    // في حال وجود اتصال قديم نغلقه
    try {
      if (_client.connected) {
        print('🔌 Deactivating previous client...');
        _client.deactivate();
      }
    } catch (_) {
      // قد يكون لم يُنشأ بعد
    }

    _client = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.1.2:9090/ws',
        onConnect: _onConnectCallback,
        onWebSocketError: (dynamic error) {
          _connected = false;
          print(' WebSocket error: $error');
          _tryReconnect();
        },
        onDisconnect: (frame) {
          _connected = false;
          print('🔌 WebSocket disconnected');
          _tryReconnect();
        },
        stompConnectHeaders: {'login': 'guest', 'passcode': 'guest'},
        webSocketConnectHeaders: {'Cookie': 'jwt=$jwtToken'},
        heartbeatOutgoing: const Duration(seconds: 5),
        heartbeatIncoming: const Duration(seconds: 5),
      ),
    );

    _client.activate();
  }

  void _onConnectCallback(StompFrame frame) {
    _connected = true;
    print('✅ STOMP connected');

    // الاشتراك في قناة استقبال البلاغات
    _client.subscribe(
      destination: 'user/queue/reports/', // عدّل المسار حسب السيرفر
      callback: (StompFrame reportFrame) {
        if (reportFrame.body != null) {
          _reportController.add(reportFrame.body!);
          print(' Received new report: ${reportFrame.body}');
        }
      },
    );
  }

  void _tryReconnect() {
    if (!_connected && _reconnectAttempts < 5) {
      _reconnectAttempts++;
      final delay = Duration(seconds: 5 * _reconnectAttempts);

      print(
          ' Attempting reconnect #$_reconnectAttempts in ${delay.inSeconds}s...');

      Future.delayed(delay, () {
        if (!_connected) {
          connect();
        }
      });
    } else if (_reconnectAttempts >= 5) {
      print(' Max reconnect attempts reached. Giving up.');
    }
  }

  void sendUpdateStatus({
    required int reportId,
    required String newStatus,
    required String? notes,
    required int employeeId,
  }) {
    if (!_connected) {
      print(' WebSocket not connected. Skipping send.');
      return;
    }

    final data = {
      "reportId": reportId,
      "newStatus": newStatus,
      "notes": notes,
      "employeeId": employeeId,
    };

    _client.send(
      destination: '/app/updateStatus',
      body: jsonEncode(data),
      headers: {'content-type': 'application/json'},
    );

    print(' Sent WebSocket updateStatus: $data');
  }

  void dispose() {
    _client.deactivate();
    _connected = false;
    _reportController.close();
    print('WebSocket connection disposed');
  }
}
