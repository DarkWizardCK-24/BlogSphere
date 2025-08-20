import 'package:flutter/material.dart';

class AppPallete {
  // Primary Background Colors
  static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);
  static const Color surfaceColor = Color.fromRGBO(30, 30, 38, 1);
  static const Color cardColor = Color.fromRGBO(36, 36, 44, 1);
  
  // Enhanced Gradient Colors with more vibrant options
  static const Color gradient1 = Color.fromRGBO(59, 223, 132, 1);   // Emerald
  static const Color gradient2 = Color.fromRGBO(44, 125, 190, 1);   // Ocean Blue
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);  // Coral
  static const Color gradient4 = Color.fromRGBO(187, 63, 221, 1);   // Purple
  static const Color gradient5 = Color.fromRGBO(251, 109, 169, 1);  // Rose
  static const Color gradient6 = Color.fromRGBO(128, 0, 128, 1);    // Deep Purple
  static const Color gradient7 = Color.fromRGBO(0, 128, 128, 1);    // Teal
  static const Color gradient8 = Color.fromRGBO(255, 165, 0, 1);    // Orange
  static const Color gradient9 = Color.fromRGBO(238, 130, 238, 1);  // Violet
  static const Color gradient10 = Color.fromRGBO(255, 69, 0, 1);    // Red Orange
  static const Color gradient11 = Color.fromRGBO(50, 205, 50, 1);   // Lime Green
  static const Color gradient12 = Color.fromRGBO(255, 20, 147, 1);  // Deep Pink
  
  // Enhanced Border and UI Colors
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color borderColorLight = Color.fromRGBO(70, 69, 85, 1);
  static const Color borderColorDark = Color.fromRGBO(35, 34, 45, 1);
  
  // Text Colors with better contrast
  static const Color whiteColor = Colors.white;
  static const Color primaryTextColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color secondaryTextColor = Color.fromRGBO(200, 200, 200, 1);
  static const Color greyColor = Color.fromRGBO(156, 163, 175, 1);
  static const Color lightGreyColor = Color.fromRGBO(209, 213, 219, 1);
  static const Color darkGreyColor = Color.fromRGBO(107, 114, 128, 1);
  
  // Status Colors
  static const Color errorColor = Color.fromRGBO(239, 68, 68, 1);
  static const Color successColor = Color.fromRGBO(34, 197, 94, 1);
  static const Color warningColor = Color.fromRGBO(245, 158, 11, 1);
  static const Color infoColor = Color.fromRGBO(59, 130, 246, 1);
  
  // Interactive Colors
  static const Color hoverColor = Color.fromRGBO(55, 65, 81, 1);
  static const Color focusColor = Color.fromRGBO(99, 102, 241, 1);
  static const Color activeColor = Color.fromRGBO(79, 70, 229, 1);
  
  // Transparent and Utility Colors
  static const Color transparentColor = Colors.transparent;
  static const Color shimmerBaseColor = Color.fromRGBO(45, 45, 55, 1);
  static const Color shimmerHighlightColor = Color.fromRGBO(65, 65, 75, 1);
  
  // Enhanced Gradient Combinations
  static const List<Color> primaryGradient = [gradient5, gradient2];
  static const List<Color> secondaryGradient = [gradient1, gradient3];
  static const List<Color> accentGradient = [gradient4, gradient6];
  static const List<Color> warmGradient = [gradient3, gradient8];
  static const List<Color> coolGradient = [gradient2, gradient7];
  static const List<Color> vibrantGradient = [gradient10, gradient12];
  static const List<Color> backgroundGradient = [backgroundColor, surfaceColor, cardColor];
  
  // Glassmorphism Colors
  static Color get glassmorphismBackground => whiteColor.withOpacity(0.1);
  static Color get glassmorphismBorder => whiteColor.withOpacity(0.2);
  static Color get glassmorphismShadow => backgroundColor.withOpacity(0.3);
  
  // Button State Colors
  static Color get buttonHover => gradient5.withOpacity(0.8);
  static Color get buttonPressed => gradient5.withOpacity(0.9);
  static Color get buttonDisabled => greyColor.withOpacity(0.3);
  
  // Shadow Colors
  static Color get shadowLight => backgroundColor.withOpacity(0.1);
  static Color get shadowMedium => backgroundColor.withOpacity(0.2);
  static Color get shadowHeavy => backgroundColor.withOpacity(0.4);
  static Color get coloredShadow => gradient5.withOpacity(0.3);
  
  // Helper methods for creating gradients
  static LinearGradient createGradient(List<Color> colors, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }
  
  static RadialGradient createRadialGradient(List<Color> colors, {
    Alignment center = Alignment.center,
    double radius = 0.5,
  }) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: colors,
    );
  }
  
  static SweepGradient createSweepGradient(List<Color> colors, {
    Alignment center = Alignment.center,
    double startAngle = 0.0,
    double endAngle = 6.28,
  }) {
    return SweepGradient(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      colors: colors,
    );
  }
  
  // Animated color interpolation helpers
  static Color interpolateColors(Color start, Color end, double t) {
    return Color.lerp(start, end, t) ?? start;
  }
  
  // Theme-based color selection
  static Color getTextColorOnBackground(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? backgroundColor : whiteColor;
  }
}