// home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/core/api/report_api.dart';
import 'package:civiceye/core/error/exceptions.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final _storage = const FlutterSecureStorage();

  Future<void> loadDashboardData() async {
    emit(HomeLoading());

    try {
      final empId = int.parse(await _storage.read(key: 'employeeId') ?? '0');
      final reports = await ReportApi.getReportsByEmployee(empId);

      final pendingCount = reports.where((r) => r.currentStatus == 'معلق').length;
      final resolvedCount = reports.where((r) => r.currentStatus == 'تم الحل').length;
      final todayCount = reports.where((r) =>
        r.createdAt.day == DateTime.now().day &&
        r.createdAt.month == DateTime.now().month &&
        r.createdAt.year == DateTime.now().year).length;

      ReportModel? current;
      try {
        current = reports.firstWhere((r) => r.currentStatus == 'قيد التنفيذ');
      } catch (_) {
        current = null;
      }

      emit(HomeLoaded(
        pendingCount: pendingCount,
        resolvedCount: resolvedCount,
        todayCount: todayCount,
        currentReport: current,
      ));
    } catch (e) {
      emit(HomeError(ExceptionHandler.handle(e)));
    }
  }

  Future<void> updateStatus(int reportId, String newStatus) async {
    emit(HomeLoading());
    try {
      final empId = int.parse(await _storage.read(key: 'employeeId') ?? '0');
      await ReportApi.updateStatus(reportId, newStatus, empId);
      await loadDashboardData();
    } catch (e) {
      emit(HomeError(ExceptionHandler.handle(e)));
    }
  }
}
