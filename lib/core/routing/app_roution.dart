import 'package:civiceye/features/about/about_screen.dart';
import 'package:civiceye/features/auth/screen/sign_in.dart';
import 'package:civiceye/features/home/screen/home_screen.dart';
import 'package:civiceye/features/profile/screen/profile_screen.dart';
import 'package:civiceye/features/reports/screen/assigned_report_screen.dart';
// import 'package:civiceye/features/reports/screen/map_screen.dart';
import 'package:civiceye/features/reports/screen/report_details.dart';
import 'package:civiceye/features/splash/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/reports':
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case '/report_details':
        return MaterialPageRoute(builder: (_) => const ReportDetailsScreen());
      // case '/map':
      //   return MaterialPageRoute(builder: (_) => const MapScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
