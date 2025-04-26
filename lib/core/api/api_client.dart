import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static final CookieJar _cookieJar = CookieJar();

  static Dio getDio() {
    _dio.interceptors.add(CookieManager(_cookieJar)); // ✅ يدير الكوكيز تلقائيًا
    return _dio;
  }
}