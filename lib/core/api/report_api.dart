import 'package:civiceye/core/api/dio_consumer.dart';
import 'package:civiceye/core/error/exceptions.dart';
import 'package:civiceye/core/api/api_constants.dart';
import 'package:civiceye/models/report_model.dart';

class ReportApi {
  static final _dio = DioConsumer();

  /// جلب البلاغات الخاصة بفني معين
  static Future<List<ReportModel>> getReportsByEmployee(int employeeId) async {
    try {
      final response = await _dio.get(ApiConstants.reports(employeeId));
      return (response.data as List)
          .map((json) => ReportModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }

  /// تحديث حالة بلاغ
  static Future<void> updateStatus(int reportId, String newStatus, int employeeId, {String? notes}) async {
    try {
      await _dio.put(ApiConstants.updateStatus, data: {
        'reportId': reportId,
        'newStatus': newStatus,
        'employeeId': employeeId,
        'notes': notes ?? '',
      });
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }
}
