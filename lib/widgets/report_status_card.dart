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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 20,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$count بلاغ',
                style:  TextStyle(fontSize: 16,  fontWeight: FontWeight.bold, color: isDarkMode? const Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(255, 66, 66, 66))),
          ],
        ),
      ),
    );
  }
}
