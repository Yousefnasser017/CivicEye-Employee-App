// class ErrorModel {
//   final int? statusCode;
//   final String? message;

//   ErrorModel({this.statusCode, this.message});

//   factory ErrorModel.fromJson(Map<String, dynamic> json) {
//     return ErrorModel(
//       statusCode: json['statusCode'] ?? json['status'],
//       message: json['message'] ?? 'حدث خطأ غير متوقع',
//     );
//   }

//   @override
//   String toString() {
//     return 'ErrorModel(statusCode: $statusCode, message: $message)';
//   }
// }
