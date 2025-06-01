import 'package:civiceye/models/report_model.dart';

// تعريف الـ State لجميع حالات البلاغات
abstract class ReportsState {
  const ReportsState();
}

// حالة البلاغات المبدئية
class ReportsInitial extends ReportsState {}

// حالة تحميل البلاغات
class ReportsLoading extends ReportsState {
  final List<ReportModel> report;

  ReportsLoading({required this.report});
}

// حالة البلاغات بعد التحميل بنجاح
class ReportsLoaded extends ReportsState {
  final List<ReportModel> report;
  final bool hasMore;

  // بيانات الصفحة الرئيسية
  final ReportModel? inProgressReport;
  final List<ReportModel> latestReports;
  final Map<String, int> reportCountsByStatus;

  ReportsLoaded({
    required this.report,
    required this.hasMore,
    required this.inProgressReport,
    required this.latestReports,
    required this.reportCountsByStatus,
  });
}

// حالة الخطأ
class ReportsError extends ReportsState {
  final String message;

  ReportsError({required this.message});
}
