// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math';
class AnimatedBackgroundParticles extends StatefulWidget {
  final AnimationController controller;
  const AnimatedBackgroundParticles({Key? key, required this.controller})
      : super(key: key);

  @override
  State<AnimatedBackgroundParticles> createState() =>
      _AnimatedBackgroundParticlesState();
}

class _AnimatedBackgroundParticlesState
    extends State<AnimatedBackgroundParticles> {
  final int particleCount = 18;
  late List<_Particle> particles;

  @override
  void initState() {
    super.initState();
    final random = Random();
    particles = List.generate(particleCount, (i) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = 80.0 + random.nextDouble() * 120;
      final speed = 0.5 + random.nextDouble();
      final size = 12.0 + random.nextDouble() * 18;
      final color = Colors.white.withOpacity(0.2 + random.nextDouble() * 0.4);
      return _Particle(angle, radius, speed, size, color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final t = widget.controller.value;
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(particles, t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.purple.shade700,
                  Colors.teal.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5 + 0.2 * sin(t * pi), 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Particle {
  double angle;
  double radius;
  double speed;
  double size;
  Color color;
  _Particle(this.angle, this.radius, this.speed, this.size, this.color);
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ParticlesPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final p in particles) {
      final a = p.angle + t * 2 * pi * p.speed;
      final r = p.radius + 18 * sin(t * pi * p.speed);
      final pos = center + Offset(cos(a), sin(a)) * r;
      final paint = Paint()
        ..color = p.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size / 2);
      canvas.drawCircle(pos, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SplashAnimations {
  final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> rotateAnimation;
  late final Animation<double> bounceAnimation;

  SplashAnimations(this.controller) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    ));
  }

  /// شعار مع توهج متغير (Glow)
  Widget buildAnimatedLogoWithGlow({
    required Widget child,
    required double width,
    Color glowColor = Colors.white,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final glowStrength = 0.6 + 0.4 * sin(controller.value * 2 * 3.14159);
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(glowStrength),
                blurRadius: 32 + 16 * glowStrength,
                spreadRadius: 4 + 2 * glowStrength,
              ),
            ],
          ),
          child: buildAnimatedLogo(child: child, width: width),
        );
      },
    );
  }

  Widget buildAnimatedLogo({
    required Widget child,
    required double width,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.rotate(
          angle: rotateAnimation.value * 3.14159,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Opacity(
              opacity: fadeAnimation.value,
              child: SlideTransition(
                position: slideAnimation,
                child: Transform.translate(
                  offset: Offset(0, -20 * bounceAnimation.value),
                  child: SizedBox(
                    width: width,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAnimatedLoadingIndicator({
    required Color color,
    double strokeWidth = 3.0,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Transform.scale(
          scale: 0.8 + (0.2 * bounceAnimation.value),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color.withOpacity(fadeAnimation.value),
            ),
            strokeWidth: strokeWidth,
          ),
        );
      },
    );
  }
}
