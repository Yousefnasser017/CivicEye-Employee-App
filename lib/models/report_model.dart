class ReportModel {
  final int reportId;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? contactInfo;
  final String department;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String currentStatus;
  final String? expectedResolutionDate;
  final String? cityName;
  final String? assignedEmployeeName;
  final List<StatusHistory> statusHistory;

  ReportModel({
    required this.reportId,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.contactInfo,
    required this.department,
    required this.createdAt,
    this.updatedAt,
    required this.currentStatus,
    this.expectedResolutionDate,
    this.cityName,
    this.assignedEmployeeName,
    required this.statusHistory,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'],
      title: json['title'] ?? '',
      description: json['description'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      contactInfo: json['contactInfo'],
      department: json['department'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      currentStatus: json['currentStatus'] ?? '',
      expectedResolutionDate: json['expectedResolutionDate'],
      cityName: json['cityName'],
      assignedEmployeeName: json['assignedEmployeeName'],
      statusHistory: (json['statusHistory'] as List<dynamic>?)
              ?.map((e) => StatusHistory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StatusHistory {
  final int statusId;
  final String status;
  final String? notes;
  final DateTime? startTime;
  final DateTime? endTime;
  final int reportId;
  final int updatedByEmployeeId;
  final String updatedByEmployeeName;

  StatusHistory({
    required this.statusId,
    required this.status,
    this.notes,
    this.startTime,
    this.endTime,
    required this.reportId,
    required this.updatedByEmployeeId,
    required this.updatedByEmployeeName,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      statusId: json['statusId'],
      status: json['status'],
      notes: json['notes'],
      startTime: json['startTime'] != null ? DateTime.tryParse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
      reportId: json['reportId'],
      updatedByEmployeeId: json['updatedByEmployeeId'],
      updatedByEmployeeName: json['updatedByEmployeeName'],
    );
  }
}
