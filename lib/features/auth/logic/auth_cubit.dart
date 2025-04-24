import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:civiceye/core/api/auth_api.dart';
import 'package:civiceye/features/auth/logic/auth_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final _storage = const FlutterSecureStorage();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginPasswordVisibilityChanged());
  }

  Future<void> login(String email, String password) async {
    if (!formKey.currentState!.validate()) return;
    
    emit(LoginLoading());

    try {
      // تسجيل الدخول
      final loginResponse = await AuthApi.login(email, password);

      if (loginResponse.type != 'Employee') {
        emit(LoginFailure('ليس لديك صلاحية الوصول.'));
        return;
      }

      // حفظ اسم المستخدم
      await _storage.write(key: 'username', value: loginResponse.username);

      // جلب بيانات الموظف
      final userDataResponse = await AuthApi.getUserData();
      final data = userDataResponse.data;

      await _storage.write(key: 'fullName', value: data['fullName']);
      await _storage.write(key: 'department', value: data['department']);
      await _storage.write(key: 'city', value: data['cityName']);
      await _storage.write(key: 'gov', value: data['governorateName']);
      await _storage.write(key: 'employeeId', value: data['id'].toString());

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    try {
      await AuthApi.logout();
    } catch (_) {}
    await _storage.deleteAll();
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}