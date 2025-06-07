import 'package:flutter/material.dart';
import 'package:civiceye/core/themes/app_colors.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final int count;
  final String statusKey;
  final VoidCallback onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.count,
    required this.statusKey,
    required this.onTap,
  });

  IconData _getStatusIcon() {
    switch (statusKey) {
      case 'Submitted':
        return Icons.mark_email_unread;
      case 'In_Progress':
        return Icons.sync;
      case 'Resolved':
        return Icons.check_circle_outline;
      case 'On_Hold':
        return Icons.pause_circle_outline;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.report;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        width: MediaQuery.of(context).size.width / 2 - 20,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white10 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(_getStatusIcon(), size: 28, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 4),
            Text(
              '${convertToArabicNumbers(count)} بلاغ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

String convertToArabicNumbers(int number) {
  const englishToArabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  return number
      .toString()
      .split('')
      .map((digit) => englishToArabicDigits[digit] ?? digit)
      .join();
}
