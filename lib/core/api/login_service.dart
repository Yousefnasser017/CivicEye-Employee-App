import 'package:civiceye/core/api/dio_consumer.dart';
import 'package:civiceye/core/error/api_exception.dart';

import 'package:civiceye/core/api/api_constants.dart';
import 'package:civiceye/core/error/exceptions.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/models/sign_in_model.dart';
import 'package:civiceye/screens/sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthApi {
  static final Dio _dio = DioConsumer.dio;

  /// تسجيل الدخول
  static Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'username': email, 'password': password},
      );

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

  /// تسجيل الخروج
  static Future<void> logout(BuildContext context) async {
    try {
      final response = await _dio.get(ApiConstants.logout);
       if (response.statusCode == 200) {
      await LocalStorageHelper .clearAll(); // أو clear() لكل البيانات

      // إعادة التوجيه لصفحة الدخول
        Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
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

  /// جلب بيانات المستخدم
  static Future<Response> getUserData() async {
    try {
      final response = await _dio.get(ApiConstants.user);

      if (response.statusCode == 200) {
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
}