
import 'package:civiceye/models/report_model.dart';
import 'package:civiceye/models/user_model.dart';
import 'package:civiceye/screens/about_screen.dart';
import 'package:civiceye/screens/assigned_report_screen.dart';

import 'package:civiceye/screens/home_screen.dart';
import 'package:civiceye/screens/map_screen.dart';

import 'package:civiceye/screens/profile_screen.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:civiceye/screens/sign_in.dart';
import 'package:civiceye/screens/splash_screen.dart';
import 'package:flutter/material.dart';
class AppRouter {
  static EmployeeModel? employee;
  static ReportModel? report;
 
   

  


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) =>  const HomeScreen());
      case '/reports':
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case '/reportDetails':
      final report = settings.arguments as ReportModel;
      return MaterialPageRoute(
        builder: (_) => ReportDetailsScreen(
              report: report,
              reportId: report.reportId,
              employeeId: employee!.id.toString(), 
        ),
      );
      case '/map':
        return MaterialPageRoute(builder: (_) => MapScreen(
          latitude: (settings.arguments as Map<String, dynamic>?)?['latitude'],
          longitude: (settings.arguments as Map<String, dynamic>?)?['longitude'],
        ));
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}