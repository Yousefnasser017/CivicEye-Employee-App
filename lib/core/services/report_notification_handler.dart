// ignore_for_file: prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';
import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/services/notification_helper.dart';

class ReportNotificationHandler {
  static StreamSubscription<String> listenToWebSocket(
      Stream<String> reportStream) {
    return reportStream.listen((msg) async {
      print('NotificationHandler: تم استقبال بلاغ جديد من WebSocket: $msg');
      try {
        // تحليل الرسالة للحصول على reportId
        final regExp = RegExp(r'Report #(\d+)');
        final match = regExp.firstMatch(msg);
        if (match != null) {
          final reportId = int.tryParse(match.group(1) ?? '');
          if (reportId != null) {
            // جلب تفاصيل البلاغ
            final report = await ReportApi.getReportDetails(reportId);

            // تجهيز نص الإشعار
            final since = getTimeAgo(report.createdAt);
            final notificationBody = '''
              بلاغ جديد #${report.reportId}
              العنوان: ${report.title}
              المدينة: ${report.cityName ?? 'غير محدد'}
              القسم: ${report.department}
              الوصف: ${report.description ?? 'لا يوجد وصف'}
              منذ: $since
              ''';

            // عرض الإشعار
            NotificationHelper.showNotification(
              'بلاغ جديد #${report.reportId}',
              notificationBody,
              reportId: reportId.toString(),
            );
          }
        } else {
          // إذا لم نتمكن من استخراج reportId، نعرض الرسالة كما هي
          NotificationHelper.showNotification('بلاغ جديد', msg);
        }
      } catch (e) {
        print('خطأ في معالجة الإشعار: $e');
        NotificationHelper.showNotification(
          'بلاغ جديد',
          'تم استلام بلاغ جديد. (تعذر جلب التفاصيل)',
        );
      }
    });
  }

  static String getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 0) {
      return 'منذ ${diff.inDays} يوم';
    } else if (diff.inHours > 0) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inMinutes > 0) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
