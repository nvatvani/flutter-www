import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

/// Theme 17: Plasma Stream - Design System
class AppTheme {
  // Core colors
  static const Color background = Color(0xFF030308);
  static const Color surface = Color(0xFF0a0a12);
  static const Color cyan = Color(0xFF00e5ff);
  static const Color purple = Color(0xFFa855f7);
  static const Color magenta = Color(0xFFec4899);
  static const Color textPrimary = Color(0xFFffffff);
  static const Color textSecondary = Color(0xFFa0a0b0);

  // Gradient for plasma effect
  static const LinearGradient plasmaGradient = LinearGradient(
    colors: [cyan, purple, magenta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glass effect decoration
  static BoxDecoration glassDecoration({
    double blur = 20,
    double opacity = 0.1,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor ?? cyan.withOpacity(0.2), width: 1),
    );
  }

  // Glow box shadow
  static List<BoxShadow> glowShadow(
    Color color, {
    double blur = 20,
    double spread = 0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }

  // Text theme
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 1.2,
      ),
    );
  }

  // Full theme data
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: cyan,
        secondary: purple,
        surface: surface,
      ),
      textTheme: textTheme,
      useMaterial3: true,
    );
  }
}

/// Widget for applying glass blur effect
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.08,
    this.borderColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: AppTheme.glassDecoration(
            blur: blur,
            opacity: opacity,
            borderColor: borderColor,
          ),
          child: child,
        ),
      ),
    );
  }
}
