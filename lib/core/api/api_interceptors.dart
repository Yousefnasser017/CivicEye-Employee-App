
import 'package:civiceye/core/storage/storage_service.dart';
import 'package:dio/dio.dart';


class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // جلب التوكن من StorageService بدلاً من CacheHelper مباشرة
    final token = await StorageService.getToken();
    
    // إضافة التوكن إلى الهيدر إن وجد
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

 

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // يمكنك معالجة الردود هنا (مثال: حفظ توكن جديد)
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // معالجة أخطاء محددة مثل 401 (غير مصرح به)
    if (err.response?.statusCode == 403) {
      // توجيه المستخدم لشاشة تسجيل الدخول
    }
    super.onError(err, handler);
  }
}