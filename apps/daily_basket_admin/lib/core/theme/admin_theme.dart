import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTheme {
  // Google Stitch Admin Palette
  static const Color primaryEmerald = Color(0xFF0F766E);
  static const Color primaryTeal = Color(0xFF14B8A6);
  static const Color accentMint = Color(0xFF2DD4BF);
  static const Color darkSlate = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF090D16);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color successGreen = Color(0xFF10B981);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryEmerald,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryEmerald,
        secondary: primaryTeal,
        surface: cardLight,
        error: errorRed,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryLight),
        titleTextStyle: TextStyle(color: textPrimaryLight, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryEmerald,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryTeal,
        secondary: accentMint,
        surface: cardDark,
        error: errorRed,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardDark,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryDark),
        titleTextStyle: TextStyle(color: textPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

