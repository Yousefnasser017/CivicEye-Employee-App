import 'dart:async';
import 'package:civiceye/animations/splash_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/cubits/splash_cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SplashAnimations splashAnimations;
  late Timer _dotTimer; // ✅ أضف هذا السطر
  double opacity = 0.0;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    splashAnimations = SplashAnimations(_controller);

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            opacity = 1.0;
          });
        }
      });
    });

    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _dotTimer.cancel(); // ✅ أضف هذا السطر لإيقاف التايمر
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
          body: Stack(
            fit: StackFit.expand,
            children: [
              // الخلفية المتحركة
              AnimatedBackgroundParticles(controller: _controller),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    splashAnimations.buildAnimatedLogoWithGlow(
                      child: Image.asset(
                        'assets/images/logo-white.png',
                        width: 180,
                      ),
                      width: 180,
                      glowColor: Colors.white,
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<SplashCubit, SplashState>(
                      builder: (context, state) {
                        if (state is SplashInitial) {
                          return splashAnimations.buildAnimatedLoadingIndicator(
                            color: Colors.white,
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
