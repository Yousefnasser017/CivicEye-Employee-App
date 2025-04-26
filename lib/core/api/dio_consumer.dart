import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:civiceye/core/api/api_constants.dart';

class DioConsumer {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )
    ..interceptors.add(CookieManager(CookieJar()))
    ..interceptors.add(LogInterceptor(responseBody: true));

  static Dio get dio => _dio;
}