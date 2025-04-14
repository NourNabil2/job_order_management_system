import 'package:flutter/material.dart';
import '../Utilts/Constants.dart';
import 'text_theme.dart';

class LightTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorApp.primaryColor,
    primaryColorLight: ColorApp.primaryColor,
    primaryColorDark: ColorApp.primaryColor,
    scaffoldBackgroundColor: ColorApp.mainLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorApp.primaryColor,
      brightness: Brightness.light,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: ColorApp.primaryColor,
      unselectedItemColor: ColorApp.mainLight,
      backgroundColor: ColorApp.primaryColor,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: ColorApp.primaryColor,
      surfaceTintColor: ColorApp.primaryColor,
    ),
    textTheme: appTextTheme,
  );
}
