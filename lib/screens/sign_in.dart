// ignore_for_file: use_build_context_synchronously
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/auth_cubit/auth_cubit.dart';
import 'package:civiceye/cubits/auth_cubit/auth_state.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
      ),
      child: Theme(
        data: ThemeData.light(),
        child: Scaffold(
          body: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
          
              if (state is LoginFailure) {
                SnackBarHelper.show(context, state.message,type: SnackBarType.error );
              }
           if (state is LoginSuccess) {
                
                Future.microtask(() async {
                  context.read<ReportsCubit>().clear();
                  SnackBarHelper.show(context, "تم تسجيل الدخول بنجاح",
                      type: SnackBarType.success);

                  Navigator.pushReplacementNamed(context, '/home');
                });
              }
            },  
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset('assets/images/logo-black.png', height: 100),
                        const SizedBox(height: 10),
                        const Text(
                          "مرحبا بك",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 40),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                label: "البريد الالكتروني",
                                icon: Icons.email_outlined,
                                iconColor: AppColors.primary,
                                isPassword: false,
                                controller: _emailController,
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'أدخل البريد الإلكتروني';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'بريد إلكتروني غير صالح';
                                    }
                                    return null;
                                  },
                                hint: "example@gmail.com",
                              ),
                              _buildTextField(
                                label: "كلمة المرور",
                                icon: Icons.lock_outline,
                                iconColor:AppColors.primary,
                                isPassword: true,
                                controller: _passwordController,
                                validator: (value) =>
                                    value == null || value.isEmpty ? 'أدخل كلمة المرور' : null,
                                hint: "******",
                                obscureText: cubit.obscurePassword,
                                toggleObscureText: cubit.togglePasswordVisibility,
                              ),
                              _buildLoginButton(context, cubit, state),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool isPassword,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required String hint,
    bool obscureText = false,
    VoidCallback? toggleObscureText, required  iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2.0),
          ),
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.grey, fontSize: 18, fontFamily: 'Tajawal'),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          prefixIcon: Icon(icon, color: iconColor, size: 24),
          suffixIcon: isPassword
                    ? IconButton(
                        onPressed: toggleObscureText,
                        icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.primary),
                      )
                    : null,
                        ),  
        validator: validator,
      ),
    );
  }

Widget _buildLoginButton(
    BuildContext context, LoginCubit cubit, LoginState state) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(10),
    child: MaterialButton(
      onPressed: state is LoginLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                cubit.login(
                  _emailController.text.trim(), 
                  _passwordController.text.trim(),
                );
              }
            },
      color: AppColors.primary,
      height: 60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: state is LoginLoading
          ? const CircularProgressIndicator(color: AppColors.primary)
          : const Text(
              "الدخول",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}

}