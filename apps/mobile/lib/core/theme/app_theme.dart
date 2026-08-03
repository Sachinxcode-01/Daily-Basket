import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Google Stitch Daily Basket Design System
/// Extracted from official exported Stitch project:
/// C:\Users\kalin\Downloads\stitch_daily_basket_quick_commerce_suite
///
/// Fonts:     Outfit (headlines/titles) + Inter (body/labels)
/// Mode:      Light (primary design) — dark support via ColorScheme.dark
/// Shape:     Extra Rounded (16px cards, 12px inputs, pill chips)
/// Elevation: Material 3 softened

class AppColors {
  // ─── Primary (Grocery Green) ────────────────────────────────────────────
  static const primary            = Color(0xFF006B23);
  static const onPrimary          = Color(0xFFFFFFFF);
  static const primaryContainer   = Color(0xFF078730);
  static const onPrimaryContainer = Color(0xFFF7FFF2);
  static const surfaceTint        = Color(0xFF006E25);
  static const inversePrimary     = Color(0xFF70DD7A);
  static const primaryFixed       = Color(0xFF8CFA93);
  static const primaryFixedDim    = Color(0xFF70DD7A);
  static const onPrimaryFixed     = Color(0xFF002106);

  // ─── Secondary ──────────────────────────────────────────────────────────
  static const secondary              = Color(0xFF58605A);
  static const onSecondary            = Color(0xFFFFFFFF);
  static const secondaryContainer     = Color(0xFFDCE5DD);
  static const onSecondaryContainer   = Color(0xFF5E6660);
  static const secondaryFixed         = Color(0xFFDCE5DD);

  // ─── Tertiary ───────────────────────────────────────────────────────────
  static const tertiary           = Color(0xFF5A5C5C);
  static const onTertiary         = Color(0xFFFFFFFF);
  static const tertiaryContainer  = Color(0xFF737575);
  static const onTertiaryContainer= Color(0xFFFCFCFC);

  // ─── Surface ────────────────────────────────────────────────────────────
  static const surface                  = Color(0xFFF9F9FC);
  static const surfaceDim               = Color(0xFFDADADC);
  static const surfaceBright            = Color(0xFFF9F9FC);
  static const surfaceContainerLowest   = Color(0xFFFFFFFF);
  static const surfaceContainerLow      = Color(0xFFF3F3F6);
  static const surfaceContainer         = Color(0xFFEEEEF0);
  static const surfaceContainerHigh     = Color(0xFFE8E8EA);
  static const surfaceContainerHighest  = Color(0xFFE2E2E5);
  static const surfaceVariant           = Color(0xFFE2E2E5);
  static const onSurface                = Color(0xFF1A1C1E);
  static const onSurfaceVariant         = Color(0xFF3F4A3D);
  static const inverseSurface           = Color(0xFF2F3133);
  static const inverseOnSurface         = Color(0xFFF0F0F3);

  // ─── Outline ────────────────────────────────────────────────────────────
  static const outline        = Color(0xFF6E7A6C);
  static const outlineVariant = Color(0xFFBECAB9);

  // ─── Background ─────────────────────────────────────────────────────────
  static const background   = Color(0xFFF9F9FC);
  static const onBackground = Color(0xFF1A1C1E);

  // ─── Error ──────────────────────────────────────────────────────────────
  static const error            = Color(0xFFBA1A1A);
  static const onError          = Color(0xFFFFFFFF);
  static const errorContainer   = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  AppColors._();
}

class AppTextStyles {
  // ─── Outfit (Display / Headlines / Titles) ───────────────────────────────
  static TextStyle get displayLg => GoogleFonts.outfit(
    fontSize: 48, fontWeight: FontWeight.w700,
    height: 56 / 48, letterSpacing: -0.02 * 48,
    color: AppColors.onBackground,
  );

  static TextStyle get headlineLg => GoogleFonts.outfit(
    fontSize: 32, fontWeight: FontWeight.w600,
    height: 40 / 32, letterSpacing: -0.01 * 32,
    color: AppColors.onSurface,
  );

  static TextStyle get headlineLgMobile => GoogleFonts.outfit(
    fontSize: 24, fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.onSurface,
  );

  static TextStyle get titleMd => GoogleFonts.outfit(
    fontSize: 20, fontWeight: FontWeight.w500,
    height: 28 / 20,
    color: AppColors.onSurface,
  );

  // ─── Inter (Body / Labels) ───────────────────────────────────────────────
  static TextStyle get bodyLg => GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle get bodySm => GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  static TextStyle get labelMd => GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w600,
    height: 16 / 12, letterSpacing: 0.05 * 12,
    color: AppColors.onSurface,
  );

  AppTextStyles._();
}

class AppTheme {
  // ─── Elevation Shadows ───────────────────────────────────────────────────
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

  // ─── Border Radius (Shape Language) ─────────────────────────────────────
  static const radiusSm      = BorderRadius.all(Radius.circular(4));   // 4px
  static const radiusDefault = BorderRadius.all(Radius.circular(8));   // 8px
  static const radiusMd      = BorderRadius.all(Radius.circular(12));  // 12px inputs & buttons
  static const radiusLg      = BorderRadius.all(Radius.circular(16));  // 16px product cards
  static const radiusXl      = BorderRadius.all(Radius.circular(24));  // 24px large containers
  static const radiusFull    = BorderRadius.all(Radius.circular(9999)); // pills

  // ─── Spacing ─────────────────────────────────────────────────────────────
  static const spacingXs     = 4.0;
  static const spacingSm     = 8.0;
  static const spacingMd     = 16.0;
  static const spacingLg     = 24.0;
  static const spacingXl     = 32.0;
  static const marginMobile  = 16.0;

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
        displayLarge:  AppTextStyles.displayLg,
        headlineLarge: AppTextStyles.headlineLg,
        headlineMedium: AppTextStyles.headlineLgMobile,
        titleLarge:    AppTextStyles.titleMd,
        bodyLarge:     AppTextStyles.bodyLg,
        bodyMedium:    AppTextStyles.bodySm,
        labelMedium:   AppTextStyles.labelMd,
      ),
      // ─── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface.withValues(alpha: 0.80),
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.outline.withValues(alpha: 0.15),
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineLgMobile.copyWith(
          color: AppColors.onSurface,
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
        labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelMd),
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
          shape: const RoundedRectangleBorder(borderRadius: radiusMd),
          textStyle: AppTextStyles.labelMd,
          elevation: 0,
        ),
      ),
      // ─── Outlined Button ───────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: radiusMd),
          textStyle: AppTextStyles.labelMd,
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
        fillColor: AppColors.secondaryContainer,
        border: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: AppTextStyles.bodyLg.copyWith(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
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
        elevation: 2,
        shape: const RoundedRectangleBorder(borderRadius: radiusLg),
        margin: EdgeInsets.zero,
      ),
      // ─── Chips / Tags ──────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondaryContainer,
        selectedColor: AppColors.primaryFixed,
        labelStyle: AppTextStyles.labelMd,
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
        contentTextStyle: AppTextStyles.bodyLg.copyWith(
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
