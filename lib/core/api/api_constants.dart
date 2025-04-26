class ApiConstants {
  static const String baseUrl = 'http://localhost:9090/api/V1';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static  String user = '$baseUrl/user';
  static String reports(int employeeId) => '$baseUrl/reports/employee/$employeeId';
  static const String updateStatus = '$baseUrl/reports/status';
}
