import 'package:civiceye/widgets/contact_section.dart';
import 'package:civiceye/widgets/location_section.dart';
import 'package:civiceye/widgets/report_info_section.dart';
import 'package:civiceye/widgets/status_update_button.dart';
import 'package:flutter/material.dart';
import 'package:civiceye/models/report_model.dart';


class ReportDetailScreen extends StatelessWidget {
  final ReportModel report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل البلاغ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReportInfoSection(report: report),
              const SizedBox(height: 16),
              ContactSection(phoneNumber: report.contactInfo ?? 'لا يتوفر رقم هاتف'),
              const SizedBox(height: 16),
              LocationSection(report: report),
              const SizedBox(height: 24),
              StatusUpdateButton(report: report),
            ],
          ),
        ),
      ),
    );
  }
}
