import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ReportDetailCubit extends Cubit<ReportDetailState> {
  ReportDetailCubit() : super(const ReportDetailState(isLoading: true));

  // تحميل تفاصيل البلاغ
   void setReport(ReportModel report) {
    emit(state.copyWith(report: report, isLoading: false));
  }

  // تحديث حالة البلاغ
 Future<ReportModel?> updateReportStatus(
    ReportModel report,
    String newStatus,
    String? notes,
  ) async {
    try {
      emit(ReportDetailLoading());

      final employeeId = await _getEmployeeId();

      await ReportApi.updateStatus(
        report.reportId,
        newStatus,
        employeeId,
        notes: notes,
      );

      final updatedReport = report.copyWith(currentStatus: newStatus);

      emit(ReportDetailUpdated(updatedReport));

      return updatedReport; // إرجاع البلاغ المحدث
    } catch (e) {
      emit(ReportDetailError('فشل في تحديث الحالة: $e'));
      return null; // في حالة الخطأ
    }
  }

  // دالة داخلية لجلب الـ employeeId من التخزين
  Future<int> _getEmployeeId() async {
    final employee = await LocalStorageHelper.getEmployee();
    return employee?.id ?? 0;
  }
}

