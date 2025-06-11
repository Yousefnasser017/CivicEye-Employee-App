import 'package:civiceye/core/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioConsumer {
  static final Dio _dio = Dio()
    ..options.baseUrl = ApiConfig.baseUrl
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.receiveTimeout = const Duration(seconds: 30)
    ..options.sendTimeout= const Duration(seconds: 40)
    ..options.extra['withCredentials'] = true;

  static final CookieJar cookieJar = CookieJar();
 static Dio get dio {
    _dio.interceptors.clear();

    if (!kIsWeb) {
      _dio.interceptors.add(CookieManager(cookieJar));
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const storage = FlutterSecureStorage();
          final jwt = await storage.read(key: 'jwt');
          if (jwt != null) {
            options.headers['Cookie'] = 'jwt=$jwt';
          }
          debugPrint('➡ [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ [${response.statusCode}] Response received');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('❌ [${error.response?.statusCode}] ${error.message}');
          return handler.next(error);
        },
      ),
    );

    return _dio;
  }
}
