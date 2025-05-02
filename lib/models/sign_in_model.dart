class LoginResponseModel {
  final String message;
  final String username;
  final String type;

  LoginResponseModel({
    required this.message,
    required this.username,
    required this.type,
  });

  factory LoginResponseModel.fromJson( json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
      username: json['username'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
