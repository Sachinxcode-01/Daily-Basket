import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Google Stitch Daily Basket Design System
/// Single Source of Truth: design.md
///
/// Fonts:     Outfit (Primary & Display Hierarchy)
/// Mode:      Light (primary design) — dark support via ColorScheme.dark
/// Shape:     Core 8px geometry (8px inputs/small cards, 16px cards, 24px sheets, 9999px pills)
/// Elevation: Material 3 softened + Stitch glassmorphic chrome

class AppColors {
  // ─── Primary & Brand Colors (design.md) ─────────────────────────────────
  static const primary            = Color(0xFF2D9D43);
  static const onPrimary          = Color(0xFFFFFFFF);
  static const primaryContainer   = Color(0xFF078730);
  static const onPrimaryContainer = Color(0xFFF7FFF2);
  static const surfaceTint        = Color(0xFF2D9D43);
  static const inversePrimary     = Color(0xFF70DD7A);
  static const primaryFixed       = Color(0xFF8CFA93);
  static const primaryFixedDim    = Color(0xFF70DD7A);
  static const onPrimaryFixed     = Color(0xFF002106);

  // ─── Secondary & Tertiary ────────────────────────────────────────────────
  static const secondary              = Color(0xFF58605A);
  static const onSecondary            = Color(0xFFFFFFFF);
  static const secondaryContainer     = Color(0xFFDCE5DD);
  static const onSecondaryContainer   = Color(0xFF5E6660);
  static const secondaryFixed         = Color(0xFFDCE5DD);

  static const tertiary           = Color(0xFF5A5C5C);
  static const onTertiary         = Color(0xFFFFFFFF);
  static const tertiaryContainer  = Color(0xFF737575);
  static const onTertiaryContainer= Color(0xFFFCFCFC);

  // ─── Surface & Background Tokens ─────────────────────────────────────────
  static const surface                  = Color(0xFFF9F9FC);
  static const surfaceDim               = Color(0xFFDADADC);
  static const surfaceBright            = Color(0xFFF9F9FC);
  static const surfaceContainerLowest   = Color(0xFFFFFFFF);
  static const surfaceContainerLow      = Color(0xFFF3F3F6);
  static const surfaceContainer         = Color(0xFFECEEF0);
  static const surfaceContainerHigh     = Color(0xFFE6E8EA);
  static const surfaceContainerHighest  = Color(0xFFE0E3E5);
  static const surfaceVariant           = Color(0xFFE0E3E5);
  static const onSurface                = Color(0xFF191C1E);
  static const onSurfaceVariant         = Color(0xFF3F4A3D);
  static const onSurfaceSubtle          = Color(0xFF64748B);
  static const inverseSurface           = Color(0xFF2F3133);
  static const inverseOnSurface         = Color(0xFFF0F0F3);

  // ─── Outline ────────────────────────────────────────────────────────────
  static const outline        = Color(0xFF6E7A6C);
  static const outlineVariant = Color(0xFFBECAB9);

  // ─── Background ─────────────────────────────────────────────────────────
  static const background   = Color(0xFFF9F9FC);
  static const onBackground = Color(0xFF191C1E);

  // ─── Semantic & Feedback Colors ──────────────────────────────────────────
  static const statusSuccess    = Color(0xFF15803D);
  static const statusWarning    = Color(0xFFB45309);
  static const statusError      = Color(0xFFBA1A1A);
  static const error            = Color(0xFFBA1A1A);
  static const onError          = Color(0xFFFFFFFF);
  static const errorContainer   = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const statusInfo       = Color(0xFF0369A1);

  AppColors._();
}

