class EmployeeModel {
  final int id;
  final String nationalId;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String department;
  final String cityName;
  final String governorateName;
  final List<String> level;

  EmployeeModel({
    required this.id,
    required this.nationalId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.department,
    required this.cityName,
    required this.governorateName,
    required this.level,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      nationalId: json['nationalId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      cityName: json['cityName'] ?? '',
      governorateName: json['governorateName'] ?? '',
      level: List<String>.from(json['level'] ?? []),
    );
  }
}
