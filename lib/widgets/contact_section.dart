import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final String phoneNumber;

  const ContactSection({super.key, required this.phoneNumber});

  Future<void> _requestPermission(BuildContext context) async {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفض إذن الاتصال')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('رقم المبلغ: ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(phoneNumber, style: const TextStyle(color: Colors.blue)),
        IconButton(
          icon: const Icon(Icons.phone),
          onPressed: () => _requestPermission(context),
        ),
      ],
    );
  }
}
