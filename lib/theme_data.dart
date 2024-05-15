import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = AppTextThemes.baseTextTheme.copyWith(colorScheme: AppColorsSchemes.lightScheme);
  static final darkTheme = AppTextThemes.baseTextTheme.copyWith(colorScheme: AppColorsSchemes.darkScheme);
}

class AppTextThemes {
  static final baseTextTheme = ThemeData(
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: AppFontSizes.displayLargeSize,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: AppFontSizes.displayMediumSize,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: AppFontSizes.displaySmallSize,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: AppFontSizes.headlineMediumSize,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: AppFontSizes.bodyLargeSize,
      ),
      bodySmall: TextStyle(
        fontSize: AppFontSizes.bodySmallSize,
      ),
      labelLarge: TextStyle(
        fontSize: AppFontSizes.labelLargeSize,
      )
    ),
  );
}

class AppFontSizes {
  static const displayLargeSize = 40.0; // page title
  static const displayMediumSize = 30.0; // heading
  static const displaySmallSize = 25.0; // subheading
  static const headlineMediumSize = 18.0; // preview text for dropdown
  static const bodyLargeSize = 12.0; // body text
  static const bodySmallSize = 10.0; // caption
  static const labelLargeSize = 15.0; // button and dropdown
}

class AppColorsSchemes {
  static const darkBlue = Color.fromARGB(255, 32, 32, 75);
  static const lightBlue = Color.fromARGB(255, 145, 145, 255);

  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: darkBlue,
    onPrimary: Colors.white,
    secondary: lightBlue,
    onSecondary: Colors.black,
    background: Colors.black,
    onBackground: Colors.white,
    surface: darkBlue,
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
    background: Colors.white,
    onBackground: Colors.black,
    surface: lightBlue,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}

