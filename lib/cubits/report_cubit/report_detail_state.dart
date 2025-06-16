// ignore_for_file: annotate_overrides

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
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isStatusUpdating, report, error];
}




class ReportDetailInitial extends ReportDetailState {}

class ReportDetailLoading extends ReportDetailState {}

class ReportDetailUpdating extends ReportDetailState {
    final ReportModel report;
  const ReportDetailUpdating({required this.report});
}

class ReportDetailLoaded extends ReportDetailState {
  @override
  final ReportModel report;

  const ReportDetailLoaded({required this.report});

  @override
  List<Object> get props => [report];
}

class ReportDetailUpdated extends ReportDetailState {
  @override
  final ReportModel report;

  const ReportDetailUpdated({required this.report});

  @override
  List<Object> get props => [report];
}

class ReportDetailError extends ReportDetailState {
  final String message;
  final ReportModel? report;
  const ReportDetailError({required this.message, this.report});



  @override
  List<Object> get props => [message];
}
