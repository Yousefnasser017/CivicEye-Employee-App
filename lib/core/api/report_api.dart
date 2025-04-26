import 'package:civiceye/core/api/dio_consumer.dart';
import 'package:civiceye/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:civiceye/core/api/api_constants.dart';
import 'package:civiceye/core/error/api_exception.dart';
import 'package:civiceye/models/report_model.dart';

class ReportApi {
  static final Dio _dio = DioConsumer.dio; // استخدام DioConsumer الموحد

  static Future<List<ReportModel>> getReportsByEmployee(int employeeId) async {
    try {
      final response = await _dio.get(
        ApiConstants.reports(employeeId),
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ReportModel.fromJson(json))
            .toList();
      } else {
        throw ApiException(
          'Failed to load reports: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        ExceptionHandler.handle(e),
        e.response?.statusCode,
      );
    }
  }

  static Future<void> updateStatus(
    int reportId,
    String newStatus,
    int employeeId, {
    String? notes,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.updateStatus,
        data: {
          'reportId': reportId,
          'newStatus': newStatus,
          'employeeId': employeeId,
          'notes': notes ?? '',
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to update status: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        ExceptionHandler.handle(e),
        e.response?.statusCode,
      );
    }
  }
}