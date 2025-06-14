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

      final employee = await LocalStorageHelper.getEmployee();
      final reports = await ReportApi.getReportsByEmployee(employee?.id ?? 0);

      // التاريخ الحالي
      final now = DateTime.now();

      // فلترة بلاغات اليوم فقط
      final todayReports = reports.where((report) {
        final createdAt = DateTime.tryParse(report.createdAt as String);
        return createdAt != null &&
            createdAt.year == now.year &&
            createdAt.month == now.month &&
            createdAt.day == now.day;
      }).toList();

      // حساب الإحصائيات فقط من بلاغات اليوم
      int submittedCount =
          todayReports.where((r) => r.currentStatus == 'Submitted').length;
      int inProgressCount =
          todayReports.where((r) => r.currentStatus == 'In_Progress').length;
      int resolvedCount =
          todayReports.where((r) => r.currentStatus == 'Resolved').length;
      todayReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      ReportModel? currentReport = todayReports
          .firstWhereOrNull((r) => r.currentStatus == 'In_Progress');

      emit(state.copyWith(
        reports: todayReports,
        submittedCount: submittedCount,
        inProgressCount: inProgressCount,
        resolvedCount: resolvedCount,
        currentReport: currentReport,
        status: ReportStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ReportStatus.failure, errorMessage: e.toString()));
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
