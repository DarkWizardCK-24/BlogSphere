import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Enhanced border styles
  static OutlineInputBorder _border([Color color = AppPallete.borderColor, double width = 2]) => 
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: BorderRadius.circular(16),
      );

  static OutlineInputBorder _focusedBorder([Color color = AppPallete.gradient5]) => 
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2.5),
        borderRadius: BorderRadius.circular(16),
      );

  static OutlineInputBorder _errorBorder() => 
      OutlineInputBorder(
        borderSide: BorderSide(color: AppPallete.errorColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      );

  // Enhanced button styles
  static ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
        foregroundColor: AppPallete.whiteColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return AppPallete.buttonPressed;
          }
          if (states.contains(MaterialState.hovered)) {
            return AppPallete.buttonHover;
          }
          if (states.contains(MaterialState.disabled)) {
            return AppPallete.buttonDisabled;
          }
          return AppPallete.gradient5;
        }),
        overlayColor: MaterialStateProperty.all(AppPallete.whiteColor.withOpacity(0.1)),
      );

  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: AppPallete.gradient5,
        side: BorderSide(color: AppPallete.gradient5, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return AppPallete.gradient5.withOpacity(0.1);
          }
          return Colors.transparent;
        }),
        overlayColor: MaterialStateProperty.all(AppPallete.gradient5.withOpacity(0.1)),
      );

  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
        foregroundColor: AppPallete.gradient5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(AppPallete.gradient5.withOpacity(0.1)),
      );

  // Enhanced card theme
  static CardThemeData get cardTheme => CardThemeData(
        color: AppPallete.cardColor,
        elevation: 8,
        shadowColor: AppPallete.shadowMedium,
        surfaceTintColor: AppPallete.gradient5.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppPallete.borderColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );

  // Enhanced app bar theme
  static AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: AppPallete.backgroundColor.withOpacity(0.95),
        elevation: 0,
        scrolledUnderElevation: 4,
        shadowColor: AppPallete.shadowLight,
        surfaceTintColor: AppPallete.gradient5.withOpacity(0.05),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppPallete.whiteColor,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppPallete.whiteColor,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppPallete.whiteColor,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      );

  // Enhanced floating action button theme
  static FloatingActionButtonThemeData get fabTheme => FloatingActionButtonThemeData(
        backgroundColor: AppPallete.gradient5,
        foregroundColor: AppPallete.whiteColor,
        elevation: 8,
        focusElevation: 12,
        hoverElevation: 10,
        highlightElevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  // Enhanced bottom navigation bar theme
  static BottomNavigationBarThemeData get bottomNavTheme => BottomNavigationBarThemeData(
        backgroundColor: AppPallete.cardColor,
        selectedItemColor: AppPallete.gradient5,
        unselectedItemColor: AppPallete.greyColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      );

  // Enhanced divider theme
  static DividerThemeData get dividerTheme => DividerThemeData(
        color: AppPallete.borderColor,
        thickness: 1,
        space: 32,
      );

  // Enhanced list tile theme
  static ListTileThemeData get listTileTheme => ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppPallete.surfaceColor,
        selectedTileColor: AppPallete.gradient5.withOpacity(0.1),
        textColor: AppPallete.primaryTextColor,
        iconColor: AppPallete.secondaryTextColor,
        selectedColor: AppPallete.gradient5,
      );

  // Enhanced switch theme
  static SwitchThemeData get switchTheme => SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppPallete.whiteColor;
          }
          return AppPallete.greyColor;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppPallete.gradient5;
          }
          return AppPallete.borderColor;
        }),
      );

  // Enhanced checkbox theme
  static CheckboxThemeData get checkboxTheme => CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppPallete.gradient5;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(AppPallete.whiteColor),
        side: BorderSide(color: AppPallete.borderColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );

  // Enhanced radio theme
  static RadioThemeData get radioTheme => RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppPallete.gradient5;
          }
          return AppPallete.borderColor;
        }),
      );

  // Enhanced slider theme
  static SliderThemeData get sliderTheme => SliderThemeData(
        activeTrackColor: AppPallete.gradient5,
        inactiveTrackColor: AppPallete.borderColor,
        thumbColor: AppPallete.whiteColor,
        overlayColor: AppPallete.gradient5.withOpacity(0.2),
        valueIndicatorColor: AppPallete.gradient5,
        valueIndicatorTextStyle: const TextStyle(
          color: AppPallete.whiteColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      );

  // Enhanced progress indicator theme
  static ProgressIndicatorThemeData get progressIndicatorTheme => ProgressIndicatorThemeData(
        color: AppPallete.gradient5,
        linearTrackColor: AppPallete.borderColor,
        circularTrackColor: AppPallete.borderColor,
      );

  // Enhanced snackbar theme
  static SnackBarThemeData get snackBarTheme => SnackBarThemeData(
        backgroundColor: AppPallete.cardColor,
        contentTextStyle: const TextStyle(
          color: AppPallete.whiteColor,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        actionTextColor: AppPallete.gradient5,
      );

  // Main dark theme
  static final darkThemeMode = ThemeData.dark().copyWith(
    // Core colors
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    primaryColor: AppPallete.gradient5,
    
    // Enhanced color scheme
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppPallete.gradient5,
      onPrimary: AppPallete.whiteColor,
      secondary: AppPallete.gradient3,
      onSecondary: AppPallete.whiteColor,
      error: AppPallete.errorColor,
      onError: AppPallete.whiteColor,
      background: AppPallete.backgroundColor,
      onBackground: AppPallete.primaryTextColor,
      surface: AppPallete.surfaceColor,
      onSurface: AppPallete.primaryTextColor,
      surfaceVariant: AppPallete.cardColor,
      onSurfaceVariant: AppPallete.secondaryTextColor,
      outline: AppPallete.borderColor,
      shadow: AppPallete.shadowMedium,
      inverseSurface: AppPallete.whiteColor,
      onInverseSurface: AppPallete.backgroundColor,
      inversePrimary: AppPallete.gradient2,
    ),

    // Enhanced input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPallete.surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: _border(AppPallete.borderColor),
      focusedBorder: _focusedBorder(),
      errorBorder: _errorBorder(),
      focusedErrorBorder: _errorBorder(),
      disabledBorder: _border(AppPallete.borderColor.withOpacity(0.5)),
      hintStyle: const TextStyle(
        color: AppPallete.greyColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: AppPallete.secondaryTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppPallete.gradient5,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: const TextStyle(
        color: AppPallete.errorColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      prefixIconColor: AppPallete.secondaryTextColor,
      suffixIconColor: AppPallete.secondaryTextColor,
    ),

    // Enhanced text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 40, 
        fontWeight: FontWeight.w900, 
        color: AppPallete.whiteColor,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 36, 
        fontWeight: FontWeight.w800, 
        color: AppPallete.whiteColor,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 32, 
        fontWeight: FontWeight.w700, 
        color: AppPallete.whiteColor,
        letterSpacing: -0.25,
      ),
      headlineLarge: TextStyle(
        fontSize: 28, 
        fontWeight: FontWeight.bold, 
        color: AppPallete.whiteColor,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.bold, 
        color: AppPallete.whiteColor,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.w600, 
        color: AppPallete.whiteColor,
        letterSpacing: 0.15,
      ),
      titleLarge: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w600, 
        color: AppPallete.whiteColor,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w600, 
        color: AppPallete.whiteColor,
        letterSpacing: 0.1,
      ),
      titleSmall: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w600, 
        color: AppPallete.whiteColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w400,
        color: AppPallete.primaryTextColor,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w400,
        color: AppPallete.secondaryTextColor,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w400,
        color: AppPallete.greyColor,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w600,
        color: AppPallete.whiteColor,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w600,
        color: AppPallete.secondaryTextColor,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 10, 
        fontWeight: FontWeight.w600,
        color: AppPallete.greyColor,
        letterSpacing: 0.5,
      ),
    ),

    // Apply all enhanced themes
    appBarTheme: appBarTheme,
    cardTheme: cardTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
    textButtonTheme: TextButtonThemeData(style: textButtonStyle),
    floatingActionButtonTheme: fabTheme,
    bottomNavigationBarTheme: bottomNavTheme,
    dividerTheme: dividerTheme,
    listTileTheme: listTileTheme,
    switchTheme: switchTheme,
    checkboxTheme: checkboxTheme,
    radioTheme: radioTheme,
    sliderTheme: sliderTheme,
    progressIndicatorTheme: progressIndicatorTheme,
    snackBarTheme: snackBarTheme,

    // Enhanced icon theme
    iconTheme: const IconThemeData(
      color: AppPallete.whiteColor,
      size: 24,
    ),
    
    // Enhanced primary icon theme
    primaryIconTheme: const IconThemeData(
      color: AppPallete.gradient5,
      size: 24,
    ),

    // Visual density for better touch targets
    visualDensity: VisualDensity.adaptivePlatformDensity,
    
    // Typography
    typography: Typography.material2021(),
    
    // Platform brightness
    brightness: Brightness.dark,
  );
}