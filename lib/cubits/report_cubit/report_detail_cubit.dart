import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDetailCubit extends Cubit<ReportDetailState> {
  final StompWebSocketService? socketService;
  final ReportsCubit reportsCubit;

  ReportDetailCubit({
    this.socketService,
    required this.reportsCubit,
  }) : super(ReportDetailInitial());

  Future<void> fetchReportDetails(int reportId) async {
    emit(ReportDetailLoading());
    try {
      final report = await ReportApi.getReportDetails(reportId);
      emit(ReportDetailLoaded(report: report));
    } catch (e) {
      emit(const ReportDetailError(
          message: 'فشل في تحميل تفاصيل البلاغ. حاول لاحقًا.'));
    }
  }

  Future<ReportModel?> updateReportStatus(
    ReportModel report,
    String newStatus,
    String? notes,
    int employeeId,
  ) async {
    if (isClosed) return null;
    emit(state.copyWith(isStatusUpdating: true, error: null));
    try {
      final updateStatus = UpdateReportStatus(
        employeeId: employeeId,
        newStatus: newStatus,
        notes: notes,
        reportId: report.reportId,
      );

      await ReportApi.updateStatus(
        updateStatus.reportId,
        updateStatus.newStatus,
        updateStatus.employeeId,
        notes: updateStatus.notes,
      );

      if (socketService?.isConnected == true) {
        socketService!.sendUpdateStatus(
          reportId: updateStatus.reportId,
          newStatus: updateStatus.newStatus,
          notes: updateStatus.notes,
          employeeId: updateStatus.employeeId,
        );
      }

      // تحديث البيانات بعد نجاح العملية
      final updatedReport = await ReportApi.getReportDetails(report.reportId);
      reportsCubit.updateLocalReport(updatedReport);

      emit(ReportDetailUpdated(report: updatedReport));
      return updatedReport;
    } catch (e) {
      if (isClosed) return null;
      emit(const ReportDetailError(message: 'فشل في تحديث الحالة'));
      return null; // مهم للـ Optimistic Update في الواجهة
    }
  }

  // void setupWebSocketListener() {
  //   socketService?.onStatusUpdate((updatedStatusData) {
  //     // تأكد من ان الرسالة تخص البلاغ الحالي
  //     if (updatedStatusData.reportId == state.report?.reportId) {
  //       final updatedReport =
  //           state.report?.copyWith(currentStatus: updatedStatusData.newStatus);
  //       if (updatedReport != null) {
  //         emit(state.copyWith(report: updatedReport));
  //       }
  //     }
  //   });
  // }
}
