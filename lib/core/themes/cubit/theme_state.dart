part of 'theme_cubit.dart';

abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeChanged extends ThemeState {
  final ThemeData themeData;
  ThemeChanged(this.themeData);
}
