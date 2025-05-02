import 'package:civiceye/report_status_enum.dart';
import 'package:flutter/material.dart';


Future<void> showUpdateStatusDialog(
  BuildContext context,
  Function(ReportStatus status, String? notes) onSubmit,
) async {
  ReportStatus? selectedStatus;
  final TextEditingController notesController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('تحديث حالة البلاغ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ReportStatus>(
              decoration: const InputDecoration(
                labelText: 'اختر الحالة الجديدة',
                border: OutlineInputBorder(),
              ),
              items: ReportStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.name),
                );
              }).toList(),
              onChanged: (value) => selectedStatus = value,
              validator: (value) =>
                  value == null ? 'يرجى اختيار حالة' : null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'ملاحظة (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('تحديث'),
            onPressed: () {
              if (selectedStatus != null) {
                Navigator.of(context).pop();
                onSubmit(
                  selectedStatus!,
                  notesController.text.trim().isEmpty
                      ? null
                      : notesController.text.trim(),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
