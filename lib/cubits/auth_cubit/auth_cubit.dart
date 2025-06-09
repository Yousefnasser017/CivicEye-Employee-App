import 'package:civiceye/core/api/login_service.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/error/api_exception.dart';
import 'package:civiceye/core/error/exceptions.dart';
import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:civiceye/models/sign_in_model.dart';
import 'package:civiceye/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FlutterSecureStorage _storage;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
 final webSocketService = StompWebSocketService();

  bool obscurePassword;

  LoginCubit({
    FlutterSecureStorage? storage,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    this.obscurePassword = true,
  }) : _storage = storage ?? const FlutterSecureStorage(),
      super(LoginInitial());

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginPasswordVisibilityChanged(obscurePassword));
  }

Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(LoginFailure('البريد الإلكتروني وكلمة المرور مطلوبان'));
      return;
    }

    emit(LoginLoading());

    try {
      final loginResponse = await AuthApi.login(email, password);

      if (loginResponse.type != 'Employee') {
        emit(LoginFailure('ليس لديك صلاحية الوصول لهذا التطبيق'));
        return;
      }

      webSocketService.connect();
      await _saveUserData(loginResponse);
      emit(LoginSuccess());
    } on ApiException catch (e) {
      // معالجة أخطاء الـ API المخصصة
      emit(LoginFailure(_handleApiError(e)));
    } catch (e) {
      // معالجة الأخطاء العامة
      emit(LoginFailure(_handleGeneralError(e)));
    }
  }

// دالة لمعالجة أخطاء الـ API
  String _handleApiError(ApiException e) {
    switch (e.statusCode) {
      case 401:
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 403:
        return e.message.isNotEmpty ? e.message : 'ليس لديك صلاحية الوصول';
      case 404:
        return 'البريد الإلكتروني غير مسجل في النظام';
      case 422:
        return 'بيانات غير صحيحة، تأكد من البريد الإلكتروني وكلمة المرور';
      case 429:
        return 'عدد كبير من المحاولات، حاول مرة أخرى بعد قليل';
      case 500:
        return 'مشكلة في الخادم، حاول مرة أخرى';
      case 503:
        return 'الخدمة غير متاحة حالياً، حاول مرة أخرى لاحقاً';
      default:
        return e.message.isNotEmpty ? e.message : 'حدث خطأ غير متوقع';
    }
  }

// دالة لمعالجة الأخطاء العامة
  String _handleGeneralError(dynamic error) {
    String errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('socket') ||
        errorMessage.contains('network') ||
        errorMessage.contains('connection')) {
      return 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
    } else if (errorMessage.contains('timeout')) {
      return 'انتهت مهلة الاتصال، حاول مرة أخرى';
    } else if (errorMessage.contains('format') ||
        errorMessage.contains('parse')) {
      return 'خطأ في تنسيق البيانات';
    } else {
      // استخدم الـ ExceptionHandler إذا كان متاح
      try {
        return ExceptionHandler.handle(error);
      } catch (e) {
        return 'حدث خطأ غير متوقع، حاول مرة أخرى';
      }
    }
  }

   Future<void> _saveUserData(LoginResponseModel loginResponse) async {
    // ... (نفس الكود السابق)
    await _storage.write(key: 'username', value: loginResponse.username);

    final userDataResponse = await AuthApi.getUserData();
    final data = userDataResponse.data;

  await LocalStorageHelper.saveEmployee(EmployeeModel(
      id: data['id'],
      fullName: data['fullName'],
      email: loginResponse.username,
      department: data['department'],
      cityName: data['cityName'],
      governorateName: data['governorateName'],
      nationalId: '', // أو حط القيمة لو كانت متاحة
      firstName: '', // إن أردت
      lastName: '',
      level: [],
    ));

  }
  Future<void> logout() async {
    try {
      await AuthApi.logout();
      await LocalStorageHelper.clearAll(); // 🟢 استخدم الهيلبر
      emit(LoginInitial());
    } catch (e) {
      throw Exception('Failed to logout');
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}