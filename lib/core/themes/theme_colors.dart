import 'package:flutter/material.dart';

class ThemeColors {
  // الألوان الأساسية
  static const primaryColor = Color(0xFF725DFE);
  static const primaryDark = Color(0xFF5A4BD1);
  static const primaryLight = Color(0xFFB3A6FF);
  static const accentColor = Color(0xFF9C27B0);
  
  // ألوان الحالة
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);
  
  // ألوان الثيم الداكن
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkCard = Color(0xFF2D2D2D);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFFBDBDBD);
  static const darkDivider = Color(0xFF424242);
  
  // ألوان الثيم الفاتح
  static const lightBackground = Colors.white;
  static const lightSurface = Color(0xFFF5F5F5);
  static const lightCard = Colors.white;
  static const lightTextPrimary = Color(0xFF212121);
  static const lightTextSecondary = Color(0xFF757575);
  static const lightDivider = Color(0xFFE0E0E0);
  
  // ألوان محايدة
  static const darkGrey = Color(0xFF424242);
  static const mediumGrey = Color(0xFF757575);
  static const lightGrey = Color(0xFFE0E0E0);
  
  // طريقة للحصول على ألوان ديناميكية حسب الثيم
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkBackground 
        : lightBackground;
  }
  
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkSurface 
        : lightSurface;
  }
  
  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkTextPrimary 
        : lightTextPrimary;
  }
  
  // يمكن إضافة المزيد من الدوال حسب الحاجة
}