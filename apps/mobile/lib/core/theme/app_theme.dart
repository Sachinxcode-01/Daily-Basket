import 'package:flutter/material.dart';

class AppTheme {
  static const primaryEmerald = Color(0xFF059669);
  static const primaryLime = Color(0xFF84CC16);
  static const darkSurface = Color(0xFF0F172A);
  static const cardDark = Color(0xFF1E293B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkSurface,
      colorScheme: const ColorScheme.dark(
        primary: primaryEmerald,
        secondary: primaryLime,
        surface: cardDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
