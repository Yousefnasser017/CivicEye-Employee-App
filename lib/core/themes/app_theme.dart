import 'package:civiceye/core/utils/app_colors.dart';
import 'package:flutter/material.dart';


class AppTheme {
  static ThemeData get light => ThemeData(
        fontFamily: 'Tajawal',
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: AppBarTheme(
          color: AppColors.primary,
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: AppColors.textLight),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black54,
        ),
      );

  static ThemeData get dark => ThemeData(
        fontFamily: 'Tajawal',
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: AppBarTheme(
          color: AppColors.darkBackground,
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: AppColors.textDark),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white70,
        ),
      );
}
