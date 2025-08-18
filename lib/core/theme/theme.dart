import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3),
        borderRadius: BorderRadius.circular(15),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(24),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient5),
      errorBorder: _border(AppPallete.errorColor),
      focusedErrorBorder: _border(AppPallete.errorColor),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppPallete.gradient5,
      secondary: AppPallete.gradient3,
      error: AppPallete.errorColor,
      surface: AppPallete.backgroundColor,
    ),
    textTheme: TextTheme(
      headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppPallete.whiteColor),
      headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppPallete.whiteColor),
      bodyLarge: const TextStyle(fontSize: 16, color: AppPallete.whiteColor),
      bodyMedium: const TextStyle(fontSize: 14, color: AppPallete.greyColor),
    ),
    cardTheme: CardThemeData(
      color: AppPallete.borderColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.gradient5,
        foregroundColor: AppPallete.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    iconTheme: const IconThemeData(color: AppPallete.whiteColor),
  );
}