import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/cubits/home_cubit/home_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class ReportCubit extends Cubit<ReportState> {

  ReportCubit() : super(ReportState.initial());

  Future<void> fetchReports() async {
    try {
      emit(state.copyWith(status: ReportStatus.loading));

      final employee = await LocalStorageHelper.getEmployee();  // جلب ID الموظف من الذاكرة
      final reports = await ReportApi.getReportsByEmployee(employee?.id ?? 0);

      // حساب الإحصائيات
      int submittedCount = reports.where((report) => report.currentStatus == 'Submitted').length;
      int inProgressCount = reports.where((report) => report.currentStatus == 'In_Progress').length;
      int resolvedCount = reports.where((report) => report.currentStatus == 'Resolved').length;

      // تحديد البلاغ الجاري
      ReportModel? currentReport = reports.firstWhereOrNull((report) => report.currentStatus == 'In_Progress');

      emit(state.copyWith(
        reports: reports,
        submittedCount: submittedCount,
        inProgressCount: inProgressCount,
        resolvedCount: resolvedCount,
        currentReport: currentReport,
        status: ReportStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: ReportStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> updateReportStatus(int reportId, String newStatus, String? notes) async {
    try {
      final employee = await LocalStorageHelper.getEmployee();
      await ReportApi.updateStatus(reportId, newStatus, employee?.id ?? 0, notes: notes);

      emit(state.copyWith(status: ReportStatus.success));
      fetchReports(); 
    } catch (e) {
      emit(state.copyWith(status: ReportStatus.failure, errorMessage: e.toString()));
    }
  }
}
