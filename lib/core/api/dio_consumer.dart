import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConsumer {
  static final Dio _dio = Dio()
    ..options.baseUrl = 'http://localhost:8000' // استبدل بـ URL الخاص بـ API الخاص بك
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 10)
    ..options.extra['withCredentials'] = true; // يفعّل إرسال واستقبال الكوكيز (مهم جداً لـ Flutter Web)

  static Dio get dio {
    _dio.interceptors.clear(); // منع التكرار

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡ [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ [${response.statusCode}] ${response.data}');
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
