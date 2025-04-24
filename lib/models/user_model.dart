class EmployeeModel {
  final int id;
  final String fullName;
  final String email;
  final String department;
  final String cityName;
  final String governorateName;

  EmployeeModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.department,
    required this.cityName,
    required this.governorateName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      cityName: json['cityName'] ?? '',
      governorateName: json['governorateName'] ?? '',
    );
  }
}
