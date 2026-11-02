import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/providers/app_theme_provider.dart';

/// App Theme Screen — Exact Google Stitch Specification
/// Fully supports interactive switching between System, Light, and Dark modes.
class AppThemeScreen extends StatelessWidget {
  const AppThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeProvider = context.watch<AppThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121416) : const Color(0xFFF9F9FC);
    final cardBg = isDark ? const Color(0xFF1E2124) : Colors.white;
    final textTitleColor = isDark ? const Color(0xFFF0F0F3) : const Color(0xFF1A1C1E);
    final textSubColor = isDark ? const Color(0xFFBECAB9) : const Color(0xFF3F4A3D);
    final activeGreen = isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23);
    final cardBorderUnselected = isDark ? const Color(0xFF303438) : const Color(0xFFE2E2E5);

    return Scaffold(
      backgroundColor: scaffoldBg,
      drawer: const AppNavigationDrawer(isDrawer: true),
      bottomNavigationBar: const AppBottomNav(currentIndex: 5),
      appBar: const AppTopBar(
        title: 'App Theme',
        showBack: true,
        showDrawer: true,
        showProfile: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customize your Daily Basket experience. Choose how you want the app to look.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: textSubColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Option 1: System Default
                _buildThemeCard(
                  context,
                  value: 'system',
                  title: 'System Default',
                  description: "Automatically matches your device's display settings.",
                  selectedThemeKey: appThemeProvider.selectedThemeKey,
                  cardBg: cardBg,
                  textTitleColor: textTitleColor,
                  textSubColor: textSubColor,
                  activeGreen: activeGreen,
                  cardBorderUnselected: cardBorderUnselected,
                  isDark: isDark,
                  previewWidget: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: activeGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.settings_brightness_rounded,
                      color: activeGreen,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Option 2: Light Mode
                _buildThemeCard(
                  context,
                  value: 'light',
                  title: 'Light Mode',
                  description: 'Clean, crisp, and bright. Perfect for daytime shopping.',
                  selectedThemeKey: appThemeProvider.selectedThemeKey,
                  cardBg: cardBg,
                  textTitleColor: textTitleColor,
                  textSubColor: textSubColor,
                  activeGreen: activeGreen,
                  cardBorderUnselected: cardBorderUnselected,
                  isDark: isDark,
                  previewWidget: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E2E5)),
                    ),
                    child: const Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredBox(
                              color: Color(0xFFF3F3F6),
                              child: SizedBox(height: 6, width: double.infinity),
                            ),
                            SizedBox(height: 4),
                            ColoredBox(
                              color: Color(0xFFF3F3F6),
                              child: SizedBox(height: 6, width: 32),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.light_mode_outlined, color: Color(0xFF1A1C1E), size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Option 3: Dark Mode
                _buildThemeCard(
                  context,
                  value: 'dark',
                  title: 'Dark Mode',
                  description: 'Easy on the eyes in low light, with high-contrast emerald elements.',
                  selectedThemeKey: appThemeProvider.selectedThemeKey,
                  cardBg: cardBg,
                  textTitleColor: textTitleColor,
                  textSubColor: textSubColor,
                  activeGreen: activeGreen,
                  cardBorderUnselected: cardBorderUnselected,
                  isDark: isDark,
                  previewWidget: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1C1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF34373B)),
                    ),
                    child: const Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredBox(
                              color: Color(0xFF2F3133),
                              child: SizedBox(height: 6, width: double.infinity),
                            ),
                            SizedBox(height: 4),
                            ColoredBox(
                              color: Color(0xFF2F3133),
                              child: SizedBox(height: 6, width: 32),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.dark_mode_outlined, color: Color(0xFF70DD7A), size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required String value,
    required String title,
    required String description,
    required String selectedThemeKey,
    required Widget previewWidget,
    required Color cardBg,
    required Color textTitleColor,
    required Color textSubColor,
    required Color activeGreen,
    required Color cardBorderUnselected,
    required bool isDark,
  }) {
    final isSelected = selectedThemeKey == value;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<AppThemeProvider>().setTheme(value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Theme set to $title'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: activeGreen,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeGreen : cardBorderUnselected,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            previewWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: textTitleColor,
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? activeGreen : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? activeGreen : const Color(0xFFBECAB9),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textSubColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
