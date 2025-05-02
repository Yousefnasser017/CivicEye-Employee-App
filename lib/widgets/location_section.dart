import 'package:civiceye/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:civiceye/models/report_model.dart';


class LocationSection extends StatelessWidget {
  final ReportModel report;

  const LocationSection({super.key, required this.report});

  void _openMapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('فتح الخريطة'),
        content: const Text('هل ترغب في فتح الخريطة لموقع البلاغ؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('لا')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => MapScreen(latitude: report.latitude, longitude: report.longitude),
              ));
            },
            child: const Text('نعم'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openMapDialog(context),
      child: const Text(
        'عرض الموقع على الخريطة',
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }
}
