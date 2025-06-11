// ignore_for_file: deprecated_member_use, dead_code

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'SnackbarHelper.dart';

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
    final cleanPhone = _cleanPhoneNumber(widget.phone);

    if (!_isValidPhoneNumber(widget.phone)) {
      SnackBarHelper.show(context, "الرقم المدخل غير صالح: ${widget.phone}",
          type: SnackBarType.error);
      return;
    }

    final Uri callUri = Uri(scheme: 'tel', path: cleanPhone);

    try {
      if (await canLaunchUrl(callUri)) {
        final bool launched = await launchUrl(
          callUri,
          mode: LaunchMode.platformDefault,
        );
        if (!launched) {
          SnackBarHelper.show(context,
              "لا يمكن فتح تطبيق الاتصال. تأكد من وجود تطبيق اتصال افتراضي على جهازك أو أن الرقم صحيح ومدعوم.",
              type: SnackBarType.error);
        }
      } else {
        SnackBarHelper.show(context, "لا يمكن فتح تطبيق الاتصال",
            type: SnackBarType.error);
      }
    } catch (e) {
      SnackBarHelper.show(context, "حدث خطأ أثناء محاولة الاتصال",
          type: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
          StatefulBuilder(
            builder: (context, setState) {
              bool copied = false;
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.phone,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 6,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: InkWell(
                            key: ValueKey(copied),
                            borderRadius: BorderRadius.circular(24),
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: widget.phone));
                              SnackBarHelper.show(
                                  context, "تم نسخ الرقم إلى الحافظة",
                                  type: SnackBarType.success,
                                  duration: Duration(seconds: 2));
                              setState(() => copied = true);
                              await Future.delayed(const Duration(seconds: 1));
                              setState(() => copied = false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: copied
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                copied ? Icons.check : Icons.copy,
                                color: copied
                                    ? Colors.green
                                    : theme.colorScheme.primary,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
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
                child: Text(
                  "إلغاء",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
