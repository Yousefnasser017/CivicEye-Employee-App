import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'report_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  final _storage = const FlutterSecureStorage();
  List<ReportModel> _all = [];
  List<String> _filters = [];

  Future<void> loadReports() async {
    emit(ReportsLoading());

    try {
      final empId = int.parse(await _storage.read(key: 'employeeId') ?? '0');
      _all = await ReportApi.getReportsByEmployee(empId);
      emit(ReportsLoaded(
        allReports: _all,
        filteredReports: _applyFilters(),
        filters: _filters,
        currentReport: _getCurrent(),
      ));
    } catch (e) {
      emit(ReportsError("فشل تحميل البلاغات"));
    }
  }

  Future<void> refreshReports() async {
    await loadReports();
  }

  void filterBy(String status) {
    if (_filters.contains(status)) {
      _filters.remove(status);
    } else {
      _filters.add(status);
    }
    emit(ReportsLoaded(
      allReports: _all,
      filteredReports: _applyFilters(),
      filters: _filters,
      currentReport: _getCurrent(),
    ));
  }

  void clearFilter() {
    _filters.clear();
    emit(ReportsLoaded(
      allReports: _all,
      filteredReports: _all,
      filters: [],
      currentReport: _getCurrent(),
    ));
  }

  Future<void> markAsResolved(ReportModel report) async {
    try {
      final empId = int.parse(await _storage.read(key: 'employeeId') ?? '0');
      await ReportApi.updateStatus(report.reportId, 'تم الحل', empId, notes: 'تم إنهاؤه من صفحة البلاغات');
      await loadReports();
    } catch (_) {
      emit(ReportsError("فشل تحديث حالة البلاغ"));
    }
  }

  List<ReportModel> _applyFilters() {
    if (_filters.isEmpty) return _all;
    return _all.where((r) => _filters.contains(r.currentStatus)).toList();
  }

  ReportModel? _getCurrent() {
    try {
      return _all.firstWhere((r) => r.currentStatus == 'قيد التنفيذ');
    } catch (_) {
      return null;
    }
  }
}