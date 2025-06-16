// ignore_for_file: unrelated_type_equality_checks

import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class ReportDetailCubit extends Cubit<ReportDetailState> {
  final StompWebSocketService? socketService;
  final ReportsCubit reportsCubit;
  StreamSubscription? _wsSubscription;

  ReportDetailCubit({
    this.socketService,
    required this.reportsCubit,
  }) : super(ReportDetailInitial()) {
    setupWebSocketListener();
  }

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
    try {
      // 1. تحديث الحالة إلى Updating
      emit(ReportDetailUpdating(report: report));

      // 2. تحديث الحالة عبر API
      await ReportApi.updateStatus(
        report.reportId,
        newStatus,
        employeeId,
        notes: notes,
      );

      // 3. جلب البيانات المحدثة
      final updatedReport = await ReportApi.getReportDetails(report.reportId);

      // 4. إرسال التحديث عبر WebSocket
      if (socketService != null && socketService!.isConnected) {
        socketService!.sendUpdateStatus(
          reportId: report.reportId,
          newStatus: newStatus,
          notes: notes,
          employeeId: employeeId,
        );
      }

      // 5. تحديث الحالة المحلية
      emit(ReportDetailUpdated(report: updatedReport));

      // 6. تحديث البلاغ في قائمة البلاغات
      reportsCubit.updateLocalReport(updatedReport);

      return updatedReport;
    } catch (e) {
      // 7. في حالة الخطأ، نعيد البلاغ القديم مع رسالة الخطأ
      emit(ReportDetailError(
        message: 'فشل في تحديث حالة البلاغ. حاول لاحقًا.',
        report: report,
      ));
      return null;
    }
  }

  void setupWebSocketListener() {
    if (socketService == null) return;
    _wsSubscription?.cancel();
    _wsSubscription =
        socketService!.statusUpdateStream.listen((updatedStatusData) async {
      final currentReport = state is ReportDetailLoaded
          ? (state as ReportDetailLoaded).report
          : state is ReportDetailUpdated
              ? (state as ReportDetailUpdated).report
              : null;

      if (currentReport != null &&
          updatedStatusData.reportId == currentReport.reportId) {
        await fetchReportDetails(updatedStatusData.reportId);
      }
    });
  }

  @override
  Future<void> close() async {
    await _wsSubscription?.cancel();
    return super.close();
  }
}
