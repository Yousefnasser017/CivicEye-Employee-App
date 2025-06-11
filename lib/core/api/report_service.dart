import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:civiceye/core/api/api_constants.dart';
import 'package:civiceye/core/api/dio_consumer.dart';
import 'package:civiceye/core/error/api_exception.dart';
import 'package:civiceye/core/error/exceptions.dart';
import 'package:civiceye/models/report_model.dart';

class ReportApi {
  static final Dio _dio = DioConsumer.dio;

  static Future<List<ReportModel>> getReportsByEmployee(int employee) async {
    try {
      await LocalStorageHelper.getEmployee();
      final response = await _dio.get(
        ApiConstants.reports(employee),
        options: Options(
          extra: {'withCredentials': true}, // ✅ مهم جدًا
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => ReportModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to load reports',
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
  static Future<ReportModel> getReportDetails(int reportId) async {
    try {
      final response = await _dio.get(
        ApiConstants.reportDetails(reportId), // تأكد إنها موجودة عندك
        options: Options(
          extra: {'withCredentials': true},
        ),
      );

      if (response.statusCode == 200) {
        return ReportModel.fromJson(response.data);
      } else {
        throw ApiException(
          'Failed to fetch report details',
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


  static Future<ReportModel?> updateStatus(
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
        options: Options(
          extra: {'withCredentials': true}, // ✅
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to update status',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        ExceptionHandler.handle(e),
        e.response?.statusCode,
      );
    }
    return null;
  }
}
