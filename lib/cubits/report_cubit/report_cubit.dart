import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  int? _employeeId;
  bool _hasMore = true;
  final int _perPage = 10;

  List<String> statusFilters = [
    'All',
    'Submitted',
    'In_Progress',
    'On_Hold',
    'Resolved',
    'Cancelled'
  ];

  static const Map<String, String> statusLabels = {
    'All': 'الكل',
    'Submitted': 'تم الاستلام',
    'In_Progress': 'قيد التنفيذ',
    'On_Hold': 'قيد الانتظار',
    'Resolved': 'تم الحل',
    'Cancelled':'تم الالغاء' , 
  };

  String selectedStatus = 'All';
  List<ReportModel> _allReports = [];
  int? get employeeId => _employeeId;

  // تحميل ID الموظف
  Future<void> _loadEmployeeId() async {
    final employee = await LocalStorageHelper.getEmployee();
    _employeeId = employee?.id;
  }

  // جلب البلاغات
  Future<void> getReports() async {
    try {
      emit(ReportsLoading(report: []));  // حالة التحميل

      if (_employeeId == null) await _loadEmployeeId();
      if (_employeeId == null) {
        emit(ReportsError(message: 'لم يتم العثور على هوية الموظف'));
        return;
      }

      _hasMore = true;
      _allReports = await ReportApi.getReportsByEmployee(_employeeId!);

      final filtered = _applyFilter(_allReports);

      final inProgressReport = _allReports.firstWhere(
        (r) => r.currentStatus == 'In_Progress',
        orElse: () => ReportModel.empty(),
      );

      final latestReports = _allReports.take(3).toList();

      final reportCounts = {
        for (var status in statusFilters.where((s) => s != 'All')) status: 0,
      };

      for (var report in _allReports) {
        if (reportCounts.containsKey(report.currentStatus)) {
          reportCounts[report.currentStatus] =
              reportCounts[report.currentStatus]! + 1;
        }
      }

      emit(ReportsLoaded(
        report: filtered.take(_perPage).toList(),
        hasMore: filtered.length > _perPage,
        inProgressReport: inProgressReport,
        latestReports: latestReports,
        reportCountsByStatus: reportCounts,
      ));
    } catch (_) {
      emit(ReportsError(message: 'حدث خطأ أثناء تحميل البلاغات'));
    }
  }

  // تصفية البلاغات حسب الحالة
  void filterByStatus(String status) {
    selectedStatus = status;
    getReports();
  }

  // تطبيق الفلتر على البلاغات
  List<ReportModel> _applyFilter(List<ReportModel> all) {
    if (selectedStatus == 'All') return all;
    return all.where((r) => r.currentStatus == selectedStatus).toList();
  }

  // تحميل المزيد من البلاغات
  Future<void> loadMoreReports() async {
    if (!_hasMore || state is ReportsLoading || state is ReportsError) return;

    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    try {
      final filtered = _applyFilter(_allReports);
      final current = currentState.report;
      final nextPage = filtered.skip(current.length).take(_perPage).toList();
      final allLoaded = [...current, ...nextPage];

      emit(ReportsLoaded(
        report: allLoaded,
        hasMore: filtered.length > allLoaded.length,
        inProgressReport: currentState.inProgressReport,
        latestReports: currentState.latestReports,
        reportCountsByStatus: currentState.reportCountsByStatus,
      ));
    } catch (_) {
      emit(ReportsError(message: 'حدث خطأ أثناء تحميل المزيد'));
    }
  }

  // تحديث حالة البلاغ
  Future<void> updateReportStatus(int reportId, String newStatus) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    try {
      emit(ReportsLoading(report: currentState.report)); // حالة التحميل

      await ReportApi.updateStatus(reportId, newStatus, _employeeId!);

      final updatedReports = currentState.report.map((report) {
        if (report.reportId == reportId) {
          return report.copyWith(currentStatus: newStatus);
        }
        return report;
      }).toList();

      // تحديث البيانات الرئيسية
      final inProgressReport = updatedReports.firstWhere(
        (r) => r.currentStatus == 'In_Progress',
        orElse: () => ReportModel.empty(),
      );

      final latestReports = _allReports.take(3).toList();

      final reportCounts = {
        for (var status in statusFilters.where((s) => s != 'All')) status: 0,
      };

      for (var report in _allReports) {
        if (reportCounts.containsKey(report.currentStatus)) {
          reportCounts[report.currentStatus] =
              reportCounts[report.currentStatus]! + 1;
        }
      }

      emit(ReportsLoaded(
        report: updatedReports,
        hasMore: currentState.hasMore,
        inProgressReport: inProgressReport,
        latestReports: latestReports,
        reportCountsByStatus: reportCounts,
      ));
    } catch (_) {
      emit(ReportsError(message: 'حدث خطأ أثناء تحديث حالة البلاغ'));
    }
  }
}
