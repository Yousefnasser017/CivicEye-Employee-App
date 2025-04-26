import 'dart:io';
import 'package:dio/dio.dart';
import 'package:civiceye/core/error/api_exception.dart';
import 'package:logger/logger.dart';

class ExceptionHandler {
  static final _logger = Logger();

  static String handle(dynamic error) {
    _logger.e('حدث خطأ', error: error, stackTrace: StackTrace.current);

    if (error is ApiException) {
      return error.message;
    }

    // معالجة أخطاء الشبكة والاتصال
    if (error is SocketException || error is IOException) {
      return 'تعذر الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
    }

    // معالجة أخطاء Dio بشكل شامل
    if (error is DioException) {
      return _handleDioError(error);
    }

    // معالجة الأخطاء العامة
    return _handleGenericError(error);
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
      
      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم. يرجى التأكد من اتصال الشبكة.';
      
      case DioExceptionType.badCertificate:
        return 'مشكلة في شهادة الأمان. يرجى الاتصال بالدعم الفني.';
      
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response!);
      
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب.';
      
      case DioExceptionType.unknown:
        return 'حدث خطأ غير متوقع في الاتصال.';
    }
  }

  static String _handleResponseError(Response response) {
    final statusCode = response.statusCode ?? 0;
    final message = response.statusMessage ?? 'حدث خطأ';

    switch (statusCode) {
      case 400:
        return 'طلب غير صالح: $message';
      case 401:
        return 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.';
      case 403:
        return 'ليس لديك صلاحية للوصول   .';
      case 404:
        return 'لم يتم العثور على المورد المطلوب.';
      case 409:
        return 'تعارض في البيانات. يرجى التحقق والمحاولة مرة أخرى.';
      case 429:
        return 'عدد الطلبات كبير جداً. يرجى المحاولة لاحقاً.';
      case 500:
      case 502:
      case 503:
        return 'مشكلة في الخادم. يرجى المحاولة لاحقاً.';
      default:
        return 'خطأ في الاتصال: $message (كود الخطأ: $statusCode)';
    }
  }

  static String _handleGenericError(dynamic error) {
    if (error is String) {
      return error;
    }
    return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
  }
}