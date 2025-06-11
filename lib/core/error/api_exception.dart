class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data; 
  ApiException(
    this.message, [
    this.statusCode,
    this.data,
  ]);

  @override
  String toString() => 'API Error $statusCode: $message';

  bool isUnauthorized() => statusCode == 401;
  bool isServerError() => statusCode != null && statusCode! >= 500;
}
