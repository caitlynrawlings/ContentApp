import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = AppTextThemes.baseTextTheme.copyWith(colorScheme: AppColorsSchemes.lightScheme);
  static final darkTheme = AppTextThemes.baseTextTheme.copyWith(colorScheme: AppColorsSchemes.darkScheme);
}

class AppTextThemes {
  static final baseTextTheme = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 12,
      ),
    ),
  );
}

class AppColorsSchemes {
  static const darkBlue = Color.fromARGB(255, 32, 32, 75);
  static const lightBlue = Color.fromARGB(255, 145, 145, 255);

  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: darkBlue,
    onPrimary: Colors.white,
    secondary: lightBlue,
    onSecondary: Colors.black,
    background: darkBlue,
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  static const ColorScheme lightScheme = ColorScheme.light(
    primary: lightBlue,
    onPrimary: Colors.black,
    secondary: darkBlue,
    onSecondary: Colors.white,
    background: lightBlue,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}

