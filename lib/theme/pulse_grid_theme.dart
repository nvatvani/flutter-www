import 'package:flutter/material.dart';

/// Pulse Grid Theme - Color palette and theme data
/// Deep midnight blue with cyan-to-purple animated accents

class PulseGridColors {
  // Base colors
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF121829);
  static const Color surfaceLight = Color(0xFF1A2235);
  
  // Accent colors
  static const Color primary = Color(0xFF00D9FF); // Electric cyan
  static const Color secondary = Color(0xFF8B5CF6); // Purple
  static const Color tertiary = Color(0xFF06B6D4); // Teal
  
  // Grid animation colors
  static const Color gridBase = Color(0xFF1E293B);
  static const Color gridPulse = Color(0xFF00D9FF);
  static const Color gridPulseAlt = Color(0xFF8B5CF6);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  
  // Glassmorphism
  static const Color glassBackground = Color(0xB3121829); // 70% opacity
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white
  
  // Gradient for animations
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient pulseGradient = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class PulseGridTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PulseGridColors.background,
      colorScheme: const ColorScheme.dark(
        primary: PulseGridColors.primary,
        secondary: PulseGridColors.secondary,
        tertiary: PulseGridColors.tertiary,
        surface: PulseGridColors.surface,
        onPrimary: PulseGridColors.textPrimary,
        onSecondary: PulseGridColors.textPrimary,
        onSurface: PulseGridColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: PulseGridColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: PulseGridColors.glassBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: PulseGridColors.textPrimary,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          color: PulseGridColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: PulseGridColors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: PulseGridColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: PulseGridColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: PulseGridColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: PulseGridColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: PulseGridColors.textSecondary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: PulseGridColors.textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: PulseGridColors.textSecondary,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: PulseGridColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: PulseGridColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: PulseGridColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
