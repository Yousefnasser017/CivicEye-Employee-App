import 'package:civiceye/core/api/report_api.dart';
import 'package:civiceye/features/reports/logic/report_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  List<ReportModel> _allReports = [];
  List<String> _activeFilters = [];

  List<ReportModel> get allReports => _allReports;
  List<ReportModel> get filteredReports => _applyFilters();
  List<String> get activeFilters => _activeFilters;

  Future<void> loadReports(int employeeId) async {
    emit(ReportsLoading(
      allReports: _allReports,
      filteredReports: _applyFilters(),
      filters: _activeFilters,
    ));
    try {
      _allReports = await ReportApi.getReportsByEmployee(employeeId);
      emit(ReportsLoaded(
        allReports: _allReports,
        filteredReports: _applyFilters(),
        filters: _activeFilters,
      ));
    } catch (e) {
      emit(ReportsError(
        message: e.toString().replaceAll('Exception: ', ''),
        allReports: _allReports,
        filteredReports: _applyFilters(),
        filters: _activeFilters,
      ));
    }
  }

  void filterBy(String status) {
    if (_activeFilters.contains(status)) {
      _activeFilters.remove(status);
    } else {
      _activeFilters.add(status);
    }
    emit(ReportsLoaded(
      allReports: _allReports,
      filteredReports: _applyFilters(),
      filters: List.from(_activeFilters),
    ));
  }

  void clearFilter() {
    _activeFilters.clear();
    emit(ReportsLoaded(
      allReports: _allReports,
      filteredReports: _allReports,
      filters: [],
    ));
  }

  List<ReportModel> _applyFilters() {
    if (_activeFilters.isEmpty) return _allReports;
    return _allReports.where((r) => _activeFilters.contains(r.currentStatus)).toList();
  }
}