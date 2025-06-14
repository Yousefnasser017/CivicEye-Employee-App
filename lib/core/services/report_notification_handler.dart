// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';
import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/services/notification_helper.dart';


class ReportNotificationHandler {
  static StreamSubscription<String> listenToWebSocket(
      Stream<String> reportStream) {
    return reportStream.listen((msg) async {
      print('NotificationHandler: تم استقبال بلاغ جديد من WebSocket: $msg');
      final regExp = RegExp(r'Report #(\d+)');
      final match = regExp.firstMatch(msg);
      if (match != null) {
        final reportId = int.tryParse(match.group(1) ?? '');
        if (reportId != null) {
          try {
            final report = await ReportApi.getReportDetails(reportId);
            final since = _getTimeAgo(report.createdAt);
            final notificationBody =
                'بلاغ: ${report.title}\nالمدينة: ${report.cityName}\n$since';
            NotificationHelper.showNotification('بلاغ جديد', notificationBody);
          } catch (e) {
            NotificationHelper.showNotification(
                'بلاغ جديد', 'تم تعيين بلاغ جديد. (تعذر جلب التفاصيل)');
          }
        } else {
          NotificationHelper.showNotification('بلاغ جديد', msg);
        }
      } else {
        NotificationHelper.showNotification('بلاغ جديد', msg);
      }
    });
  }

 static String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;

    String since = '';
    if (days > 0) since += 'منذ $days يوم${days > 1 ? 's' : ''}';
    if (hours > 0) since += since.isEmpty ? 'منذ $hours ساعة' : ' و$hours ساعة';
    if (minutes > 0 && days == 0)
      since += since.isEmpty ? 'منذ $minutes دقيقة' : ' و$minutes دقيقة';
    if (since.isEmpty) since = 'الآن';
    return since;
  }
}
