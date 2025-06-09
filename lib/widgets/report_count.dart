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
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive width with max constraints
    double cardWidth = screenWidth / 2 - 20;
    if (screenWidth > 600) {
      cardWidth = (screenWidth / 3 - 24).clamp(160.0, 200.0);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: cardWidth,
        constraints: const BoxConstraints(
          minHeight: 120, // Minimum height to maintain consistency
          maxHeight: 140, // Maximum height
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getStatusIcon(), size: 28, color: AppColors.primary),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${convertToArabicNumbers(count)} بلاغ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
