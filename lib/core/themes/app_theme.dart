import 'package:civiceye/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  /* ==================== Theme Configurations ==================== */
  static final ThemeData light = _buildTheme(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: _lightColorScheme,
    textTheme: _lightTextTheme,
    appBarTheme: _lightAppBarTheme,
    cardTheme: _cardTheme,
    inputDecorationTheme: _lightInputDecorationTheme,
    bottomNavigationBarTheme: _lightNavigationBarTheme,
  );

  static final ThemeData dark = _buildTheme(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: _darkColorScheme,
    textTheme: _darkTextTheme,
    appBarTheme: _darkAppBarTheme,
    cardTheme: _cardTheme.copyWith(color: AppColors.cardDark),
    inputDecorationTheme: _darkInputDecorationTheme,
    bottomNavigationBarTheme: _darkNavigationBarTheme,
  );

  /* ==================== Color Schemes ==================== */
  
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
  );

  /* ==================== Text Themes ==================== */
  
  static const TextTheme _baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 16),
  );

  static final TextTheme _lightTextTheme = _baseTextTheme.copyWith(
    bodyLarge: const TextStyle(fontFamily: 'Tajawal', color: AppColors.textLight),
    bodyMedium: const TextStyle(fontFamily: 'Tajawal', color: AppColors.textLight),
  );

  static final TextTheme _darkTextTheme = _baseTextTheme.copyWith(
    bodyLarge: const TextStyle(fontFamily: 'Tajawal', color: AppColors.textDark),
    bodyMedium: const TextStyle(fontFamily: 'Tajawal', color: AppColors.textDark),
  );

  /* ==================== AppBar Themes ==================== */
  
  static const AppBarTheme _baseAppBarTheme = AppBarTheme(
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Tajawal',
    ),
    iconTheme: _appBarIconTheme,
    actionsIconTheme: _appBarIconTheme,
  );

  static final AppBarTheme _lightAppBarTheme = _baseAppBarTheme.copyWith(
    backgroundColor: AppColors.lightBackground,
  );
  static final AppBarTheme _darkAppBarTheme = _baseAppBarTheme.copyWith(
    backgroundColor: AppColors.darkBackground,
  );
  static const IconThemeData _appBarIconTheme = IconThemeData(
    color: Colors.white,
  );

  /* ==================== Input Decoration Themes ==================== */

  static const InputDecorationTheme _baseInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    labelStyle: TextStyle(fontFamily: 'Tajawal'),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static final InputDecorationTheme _lightInputDecorationTheme = _baseInputDecorationTheme.copyWith(
    labelStyle: _baseInputDecorationTheme.labelStyle?.copyWith(
      color: AppColors.textLight,
    ),
  );

  static final InputDecorationTheme _darkInputDecorationTheme = _baseInputDecorationTheme.copyWith(
    labelStyle: _baseInputDecorationTheme.labelStyle?.copyWith(
      color: Colors.white70,
    ),
  );

  /* ==================== Card Theme ==================== */
  
  static const CardTheme _cardTheme = CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  );

  /* ==================== Navigation Bar Themes ==================== */
  
  static const BottomNavigationBarThemeData _lightNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightBackground,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.black54,
    elevation: 8,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  );

  static const BottomNavigationBarThemeData _darkNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBackground,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.white70,
    elevation: 8,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  );

  /* ==================== Helper Function ==================== */
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color scaffoldBackgroundColor,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required AppBarTheme appBarTheme,
    required CardTheme cardTheme,
    required InputDecorationTheme inputDecorationTheme,
    required BottomNavigationBarThemeData bottomNavigationBarTheme,
  }) {
    return ThemeData(
      fontFamily: 'Tajawal',
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: appBarTheme,
      cardTheme: cardTheme,
      inputDecorationTheme: inputDecorationTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
    );
  }
}
