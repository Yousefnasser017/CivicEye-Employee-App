import 'package:civiceye/core/api/login_service.dart';
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
    emit(LoginFailure('Email or password cannot be empty'));
    return;
  }

    emit(LoginLoading());

    try {
      // final email = emailController.text.trim();
      // final password = passwordController.text.trim();

      final loginResponse = await AuthApi.login(email, password);

      if (loginResponse.type != 'Employee') {
        throw ApiException('ليس لديك صلاحية الوصول.', 403);
      }
      

      await _saveUserData(loginResponse);
      emit(LoginSuccess());
    } on ApiException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(LoginFailure(ExceptionHandler.handle(e)));
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