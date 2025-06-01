import 'package:civiceye/models/report_model.dart';
import 'package:equatable/equatable.dart';

class ReportDetailState extends Equatable {
  final bool isLoading;
  final bool isStatusUpdating;
  final ReportModel? report;
  final String? error;

  const ReportDetailState({
    this.isLoading = false,
    this.isStatusUpdating = false,
    this.report,
    this.error,
  });

  ReportDetailState copyWith({
    bool? isLoading,
    bool? isStatusUpdating,
    ReportModel? report,
    String? error,
  }) {
    return ReportDetailState(
      isLoading: isLoading ?? this.isLoading,
      isStatusUpdating: isStatusUpdating ?? this.isStatusUpdating,
      report: report ?? this.report,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isStatusUpdating, report, error];
}

class ReportDetailInitial extends ReportDetailState {}

class ReportDetailLoading extends ReportDetailState {}

class ReportDetailUpdated extends ReportDetailState {
  final ReportModel updatedReport;

  const ReportDetailUpdated(this.updatedReport);
}

class ReportDetailError extends ReportDetailState {
  final String message;

  const ReportDetailError(this.message);
}