import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ReportDetailCubit extends Cubit<ReportDetailState> {
  final StompWebSocketService? socketService;

  ReportDetailCubit({this.socketService})
      : super(const ReportDetailState(isLoading: true));

  void setReport(ReportModel report) {
    emit(state.copyWith(report: report, isLoading: false));
  }

  Future<void> updateReportStatus(
    ReportModel report,
    String newStatus,
    String? notes, int employeeId,
  ) async {
    try {
      emit(ReportDetailLoading());

      final employeeId = await _getEmployeeId();

      final updateStatus = UpdateReportStatus(
        employeeId: employeeId,
        newStatus: newStatus,
        notes: notes,
        reportId: report.reportId,
      );

      // 1. تحديث عبر REST API
      await ReportApi.updateStatus(
        updateStatus.reportId,
        updateStatus.newStatus,
        updateStatus.employeeId,
        notes: updateStatus.notes,
      );

      // 2. إرسال WebSocket إذا موجود والاتصال شغال
      if (socketService != null && socketService!.isConnected)  {
        socketService!.sendUpdateStatus(
          reportId: updateStatus.reportId,
          newStatus: updateStatus.newStatus,
          notes: updateStatus.notes,
          employeeId: updateStatus.employeeId,
        );
      }

      final updatedReport = report.copyWith(currentStatus: newStatus);
      emit(ReportDetailUpdated(updatedReport));
    } catch (e) {
      emit(ReportDetailError('فشل في تحديث الحالة: $e'));
    }
  }


  Future<int> _getEmployeeId() async {
    final employee = await LocalStorageHelper.getEmployee();
    return employee?.id ?? 0;
  }
}


