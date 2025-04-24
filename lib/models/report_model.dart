class ReportModel {
  final int reportId;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? contactInfo;
  final String currentStatus;
  final DateTime createdAt;

  ReportModel({
    required this.reportId,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.contactInfo,
    required this.currentStatus,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'],
      title: json['title'] ?? '',
      description: json['description'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      contactInfo: json['contactInfo'],
      currentStatus: json['currentStatus'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
