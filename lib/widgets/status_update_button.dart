import 'package:flutter/material.dart';
import 'package:civiceye/models/report_model.dart';

class StatusUpdateButton extends StatelessWidget {
  final ReportModel report;

  const StatusUpdateButton({super.key, required this.report});

  void _showStatusDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            const Text('تحديث الحالة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...['In Progress', 'On Hold', 'Resolved', 'Closed'].map(
              (status) => ListTile(
                title: Text(status),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: call Cubit to update status
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showStatusDialog(context),
      icon: const Icon(Icons.edit),
      label: const Text('تحديث الحالة'),
    );
  }
}
