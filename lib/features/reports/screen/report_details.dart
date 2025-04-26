import 'package:civiceye/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final report = ModalRoute.of(context)!.settings.arguments as ReportModel;
    final _ = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('تفاصيل البلاغ'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('العنوان:', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(report.title, style: textTheme.bodyLarge),
              const SizedBox(height: 16),
              Text('الوصف:', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(report.description ?? 'لا يوجد وصف', style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text('رقم التواصل:', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(report.contactInfo ?? 'غير متوفر', style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text('الحالة الحالية: ${report.currentStatus}', style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text('تاريخ البلاغ: ${DateFormat.yMd().format(report.createdAt)}', style: textTheme.bodySmall),
              const SizedBox(height: 24),
              if (report.latitude != null && report.longitude != null)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('عرض على الخريطة'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/map', arguments: {
                        'lat': report.latitude,
                        'lng': report.longitude,
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
