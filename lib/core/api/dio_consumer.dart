import 'package:civiceye/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:civiceye/core/api/api_constants.dart';

class DioConsumer {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ))..interceptors.add(LogInterceptor(responseBody: true));

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      throw Exception(ExceptionHandler.handle(e));
    }
  }
}
