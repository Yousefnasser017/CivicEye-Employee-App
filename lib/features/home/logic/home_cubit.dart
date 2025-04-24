import 'package:civiceye/core/error/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:civiceye/core/api/report_api.dart';
import 'package:civiceye/models/report_model.dart';


part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final _storage = const FlutterSecureStorage();

  ReportModel? currentReport;
  int totalReports = 0;

  Future<void> loadDashboardData() async {
    emit(HomeLoading());

    try {
      final empId = int.parse(await _storage.read(key: 'employeeId') ?? '0');

      final reports = await ReportApi.getReportsByEmployee(empId);
      totalReports = reports.length;

      ReportModel? current;
      try {
        current = reports.firstWhere((r) => r.currentStatus == 'قيد التنفيذ');
      } catch (_) {
        current = null;
      }

      currentReport = current;

      emit(HomeLoaded(
        currentReport: currentReport,
        totalReports: totalReports,
      ));
    } catch (e) {
      emit(HomeError(ExceptionHandler.handle(e)));
    }
  }
  Future<void> updateStatus(int reportId, String newStatus) async {
  emit(HomeLoading());

  try {
    final empId = int.parse(await _storage.read(key: 'employeeId') ?? '0');

    await ReportApi.updateStatus(
      reportId,
      newStatus,
      empId,
      notes: 'تم إنهاء البلاغ من الصفحة الرئيسية',
    );

    await loadDashboardData(); // نرجع نحمل البيانات من جديد بعد التحديث
  } catch (e) {
    emit(HomeError(ExceptionHandler.handle(e)));
  }
}
}