// ignore_for_file: deprecated_member_use

import 'package:civiceye/models/report_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReportStatusCard extends StatelessWidget {
  final ReportStatus status;
  final bool isLoading;

  const ReportStatusCard({
    Key? key,
    required this.status,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusColor = status.color;
    final statusText = status.label;
    final statusIcon = status.icon;

    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
        child: Card(
          elevation: 3,
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.5),
            ),
            title: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 16.0,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            subtitle: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 16.0,
                margin: const EdgeInsets.only(top: 4),
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(
          statusIcon,
          color: statusColor,
          size: 28,
        ),
        title: Text(
          "حالة البلاغ",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          statusText,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: statusColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
