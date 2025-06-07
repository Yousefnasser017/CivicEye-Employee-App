import 'package:civiceye/core/api/report_service.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/cubits/report_cubit/report_state.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({String initialStatus = 'All'})
      : selectedStatus = initialStatus,
        super(ReportsInitial());
        
  int? _employeeId;
  bool _hasMore = true;
  final int _perPage = 10;

  final List<String> statusFilters = [
    'All',
    'Submitted',
    'In_Progress',
    'On_Hold',
    'Resolved',
    'Cancelled',
  ];

  static const Map<String, String> statusLabels = {
    'All': 'الكل',
    'Submitted': 'تم الاستلام',
    'In_Progress': 'قيد التنفيذ',
    'On_Hold': 'قيد الانتظار',
    'Resolved': 'تم الحل',
    'Cancelled': 'تم الإلغاء',
  };

  String selectedStatus;
  List<ReportModel> _allReports = [];

  int? get employeeId => _employeeId;

  // تحميل رقم الموظف من التخزين المحلي

  Future<void> _loadEmployeeId() async {
    final employee = await LocalStorageHelper.getEmployee();
    _employeeId = employee?.id;
  }
  void clear() {
    _employeeId = null;
    _allReports.clear();
    _hasMore = true;
    selectedStatus = 'All';
    emit(ReportsInitial());
  }

  // جلب البلاغات كاملة من API وتطبيق الفلاتر المحلية
  Future<void> getReports() async {
    try {
      emit(ReportsLoading(report: []));

     
        await _loadEmployeeId();
      
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

      final reportCounts = _calculateReportCounts(_allReports);

      emit(ReportsLoaded(
        report: filtered.take(_perPage).toList(),
        hasMore: filtered.length > _perPage,
        inProgressReport: inProgressReport,
        latestReports: latestReports,
        reportCountsByStatus: reportCounts,
      ));
    } catch (e) {
      emit(ReportsError(message: 'حدث خطأ أثناء تحميل البلاغات'));
    }
  }

  // تطبيق فلتر الحالة على قائمة البلاغات
  List<ReportModel> _applyFilter(List<ReportModel> allReports) {
    if (selectedStatus == 'All') return allReports;
    return allReports.where((r) => r.currentStatus == selectedStatus).toList();
  }

  // حساب عدد البلاغات حسب الحالة
  Map<String, int> _calculateReportCounts(List<ReportModel> reports) {
    final counts = <String, int>{};
    for (var status in statusFilters) {
      if (status != 'All') counts[status] = 0;
    }
    for (var report in reports) {
      if (counts.containsKey(report.currentStatus)) {
        counts[report.currentStatus] = counts[report.currentStatus]! + 1;
      }
    }
    return counts;
  }

  // تغيير فلتر الحالة وإعادة جلب البلاغات مع الفلترة
  Future<void> filterByStatus(String status) async {
    selectedStatus = status;
    await getReports();
  }

  // تحميل المزيد من البلاغات (Pagination)
  Future<void> loadMoreReports() async {
    if (!_hasMore) return;
    if (state is! ReportsLoaded) return;

    try {
      final currentState = state as ReportsLoaded;
      final filtered = _applyFilter(_allReports);

      final currentLength = currentState.report.length;
      final nextItems = filtered.skip(currentLength).take(_perPage).toList();

      final updatedList = [...currentState.report, ...nextItems];
      _hasMore = filtered.length > updatedList.length;

      emit(ReportsLoaded(
        report: updatedList,
        hasMore: _hasMore,
        inProgressReport: currentState.inProgressReport,
        latestReports: currentState.latestReports,
        reportCountsByStatus: currentState.reportCountsByStatus,
      ));
    } catch (e) {
      emit(ReportsError(message: 'حدث خطأ أثناء تحميل المزيد من البلاغات'));
    }
  }

  // تحديث حالة البلاغ في الـ API ثم تحديث الحالة محليًا
  Future<void> updateReportStatus({
    required int reportId,
    required String newStatus,
    required String notes,
  }) async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;

    try {
      emit(ReportsLoading(report: currentState.report));

      await ReportApi.updateStatus(reportId, newStatus, _employeeId!,
          notes: notes);

      // تحديث القائمة محليًا
      final updatedReports = currentState.report.map((report) {
        if (report.reportId == reportId) {
          return report.copyWith(currentStatus: newStatus);
        }
        return report;
      }).toList();

      final inProgressReport = updatedReports.firstWhere(
        (r) => r.currentStatus == 'In_Progress',
        orElse: () => ReportModel.empty(),
      );

      final latestReports = _allReports.take(3).toList();
      final reportCounts = _calculateReportCounts(_allReports);

      emit(ReportsLoaded(
        report: updatedReports,
        hasMore: currentState.hasMore,
        inProgressReport: inProgressReport,
        latestReports: latestReports,
        reportCountsByStatus: reportCounts,
      ));
    } catch (e) {
      emit(ReportsError(message: 'حدث خطأ أثناء تحديث حالة البلاغ'));
    }
  }
}
