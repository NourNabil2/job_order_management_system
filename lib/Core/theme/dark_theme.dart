import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'text_theme.dart';

class DarkTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ColorApp.primaryColor,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[900],
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorApp.primaryColor,
      brightness: Brightness.dark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: ColorApp.primaryColor,
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.black87,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.black,
      surfaceTintColor: Colors.black,
    ),
    textTheme: appTextTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}
