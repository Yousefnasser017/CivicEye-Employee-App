import 'package:civiceye/models/report_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportsState extends Equatable {
  final List<ReportModel> allReports;
  final List<ReportModel> filteredReports;
  final List<String> filters;
  
  const ReportsState({
    this.allReports = const [],
    this.filteredReports = const [],
    this.filters = const [],
  });

  @override
  List<Object?> get props => [allReports, filteredReports, filters];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial() : super();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading({
    required super.allReports,
    required super.filteredReports,
    required super.filters,
  });
}

class ReportsLoaded extends ReportsState {
  const ReportsLoaded({
    required super.allReports,
    required super.filteredReports,
    required super.filters,
  });
}

class ReportsError extends ReportsState {
  final String message;
  
  const ReportsError({
    required this.message,
    required super.allReports,
    required super.filteredReports,
    required super.filters,
  });

  @override
  List<Object?> get props => [message, ...super.props];
}