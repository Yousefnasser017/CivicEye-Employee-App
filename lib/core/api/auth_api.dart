import 'package:civiceye/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:civiceye/core/api/api_constants.dart';
import 'package:civiceye/models/sign_in_model.dart';

class AuthApi {
  static final  _dio = Dio();

  static Future<LoginResponseModel> login(String emailController, String passwordController) async {
    try {
      final res = await _dio.post(ApiConstants.login, data: {
        'username': emailController,
        'password': passwordController,
      });
      return LoginResponseModel.fromJson(res.data);
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }

  static Future<void> logout() async {
    try {
      await _dio.get(ApiConstants.logout);
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }

  static Future<Response> getUserData() async {
    try {
      return await _dio.get(ApiConstants.user);
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }
}
