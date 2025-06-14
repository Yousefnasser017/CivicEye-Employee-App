import 'dart:async';
import 'package:civiceye/core/services/notification_helper.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:civiceye/core/api/report_service.dart';

/// هذا الكلاس مسؤول عن معالجة المهام في الخلفية
class ReportBackgroundTaskHandler extends TaskHandler {
  Timer? _timer;
  Set<int> _lastReportIds = {};

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await NotificationHelper.init();
    await _loadLastReportIds();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      try {
        final employeeId = await _getEmployeeId();
        if (employeeId == null) return;
        final reports = await ReportApi.getReportsByEmployee(employeeId);
        final currentIds = reports.map((r) => r.reportId).toSet();
        // البلاغات الجديدة فقط
        final newReports =
            reports.where((r) => !_lastReportIds.contains(r.reportId)).toList();
        if (newReports.isNotEmpty) {
          for (final report in newReports) {
            print('ForegroundService: إشعار بلاغ جديد: ${report.title}');
            NotificationHelper.showNotification(
              'بلاغ جديد: ${report.title}',
              report.description ?? 'تم إضافة بلاغ جديد إلى حسابك',
            );
          }
          _lastReportIds = currentIds;
          await _saveLastReportIds();
        }
      } catch (e) {
        // يمكن إضافة لوج هنا
      }
    });
  }

  Future<void> _loadLastReportIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('last_report_ids') ?? [];
    _lastReportIds = ids.map((e) => int.tryParse(e) ?? 0).toSet();
  }

  Future<void> _saveLastReportIds() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'last_report_ids', _lastReportIds.map((e) => e.toString()).toList());
  }

  Future<int?> _getEmployeeId() async {
    final employee = await LocalStorageHelper.getEmployee();
    return employee?.id;
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isFinished) async {
    _timer?.cancel();
  }

  @override
  void onNotificationPressed() {}
}
