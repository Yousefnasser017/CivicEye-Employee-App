import 'package:flutter/material.dart';
import 'package:civiceye/models/report_model.dart';

class ReportStatusCard extends StatelessWidget {
  final List<ReportModel> reports;

  ReportStatusCard({required this.reports});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,  // لضمان عدم تجاوز المساحة
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2, // لضبط شكل الكارد
      ),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          child: ListTile(
            title: Text(report.currentStatus),
            subtitle: Text('عدد البلاغات: ${reports.where((r) => r.currentStatus == report.currentStatus).length}'),
            onTap: () {
              // يمكنك هنا التوجه لصفحة البلاغات مع فلترة حسب الحالة
            },
          ),
        );
      },
    );
  }
}
