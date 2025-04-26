import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class DioConsumer {
  static final Dio _dio = Dio();

  static Dio get dio {
    if (!kIsWeb) {
      _dio.interceptors.add(CookieManager(CookieJar()));
    } else {
      // حل بديل للويب
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // إدارة الكوكيز يدوياً للويب
          options.headers['Cookie'] = _getCookiesForWeb();
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _saveCookiesForWeb(response.headers);
          return handler.next(response);
        }
      ));
    }
    return _dio;
  }

  static String _getCookiesForWeb() {
    // تطبيق منطق تخزين الكوكيز للويب (مثل استخدام shared_preferences)
    return '';
  }

  static void _saveCookiesForWeb(Headers headers) {
    // تطبيق منطق حفظ الكوكيز للويب
  }
}