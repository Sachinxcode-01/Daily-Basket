import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Daily Basket Admin Theme
/// Single Source of Truth: design.md

class AdminTheme {
  // Brand & Accent Colors (design.md)
  static const Color primary = Color(0xFF2D9D43);
  static const Color primaryContainer = Color(0xFF078730);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFF7FFF2);
  static const Color primaryFixed = Color(0xFF8CFA93);
  static const Color primaryFixedDim = Color(0xFF70DD7A);

  // Surface Tokens
  static const Color surface = Color(0xFFF9F9FC);
  static const Color surfaceDim = Color(0xFFDADADC);
  static const Color surfaceBright = Color(0xFFF9F9FC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E5);

  // Text & On-Surface
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF3F4A3D);
  static const Color onSurfaceSubtle = Color(0xFF64748B);
  static const Color outline = Color(0xFF6E7A6C);
  static const Color outlineVariant = Color(0xFFBECAB9);

  // Feedback & Status
  static const Color statusSuccess = Color(0xFF15803D);
  static const Color statusWarning = Color(0xFFB45309);
  static const Color statusError = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color statusInfo = Color(0xFF0369A1);

  // Legacy compatibility aliases
  static const Color primaryEmerald = primary;
  static const Color cardLight = surfaceContainerLowest;
  static const Color backgroundLight = surface;
  static const Color textPrimaryLight = onSurface;
  static const Color textSecondaryLight = onSurfaceSubtle;
  static const Color errorRed = statusError;
  static const Color warningOrange = statusWarning;
  static const Color successGreen = statusSuccess;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        surface: surfaceContainerLowest,
        onSurface: onSurface,
        error: statusError,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: GoogleFonts.outfitTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x4DBECAB9)), // border-outline-variant/30
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryFixedDim,
      scaffoldBackgroundColor: const Color(0xFF191C1E),
      colorScheme: const ColorScheme.dark(
        primary: primaryFixedDim,
        surface: Color(0xFF2F3133),
        error: statusError,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2F3133),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFF9F9FC)),
        titleTextStyle: TextStyle(color: Color(0xFFF9F9FC), fontSize: 18, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2F3133),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
