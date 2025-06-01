import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:civiceye/models/report_model.dart';

class LatestReports extends StatelessWidget {
  final List<ReportModel> reports;

  const LatestReports({required this.reports});

  String getTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 1) return 'الآن';
    if (duration.inMinutes < 60) return 'منذ ${duration.inMinutes} دقيقة';
    if (duration.inHours < 24) return 'منذ ${duration.inHours} ساعة';
    return DateFormat('yyyy/MM/dd – HH:mm').format(dateTime);
  }

  void _openMap(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[300] : Colors.black54;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final shadowColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    return ListView.builder(
      itemCount: reports.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          elevation: 4,
          shadowColor: shadowColor,
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'حالة: ${report.currentStatus}',
                    style: TextStyle(
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'تاريخ البلاغ: ${getTimeAgo(report.createdAt)}',
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (report.latitude != null && report.longitude != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 18, color: subtitleColor),
                        const SizedBox(width: 4),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _openMap(report.latitude!, report.longitude!),
                          child: Text(
                            'عرض على الخريطة',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
