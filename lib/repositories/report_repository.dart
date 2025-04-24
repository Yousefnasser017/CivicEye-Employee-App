import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/core/api/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ReportRepository {
  final Dio _dio;
  final CookieJar _cookieJar;

  ReportRepository({Dio? dio, CookieJar? cookieJar})
      : _dio = dio ?? Dio(),
        _cookieJar = cookieJar ?? CookieJar() {
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  Future<List<ReportModel>> fetchReports(String adminId) async {
    try {
      final response = await _dio.get(
        '/reports',
        queryParameters: {'adminId': adminId},
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((data) => ReportModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Connection error: ${e.message}');
    }
  }

  Future<void> updateReportStatus(int reportId, String status) async {
    try {
      await _dio.put(
        '/reports/$reportId/status',
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update status: ${e.message}');
    }
  }

  Future<void> clearCookies() async {
    await _cookieJar.delete(Uri.parse(ApiConstants.baseUrl));
  }
}