import 'package:equatable/equatable.dart';
import 'package:civiceye/models/report_model.dart';

// تعريف الحالات المتاحة في الـ Cubit
enum ReportStatus { initial, loading, success, failure,   Submitted,
  In_Progress,
  On_Hold,
  Resolved,
  Cancelled }

class ReportState extends Equatable {
  final ReportStatus status;
  final List<ReportModel> reports;
  final int submittedCount;
  final int inProgressCount;
  final int resolvedCount;
  final ReportModel? currentReport;
  final String errorMessage;

  const ReportState({
    required this.status,
    required this.reports,
    required this.submittedCount,
    required this.inProgressCount,
    required this.resolvedCount,
    required this.currentReport,
    required this.errorMessage,
  });

  // تعيين القيم الافتراضية عند التهيئة
  factory ReportState.initial() {
    return const ReportState(
      status: ReportStatus.initial,
      reports: [],
      submittedCount: 0,
      inProgressCount: 0,
      resolvedCount: 0,
      currentReport: null,
      errorMessage: '',
    );
  }

  // نسخ الـ state مع التحديثات
  ReportState copyWith({
    ReportStatus? status,
    List<ReportModel>? reports,
    int? submittedCount,
    int? inProgressCount,
    int? resolvedCount,
    ReportModel? currentReport,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      submittedCount: submittedCount ?? this.submittedCount,
      inProgressCount: inProgressCount ?? this.inProgressCount,
      resolvedCount: resolvedCount ?? this.resolvedCount,
      currentReport: currentReport ?? this.currentReport,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        reports,
        submittedCount,
        inProgressCount,
        resolvedCount,
        currentReport,
        errorMessage,
      ];
}
