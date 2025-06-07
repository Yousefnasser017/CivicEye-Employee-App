import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallConfirmationDialog extends StatefulWidget {
  
  final String phone;

  const CallConfirmationDialog({super.key, required this.phone});

  @override
  State<CallConfirmationDialog> createState() => _CallConfirmationDialogState();
  
}

class _CallConfirmationDialogState extends State<CallConfirmationDialog> {
  bool _isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return cleanPhone.isNotEmpty &&
        RegExp(r'^[\+]?[0-9]{7,15}$').hasMatch(cleanPhone);
  }

  String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<void> _launchCaller(BuildContext context) async {
    if (!_isValidPhoneNumber(widget.phone)) {
      _showErrorSnackBar(context, "الرقم المدخل غير صالح: ${widget.phone}");
      return;
    }

    final cleanPhone = _cleanPhoneNumber(widget.phone);
    final Uri callUri = Uri(scheme: 'tel', path: cleanPhone);

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        _showErrorSnackBar(context, "لا يمكن فتح تطبيق الاتصال");
      }
    } catch (e) {
      _showErrorSnackBar(context, "حدث خطأ أثناء محاولة الاتصال");
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;


    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Icon(Icons.phone, color: Colors.green, size: 32),
      ),
      title: const Text(
        "تأكيد الاتصال",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "هل تريد الاتصال على الرقم؟",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Text(
              widget.phone,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            // زر الإلغاء
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:   Text("إلغاء", style: TextStyle(fontSize: 16,color: isDarkMode ? Colors.white : Colors.black)),
              ),
            ),
            const SizedBox(width: 12),
            // زر الاتصال
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _launchCaller(context);
                },
                icon: const Icon(Icons.phone, size: 18),
                label: const Text("اتصال", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
    );
  }
}

class CallDialogHelper {
  static Future<void> showCallConfirmation(
      BuildContext context, String phoneNumber) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CallConfirmationDialog(phone: phoneNumber);
      },
    );
  }
}
