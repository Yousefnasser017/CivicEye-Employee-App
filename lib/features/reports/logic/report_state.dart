import 'package:equatable/equatable.dart';
import '../../../models/report_model.dart';

abstract class ReportsState extends Equatable {
  final List<ReportModel> allReports;
  final List<ReportModel> filteredReports;
  final List<String> filters;
  final ReportModel? currentReport;

  const ReportsState({
    this.allReports = const [],
    this.filteredReports = const [],
    this.filters = const [],
    this.currentReport,
  });

  @override
  List<Object?> get props => [allReports, filteredReports, filters, currentReport];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  const ReportsLoaded({
    required super.allReports,
    required super.filteredReports,
    required super.filters,
    required super.currentReport,
  });
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);
  @override
  List<Object?> get props => [message];
}
