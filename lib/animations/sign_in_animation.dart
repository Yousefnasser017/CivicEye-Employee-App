import 'package:flutter/material.dart';

class SignInAnimationManager {
  late AnimationController animationController;
  late AnimationController slideController;
  late AnimationController fadeController;
  late AnimationController buttonController;

  late Animation<double> logoSizeAnimation;
  late Animation<double> formPositionAnimation;
  late Animation<double> slideAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> buttonScaleAnimation;

  void init(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );
    slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: vsync,
    );

    logoSizeAnimation = Tween<double>(
      begin: 1.18,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    ));

    formPositionAnimation = Tween<double>(
      begin: 0.0,
      end: -35.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    ));

    slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOutCubic,
    ));

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    ));

    buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: buttonController,
      curve: Curves.easeInOut,
    ));
  }

  void dispose() {
    animationController.dispose();
    slideController.dispose();
    fadeController.dispose();
    buttonController.dispose();
  }
}
