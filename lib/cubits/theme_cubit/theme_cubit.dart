import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system);

  /// Call this method after creating the cubit to load the saved theme
  Future<void> init() async {
    await _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);

    if (themeIndex != null &&
        themeIndex >= 0 &&
        themeIndex < ThemeMode.values.length) {
      emit(ThemeMode.values[themeIndex]);
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }

  Future<void> setDarkMode() async {
    emit(ThemeMode.dark);
    await _saveTheme(ThemeMode.dark);
  }

  Future<void> setLightMode() async {
    emit(ThemeMode.light);
    await _saveTheme(ThemeMode.light);
  }

  Future<void> setSystemMode() async {
    emit(ThemeMode.system);
    await _saveTheme(ThemeMode.system);
  }
}
