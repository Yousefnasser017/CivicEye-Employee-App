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
  }) : super(ReportDetailInitial()) {}

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

      // 2. إرسال التحديث عبر WebSocket فقط
      if (socketService != null && socketService!.isConnected) {
        socketService!.sendUpdateStatus(
          reportId: report.reportId,
          newStatus: newStatus,
          notes: notes,
          employeeId: employeeId,
        );

        // 3. جلب البيانات المحدثة بعد إرسال التحديث
        final updatedReport = await ReportApi.getReportDetails(report.reportId);

        // 4. تحديث الحالة المحلية
        emit(ReportDetailUpdated(report: updatedReport));

        // 5. تحديث البلاغ في قائمة البلاغات
        reportsCubit.updateLocalReport(updatedReport);

        return updatedReport;
      } else {
        throw Exception('WebSocket connection is not available');
      }
    } catch (e) {
      // 6. في حالة الخطأ، نعيد البلاغ القديم مع رسالة الخطأ
      emit(ReportDetailError(
        message: 'فشل في تحديث حالة البلاغ. حاول لاحقًا.',
        report: report,
      ));
      return null;
    }
  }

  @override
  Future<void> close() async {
    await _wsSubscription?.cancel();
    return super.close();
  }
}
