import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/models/report_status_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ReportDetailCubit extends Cubit<ReportDetailState> {
  ReportDetailCubit() : super(const ReportDetailState(isLoading: true));

  // تحميل تفاصيل البلاغ
  Future<void> fetchReportDetails(String reportId) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      // محاكاة تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final report = ReportModel(
        reportId: int.parse(reportId),
        title: 'عنوان البلاغ',
        description: 'وصف البلاغ هنا...',
        currentStatus: ReportStatus.Submitted.name,
        createdAt: DateTime.now(),
        latitude: 30.0,
        longitude: 31.0,
        contactInfo: '0123456789',
        department: 'Default Department',
      );
      
      emit(state.copyWith(report: report, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'حدث خطأ في تحميل البيانات'));
    }
  }

  // تحديث حالة البلاغ
  Future<void> updateReportStatus(
    ReportModel report,
    String newStatus,
    String? notes,
  ) async {
    try {
      emit(ReportDetailLoading()); // الحالة: تحميل

      final employeeId = await _getEmployeeId(); // جلب employeeId من التخزين

      final updateStatus = UpdateReportStatus(
        employeeId: employeeId,
        newStatus: newStatus,
        notes: notes,
        reportId: report.reportId,
      );

      // تحديث الحالة عبر الـ API
      await ReportApi.updateStatus(
        updateStatus.reportId,
        updateStatus.newStatus,
        updateStatus.employeeId,
        notes: updateStatus.notes,
      );

      // تحديث البلاغ محليًا بالحالة الجديدة
      final updatedReport = report.copyWith(currentStatus: newStatus);

      emit(ReportDetailUpdated(updatedReport)); // الحالة: تم التحديث
    } catch (e) {
      emit(ReportDetailError('فشل في تحديث الحالة: $e')); // الحالة: خطأ
    }
  }

  // دالة داخلية لجلب الـ employeeId من التخزين
  Future<int> _getEmployeeId() async {
    final employee = await LocalStorageHelper.getEmployee();
    return employee?.id ?? 0;
  }

}

