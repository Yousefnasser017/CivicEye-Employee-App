class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data; // بيانات إضافية من الخادم
  final StackTrace? stackTrace;

  ApiException(
    this.message,
    [this.statusCode, 
     this.data,
     this.stackTrace,
    ]);

  @override
  String toString() => 'API Error $statusCode: $message';
  
  // يمكن إضافة دوال مساعدة
  bool isUnauthorized() => statusCode == 401;
  bool isServerError() => statusCode != null && statusCode! >= 500;
}