// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:civiceye/animations/sign_in_animation.dart';
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/cubits/auth_cubit/auth_cubit.dart';
import 'package:civiceye/cubits/auth_cubit/auth_state.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/widgets/SnackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late SignInAnimationManager _animationManager;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _isKeyboardVisible = false;
  bool _isFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _animationManager = SignInAnimationManager();
    _animationManager.init(this);
    _setupFocusListeners();
    _startInitialAnimation();
  }


  void _setupFocusListeners() {
    _emailFocusNode.addListener(() {
      _onFocusChange(_emailFocusNode.hasFocus);
      if (_emailFocusNode.hasFocus) {
        HapticFeedback.lightImpact();
      }
    });
    
    _passwordFocusNode.addListener(() {
      _onFocusChange(_passwordFocusNode.hasFocus);
      if (_passwordFocusNode.hasFocus) {
        HapticFeedback.lightImpact();
      }
    });
  }

  void _startInitialAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {});
      _animationManager.fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationManager.slideController.forward();
    });
  }

  @override
  void dispose() {
    _animationManager.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFieldFocused = hasFocus || _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;
    });
    
    if (_isFieldFocused) {
      _animationManager.animationController.forward();
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_isFieldFocused) {
          _animationManager.animationController.reverse();
        }
      });
    }
  }

  void _onButtonPressed() {
    HapticFeedback.mediumImpact();
    _animationManager.buttonController.forward().then((_) {
      _animationManager.buttonController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    if (isKeyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }

    return BlocProvider(
      create: (context) => LoginCubit(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
      ),
      child: Theme(
        data: ThemeData.light(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF3E8FF), // بنفسجي فاتح جداً
                      Color(0xFFE9D5FF), // بنفسجي فاتح
                      Color(0xFFD8B4FE), // بنفسجي متوسط
                      Color(0xFFA78BFA), // بنفسجي واضح
                      Color(0xFF7C3AED), // بنفسجي غامق
                      Color(0xFF6D28D9), // بنفسجي داكن
                      Color(0xFF4F378B), // بنفسجي مزرق غامق
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                if (state is LoginFailure) {
                  HapticFeedback.heavyImpact();
                  SnackBarHelper.show(context, state.message,
                      type: SnackBarType.error);
                }
                if (state is LoginSuccess) {
                  HapticFeedback.lightImpact();
                  FocusScope.of(context).unfocus();
                 Future.delayed(Duration.zero, () {
                        if (!mounted) return;
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
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF8FAFC),
                          Color(0xFFE8EDFF),
                          Color(0xFFD6E1FF),
                          Color(0xFFB5C7F9),
                          Color(0xFF8BA8F9),
                          Color(0xFF6B8AE6),
                          Color(0xFF4C6FE0),
                        ],
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _animationManager.animationController,
                        _animationManager.slideController,
                        _animationManager.fadeController,
                      ]),
                      builder: (context, child) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: _isKeyboardVisible ? MainAxisAlignment.start : MainAxisAlignment.center,
                              children: [
                                // مساحة فارغة متحركة
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  height: _isKeyboardVisible ? 12 : 36,
                                  curve: Curves.easeInOutCubic,
                                ),
                                // الشعار مع انيميشن متقدم
                                _buildAnimatedLogo(),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  height: _isKeyboardVisible ? 5 : 15,
                                  curve: Curves.easeInOutCubic,
                                ),
                                // النص الترحيبي مع انيميشن
                                _buildWelcomeText(),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  height: _isKeyboardVisible ? 20 : 40,
                                  curve: Curves.easeInOutCubic,
                                ),
                                // النموذج مع الانيميشن
                                _buildAnimatedForm(cubit, state),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildAnimatedLogo() {
    return FadeTransition(
      opacity: _animationManager.fadeAnimation,
      child: Transform.translate(
        offset: Offset(0, -_animationManager.slideAnimation.value),
        child: Transform.scale(
          scale: _animationManager.logoSizeAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: _isKeyboardVisible ? 70 : 100,
            curve: Curves.easeInOutCubic,
            child: Hero(
              tag: 'app_logo',
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset('assets/images/logo-black.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return FadeTransition(
      opacity: _animationManager.fadeAnimation,
      child: Transform.translate(
        offset: Offset(0, -_animationManager.slideAnimation.value + 20),
        child: AnimatedOpacity(
          opacity: _isKeyboardVisible ? 0.6 : 1.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ).createShader(bounds),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              style: TextStyle(
                fontSize: _isKeyboardVisible ? 20 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
              child: const Text("مرحبا بك"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedForm(LoginCubit cubit, LoginState state) {
    return FadeTransition(
      opacity: _animationManager.fadeAnimation,
      child: Transform.translate(
        offset: Offset(0, _animationManager.formPositionAnimation.value - _animationManager.slideAnimation.value + 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  label: "البريد الالكتروني",
                  icon: Icons.email_outlined,
                  iconColor: AppColors.primary,
                  isPassword: false,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل البريد الإلكتروني';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'بريد إلكتروني غير صالح';
                    }
                    return null;
                  },
                  hint: "example@gmail.com",
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: "كلمة المرور",
                  icon: Icons.lock_outline,
                  iconColor: AppColors.primary,
                  isPassword: true,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  validator: (value) => value == null || value.isEmpty
                      ? 'أدخل كلمة المرور'
                      : null,
                  hint: "******",
                  obscureText: cubit.obscurePassword,
                  toggleObscureText: cubit.togglePasswordVisibility,
                ),
                const SizedBox(height: 20),
                _buildAnimatedLoginButton(context, cubit, state),
              ],
            ),
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
    required FocusNode focusNode,
    required String? Function(String?) validator,
    required String hint,
    bool obscureText = false,
    VoidCallback? toggleObscureText,
    required Color iconColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Tajawal',
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: focusNode.hasFocus ? AppColors.primary : Colors.grey[600],
            fontSize: 16,
            fontFamily: 'Tajawal',
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              icon,
              color: focusNode.hasFocus ? AppColors.primary : Colors.grey[600],
              size: 24,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    toggleObscureText?.call();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      key: ValueKey(obscureText),
                      color: AppColors.primary,
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: focusNode.hasFocus 
              ? AppColors.primary.withOpacity(0.05)
              : Colors.grey.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildAnimatedLoginButton(
      BuildContext context, LoginCubit cubit, LoginState state) {
    return AnimatedBuilder(
      animation: _animationManager.buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationManager.buttonScaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: state is LoginLoading 
                    ? [AppColors.primary, const Color(0xFF8BA8F9)]
                    : [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: (state is LoginLoading ? Colors.grey : AppColors.primary)
                      .withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: state is LoginLoading
                    ? null
                    : () {
                        _onButtonPressed();
                        if (_formKey.currentState!.validate()) {
                          cubit.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      },
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: state is LoginLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "الدخول",
                            key: ValueKey('login_text'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}