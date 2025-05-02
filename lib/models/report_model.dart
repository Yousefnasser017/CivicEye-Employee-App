class ReportModel {
  final int reportId;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? contactInfo;
  final String department;
  final DateTime createdAt;
  final String currentStatus;
  final String? cityName;

  ReportModel({
    required this.reportId,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.contactInfo,
    required this.department,
    required this.createdAt,
    required this.currentStatus,
    this.cityName,
  });

  // Factory constructor to create an instance from JSON
  factory ReportModel.fromJson( json) {
    return ReportModel(
      reportId: json['reportId'],
      title: json['title'] ?? '',
      description: json['description'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      contactInfo: json['contactInfo'],
      department: json['department'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      currentStatus: json['currentStatus'] ?? '',
      cityName: json['cityName'],
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'contactInfo': contactInfo,
      'department': department,
      'createdAt': createdAt.toIso8601String(),
      'currentStatus': currentStatus,
      'cityName': cityName,
    };
  }
}

class UpdateReportStatus {
  final int employeeId;
  final String newStatus;
  final String? notes;
  final int reportId;

  UpdateReportStatus({
    required this.employeeId,
    required this.newStatus,
    this.notes,
    required this.reportId,
  });

  // Factory constructor to create an instance from JSON
  factory UpdateReportStatus.fromJson(Map<String, dynamic> json) {
    return UpdateReportStatus(
      employeeId: json['employeeId'],
      newStatus: json['newStatus'],
      notes: json['notes'],
      reportId: json['reportId'],
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'newStatus': newStatus,
      'notes': notes,
      'reportId': reportId,
    };
  }
}
