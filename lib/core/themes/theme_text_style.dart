import 'package:flutter/material.dart';
import 'theme_colors.dart';

class ThemeTextStyles {
  // أنماط النصوص الديناميكية التي تتكيف مع الثيم
  static TextStyle dynamicStyle({
    required BuildContext context,
    required TextStyle lightStyle,
    required TextStyle darkStyle,
  }) {
    return Theme.of(context).brightness == Brightness.dark ? darkStyle : lightStyle;
  }

  // أنماط النصوص العامة
  static TextStyle appBarTitle(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ThemeColors.lightTextPrimary,
    ),
    darkStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ThemeColors.darkTextPrimary,
    ),
  );
  
  static TextStyle headlineLarge(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ThemeColors.lightTextPrimary,
    ),
    darkStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ThemeColors.darkTextPrimary,
    ),
  );
  
  static TextStyle titleMedium(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: ThemeColors.lightTextPrimary,
    ),
    darkStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: ThemeColors.darkTextPrimary,
    ),
  );
  
  static TextStyle bodyLarge(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 18,
      color: ThemeColors.lightTextPrimary,
    ),
    darkStyle: const TextStyle(
      fontSize: 18,
      color: ThemeColors.darkTextPrimary,
    ),
  );
  
  static TextStyle bodyMedium(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 16,
      color: ThemeColors.lightTextPrimary,
    ),
    darkStyle: const TextStyle(
      fontSize: 16,
      color: ThemeColors.darkTextPrimary,
    ),
  );
  
  static TextStyle bodySmall(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 14,
      color: ThemeColors.lightTextSecondary,
    ),
    darkStyle: const TextStyle(
      fontSize: 14,
      color: ThemeColors.darkTextSecondary,
    ),
  );
  
  // أنماط خاصة بالأزرار
  static TextStyle buttonText(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white, // لون ثابت للأزرار
    ),
    darkStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white, // لون ثابت للأزرار
    ),
  );
  
  // أنماط خاصة بحقول الإدخال
  static TextStyle inputLabel(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 16,
      color: ThemeColors.lightTextSecondary,
    ),
    darkStyle: const TextStyle(
      fontSize: 16,
      color: ThemeColors.darkTextSecondary,
    ),
  );
  
  static TextStyle inputHint(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 14,
      color: ThemeColors.lightTextSecondary,
    ),
    darkStyle: const TextStyle(
      fontSize: 14,
      color: ThemeColors.darkTextSecondary,
    ),
  );
  
  // أنماط إضافية
  static TextStyle caption(BuildContext context) => dynamicStyle(
    context: context,
    lightStyle: const TextStyle(
      fontSize: 12,
      color: ThemeColors.lightTextSecondary,
    ),
    darkStyle: const TextStyle(
      fontSize: 12,
      color: ThemeColors.darkTextSecondary,
    ),
  );
}