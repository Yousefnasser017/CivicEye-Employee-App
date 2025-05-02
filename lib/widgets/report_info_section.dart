import 'package:flutter/material.dart';
import 'package:civiceye/models/report_model.dart';

class ReportInfoSection extends StatelessWidget {
  final ReportModel report;

  const ReportInfoSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          report.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          report.description ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
