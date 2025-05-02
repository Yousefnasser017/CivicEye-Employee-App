import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

class SnackBarHelper {
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final config = _getStyle(type, isDark);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: config['color'],
      duration: duration,
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        children: [
          Icon(config['icon'], color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Map<String, dynamic> _getStyle(SnackBarType type, bool isDark) {
    switch (type) {
      case SnackBarType.success:
        return {
          'color': isDark ? Colors.green.shade700 : Colors.green,
          'icon': Icons.check_circle_rounded,
        };
      case SnackBarType.error:
        return {
          'color': isDark ? Colors.red.shade700 : Colors.red,
          'icon': Icons.error_rounded,
        };
      case SnackBarType.warning:
        return {
          'color': isDark ? Colors.orange.shade700 : Colors.orange,
          'icon': Icons.warning_rounded,
        };
      case SnackBarType.info:
      return {
          'color': isDark ? Colors.blue.shade700 : Colors.blue,
          'icon': Icons.info_outline_rounded,
        };
    }
  }
}
