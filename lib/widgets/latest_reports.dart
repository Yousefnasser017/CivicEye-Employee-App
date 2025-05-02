import 'package:flutter/material.dart';
import 'package:civiceye/models/report_model.dart';

class LatestReports extends StatelessWidget {
  final List<ReportModel> reports;

  LatestReports({required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          child: ListTile(
            title: Text(report.title),
            subtitle: Text('حالة: ${report.currentStatus}'),
            onTap: () {
              // الانتقال لصفحة التفاصيل الخاصة بالبلاغ
            },
          ),
        );
      },
    );
  }
}
