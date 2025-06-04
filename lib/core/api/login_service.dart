import 'package:civiceye/core/api/dio_consumer.dart';
import 'package:civiceye/core/error/api_exception.dart';
import 'package:civiceye/core/api/api_constants.dart';
import 'package:civiceye/core/error/exceptions.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/models/sign_in_model.dart';
import 'package:civiceye/models/user_model.dart';
import 'package:dio/dio.dart';



class AuthApi {
  static final Dio _dio = DioConsumer.dio;
  
  /// تسجيل الدخول
  static Future<LoginResponseModel> login(String email, String password) async {
    try {
    final response = await _dio.post(
        ApiConstants.login,
        data: {'username': email, 'password': password},
        options: Options(
          extra: {'withCredentials': true}, 
        ),
      );
      // final uri = Uri.parse('${ApiConstants.login}');
      // final cookies = await DioConsumer.cookieJar.loadForRequest(uri);
      // print("✅ Cookies بعد تسجيل الدخول: $cookies");
      //      // تأكد من التطابق التام مع baseUrl

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw ApiException(
          'فشل تسجيل الدخول: ${response.statusMessage}',
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



  /// جلب بيانات المستخدم
  static Future<Response> getUserData() async {
    try {
     final response = await _dio.get(
        ApiConstants.user,
        options: Options(
          extra: {'withCredentials': true}, // ✅ مهم جدًا لإرسال الكوكيز
        ),
      );


      if (response.statusCode == 200) {
        final employee = EmployeeModel.fromJson(response.data);
        await LocalStorageHelper.saveEmployee(employee);
        return response;
      } else {
        throw ApiException(
          'فشل جلب بيانات المستخدم: ${response.statusMessage}',
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
    /// تسجيل الخروج
static Future<bool> logout() async {
    try {
      
      final response = await _dio.get(
        ApiConstants.logout,
        options: Options(
          extra: {'withCredentials': true}, // ✅ لإرسال الكوكيز مع الطلب
        ),
      );

      if (response.statusCode == 200) {
        try {
          await LocalStorageHelper.clearAll();
        } catch (e) {
          // ممكن تسجل الخطأ، أو تعيد رميه حسب احتياجك
          print('Failed to clear local storage on logout: $e');
        }
        return true;
      } else {
        throw ApiException(
          'فشل تسجيل الخروج: ${response.statusMessage}',
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


}