class AppTextStyles {
  // ─── Outfit Typography Scale (design.md Hierarchy) ──────────────────────
  static TextStyle get headlineLarge => GoogleFonts.outfit(
    fontSize: 28, fontWeight: FontWeight.w700,
    height: 36 / 28, letterSpacing: -0.02 * 28,
    color: AppColors.onSurface,
  );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
    fontSize: 22, fontWeight: FontWeight.w600,
    height: 28 / 22,
    color: AppColors.onSurface,
  );

  static TextStyle get headlineSmall => GoogleFonts.outfit(
    fontSize: 18, fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.onSurface,
  );

  static TextStyle get titleMedium => GoogleFonts.outfit(
    fontSize: 16, fontWeight: FontWeight.w600,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyLarge => GoogleFonts.outfit(
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  static TextStyle get bodySmall => GoogleFonts.outfit(
    fontSize: 12, fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.onSurfaceSubtle,
  );

  static TextStyle get labelLarge => GoogleFonts.outfit(
    fontSize: 14, fontWeight: FontWeight.w600,
    height: 20 / 14, letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  static TextStyle get labelMedium => GoogleFonts.outfit(
    fontSize: 12, fontWeight: FontWeight.w600,
    height: 16 / 12, letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  // Aliases for backwards compatibility
  static TextStyle get displayLg => headlineLarge;
  static TextStyle get headlineLg => headlineLarge;
  static TextStyle get headlineLgMobile => headlineMedium;
  static TextStyle get titleMd => titleMedium;
  static TextStyle get bodyLg => bodyLarge;
  static TextStyle get bodySm => bodyMedium;
  static TextStyle get labelMd => labelMedium;

  AppTextStyles._();
}

class AppTheme {
  // ─── Elevation Shadows (design.md) ───────────────────────────────────────
  static List<BoxShadow> get level1 => [
    const BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  static List<BoxShadow> get level2 => [
    const BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> get level3 => [
    const BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  static List<BoxShadow> get bottomNavShadow => [
    const BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, -4),
      blurRadius: 16,
    ),
  ];

  static List<BoxShadow> get floatingCtaShadow => [
    const BoxShadow(
      color: Color(0x402D9D43),
      offset: Offset(0, 8),
      blurRadius: 20,
    ),
  ];

  // ─── Border Radius (design.md Shape Language) ───────────────────────────
  static const radiusSm      = BorderRadius.all(Radius.circular(4));    // 4px
  static const radiusDefault = BorderRadius.all(Radius.circular(8));    // 8px Core Grid
  static const radiusMd      = BorderRadius.all(Radius.circular(8));    // 8px Inputs & small cards
  static const radiusLg      = BorderRadius.all(Radius.circular(16));   // 16px Product tiles & bento cards
  static const radiusXl      = BorderRadius.all(Radius.circular(24));   // 24px Bottom sheets & modals
  static const radiusFull    = BorderRadius.all(Radius.circular(9999)); // Pills & chips

  // ─── Spacing (4px baseline, 8px grid) ───────────────────────────────────
  static const spacingXs     = 4.0;
  static const spacingSm     = 8.0;
  static const spacingMd     = 16.0;
  static const spacingLg     = 24.0;
  static const spacingXl     = 32.0;
  static const gutterH       = 12.0;
  static const gutterV       = 16.0;
  static const marginMobile  = 16.0;
  static const touchTargetMin= 48.0;

  // ─── Light Theme (Primary) ───────────────────────────────────────────────
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary:              AppColors.primary,
      onPrimary:            AppColors.onPrimary,
      primaryContainer:     AppColors.primaryContainer,
      onPrimaryContainer:   AppColors.onPrimaryContainer,
      secondary:            AppColors.secondary,
      onSecondary:          AppColors.onSecondary,
      secondaryContainer:   AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary:             AppColors.tertiary,
      onTertiary:           AppColors.onTertiary,
      tertiaryContainer:    AppColors.tertiaryContainer,
      onTertiaryContainer:  AppColors.onTertiaryContainer,
      error:                AppColors.error,
      onError:              AppColors.onError,
      errorContainer:       AppColors.errorContainer,
      onErrorContainer:     AppColors.onErrorContainer,
      surface:              AppColors.surface,
      onSurface:            AppColors.onSurface,
      surfaceContainerLowest:   AppColors.surfaceContainerLowest,
      surfaceContainerLow:      AppColors.surfaceContainerLow,
      surfaceContainer:         AppColors.surfaceContainer,
      surfaceContainerHigh:     AppColors.surfaceContainerHigh,
      surfaceContainerHighest:  AppColors.surfaceContainerHighest,
      onSurfaceVariant:     AppColors.onSurfaceVariant,
      outline:              AppColors.outline,
      outlineVariant:       AppColors.outlineVariant,
      inverseSurface:       AppColors.inverseSurface,
      onInverseSurface:     AppColors.inverseOnSurface,
      inversePrimary:       AppColors.inversePrimary,
      surfaceTint:          AppColors.surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      // ─── Typography ────────────────────────────────────────────────────
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleMedium:   AppTextStyles.titleMedium,
        bodyLarge:     AppTextStyles.bodyLarge,
        bodyMedium:    AppTextStyles.bodyMedium,
        bodySmall:     AppTextStyles.bodySmall,
        labelLarge:    AppTextStyles.labelLarge,
        labelMedium:   AppTextStyles.labelMedium,
      ),
      // ─── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface.withValues(alpha: 0.80),
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.outline.withValues(alpha: 0.15),
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
      ),
      // ─── Bottom Navigation ─────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xE6F9F9FC),  // surface/90
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface.withValues(alpha: 0.90),
        indicatorColor: AppColors.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelMedium),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.onSurfaceVariant);
        }),
      ),
      // ─── Elevated Button ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: radiusLg),
          textStyle: AppTextStyles.labelLarge,
          elevation: 2,
        ),
      ),
      // ─── Outlined Button ───────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: radiusLg),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      // ─── FilledButton / FAB ────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: CircleBorder(),
        elevation: 6,
      ),
      // ─── Input Fields ──────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.onSurfaceSubtle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm + 4,
        ),
      ),
      // ─── Cards ─────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: BorderSide(color: Color(0x4DBECAB9)), // border-outline-variant/30
        ),
        margin: EdgeInsets.zero,
      ),
      // ─── Chips / Tags ──────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerLow,
        selectedColor: AppColors.primaryFixed,
        labelStyle: AppTextStyles.labelMedium,
        shape: const RoundedRectangleBorder(borderRadius: radiusFull),
        side: BorderSide.none,
      ),
      // ─── Switch / Toggles ──────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : AppColors.outline),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primaryContainer
            : AppColors.surfaceContainerHigh),
      ),
      // ─── Divider ───────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 0,
      ),
      // ─── SnackBar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurface,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        shape: const RoundedRectangleBorder(borderRadius: radiusMd),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary:              AppColors.inversePrimary,  // #70DD7A on dark
      onPrimary:            Color(0xFF002106),
      primaryContainer:     Color(0xFF00531A),
      onPrimaryContainer:   AppColors.primaryFixed,
      surface:              AppColors.inverseSurface,
      onSurface:            AppColors.inverseOnSurface,
      error:                Color(0xFFFFB4AB),
      onError:              Color(0xFF690005),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.inverseSurface,
    );
  }

  AppTheme._();
}
