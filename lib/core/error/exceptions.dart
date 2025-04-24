import 'dart:io';
import 'package:dio/dio.dart';
import 'package:civiceye/core/error/api_exception.dart';

class ExceptionHandler {
  static String handle(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }

    if (error is SocketException) {
      return 'لا يوجد اتصال بالإنترنت.';
    }

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'انتهت مهلة الاتصال، يرجى المحاولة لاحقًا.';
      }

      if (error.response != null) {
        final statusCode = error.response!.statusCode ?? 0;

        switch (statusCode) {
          case 400:
            return 'طلب غير صالح. تأكد من البيانات المدخلة.';
          case 401:
            return 'غير مصرح، قد تكون الجلسة منتهية.';
          case 403:
            return 'بيانات الدخول غير صحيحة.';
          case 404:
            return 'العنصر المطلوب غير موجود.';
          case 500:
            return 'خطأ من الخادم، حاول لاحقًا.';
          default:
            return 'خطأ غير متوقع: ${error.response?.statusMessage ?? 'حدث خطأ'}';
        }
      } else {
        return 'فشل في الاتصال بالخادم.';
      }
    }

    return 'حدث خطأ غير متوقع.';
  }
}
