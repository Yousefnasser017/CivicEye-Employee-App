import 'package:civiceye/models/report_model.dart';

abstract class ReportsState {
  final List<ReportModel> reports;

  ReportsState({this.reports = const []});
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {
  final List<ReportModel> report;

  ReportsLoading({required this.report});
}

class ReportsLoaded extends ReportsState {
  final List<ReportModel> report;
  final bool hasMore;

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

class ReportsError extends ReportsState {
  final String message;

  ReportsError({required this.message});
}
