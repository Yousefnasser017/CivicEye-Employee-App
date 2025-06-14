import 'dart:convert';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';



import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static late final dynamic employee;
  
  static Future<void> initEmployee() async {
    employee = await LocalStorageHelper.getEmployee();
  }
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final data = json.decode(payload);
            final reportId = data['reportId'];
            if (reportId != null) {
              // استخدم navigatorKey للانتقال
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => ReportDetailsScreen(
                    report: ReportModel(
                      reportId: int.tryParse(reportId) ?? 0,
                      title: '',
                      department: '',
                      createdAt: DateTime.now(),
                      currentStatus: '',
                    ),
                    employeeId: (employee?.id ?? 0).toString(),
                    reportId: int.tryParse(reportId) ?? 0,
                  ),
                ),
              );
            }
        
          } catch (e) {}
        }
      },
    );
    await _requestNotificationPermission();
  }

  /// يطلب إذن الإشعارات على أندرويد 13+
  static Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          await Permission.notification.request();
        }
      }
    }
  }

  static Future<void> showNotification(String title, String body, {String? reportId}) async {
    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'civiceye_reports',
          'بلاغات جديدة',
          channelDescription: 'إشعارات البلاغات الجديدة',
          importance: Importance.max,
          priority: Priority.high,
        ),
       
      ),
    );
    // احفظ الإشعار في التخزين المحلي لعرضه في صفحة الإشعارات
        try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'local_notifications_list';
      final data = prefs.getStringList(key) ?? [];
      final notification = {
        'title': title,
        'body': body,
        'time': DateTime.now().toIso8601String(),
        if (reportId != null) 'reportId': reportId,
      };
      data.insert(0, json.encode(notification));
      await prefs.setStringList(key, data);
    } catch (e) {
      // تجاهل أي خطأ في التخزين المحلي
    }
  }

}
