import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallConfirmationDialog extends StatelessWidget {
  final String phone;

  const CallConfirmationDialog({super.key, required this.phone});

  Future<void> _launchCaller(BuildContext context) async {
    final Uri callUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا يمكن فتح تطبيق الاتصال")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("الاتصال"),
      content: Text("هل تريد الاتصال على الرقم: $phone؟"),
      actions: [
        TextButton(
          child: const Text("إلغاء"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("اتصال"),
          onPressed: () async {
            Navigator.of(context).pop();
            await _launchCaller(context);
          },
        ),
      ],
    );
  }
}
