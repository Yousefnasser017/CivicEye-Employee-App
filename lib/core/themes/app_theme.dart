import 'package:civiceye/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    fontFamily: 'Tajawal',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          color: AppColors.textLight),
      displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          color: AppColors.textLight),
      bodyLarge: TextStyle(
          fontSize: 18, fontFamily: 'Tajawal', color: AppColors.textLight),
      bodyMedium: TextStyle(
          fontSize: 16, fontFamily: 'Tajawal', color: AppColors.textLight),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.lightBackground,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Tajawal',
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      labelStyle: TextStyle(fontFamily: 'Tajawal', color: AppColors.textLight),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.black54,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static final ThemeData dark = ThemeData(
    fontFamily: 'Tajawal',
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          color: AppColors.textDark),
      displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          color: AppColors.textDark),
      bodyLarge: TextStyle(
          fontSize: 18, fontFamily: 'Tajawal', color: AppColors.textDark),
      bodyMedium: TextStyle(
          fontSize: 16, fontFamily: 'Tajawal', color: AppColors.textDark),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.darkBackground,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Tajawal',
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      color: AppColors.cardDark,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      labelStyle: TextStyle(fontFamily: 'Tajawal', color: Colors.white70),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.white70,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
