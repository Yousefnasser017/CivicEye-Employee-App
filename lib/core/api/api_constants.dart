import 'package:civiceye/core/config/app_config.dart';


class ApiConstants {
  static String get baseUrl => ApiConfig.baseUrl;

  static String get login => '$baseUrl/login';
  static String get logout => '$baseUrl/logout';
  static String get user => '$baseUrl/user';
  static String reports(int employeeId) =>
      '$baseUrl/reports/employee/$employeeId';
  static String reportDetails(int reportId) => '$baseUrl/reports/$reportId';
  static String get updateStatus => '$baseUrl/reports/status';
}
