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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
  return ReportModel(
    reportId: json['reportId'] is int ? json['reportId'] : int.tryParse(json['reportId'].toString()) ?? 0,
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


  ReportModel copyWith({
    int? reportId,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    String? contactInfo,
    String? department,
    DateTime? createdAt,
    String? currentStatus,
    String? cityName,
  }) {
    return ReportModel(
      reportId: reportId ?? this.reportId,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      contactInfo: contactInfo ?? this.contactInfo,
      department: department ?? this.department,
      createdAt: createdAt ?? this.createdAt,
      currentStatus: currentStatus ?? this.currentStatus,
      cityName: cityName ?? this.cityName,
    );
  }
 factory ReportModel.empty() => ReportModel(
      reportId: 0,
      title: '',
      department: '',
      createdAt: DateTime.now(),
      currentStatus: '',
 );
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


  factory UpdateReportStatus.fromJson(Map<String, dynamic> json) {
    return UpdateReportStatus(
      employeeId: json['employeeId'],
      newStatus: json['newStatus'],
      notes: json['notes'],
      reportId: json['reportId'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'newStatus': newStatus,
      'notes': notes,
      'reportId': reportId,
    };
  }

  
}




