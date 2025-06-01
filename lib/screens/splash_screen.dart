import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/cubits/splash_cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation;
  double opacity = 0.0;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200), // مدة الأنيميشن
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _positionAnimation = Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // نبدأ الأنيميشن ببطء
    _controller.forward().then((_) {
      // التأخير هنا لمنع الاختفاء السريع
      Future.delayed(const Duration(seconds: 1), () {
        // بعد الأنيميشن، نعرض اسم التطبيق
        setState(() {
          opacity = 1.0;
        });
      });
    });

    // تحديث عداد النقاط بين الحين والآخر
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = SplashCubit();
        cubit.checkLoginStatus();
        return cubit;
      },
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToHome) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is SplashNavigateToLogin) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // حركة الصورة من أسفل إلى المنتصف
                SlideTransition(
                  position: _positionAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset(
                        'assets/images/logo-white.png',
                        width: 180,
                      ),
                    ),
                  ),
                ),
              
                BlocBuilder<SplashCubit, SplashState>(
                  builder: (context, state) {
                    if (state is SplashInitial) {
                      return const CircularProgressIndicator();
                    }
                    return Container();  // لا شيء يظهر إذا لم تكن في حالة تحميل
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
