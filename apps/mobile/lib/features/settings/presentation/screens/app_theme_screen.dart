import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme Screen — Exact Google Stitch Specification
/// Screen ID: f6f93254f18c40cc99150e768b33f0f0
class AppThemeScreen extends StatefulWidget {
  const AppThemeScreen({super.key});

  @override
  State<AppThemeScreen> createState() => _AppThemeScreenState();
}

class _AppThemeScreenState extends State<AppThemeScreen> {
  String _selectedTheme = 'system';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF006B23),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'App Theme',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1C1E),
          ),
        ),
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
                    color: const Color(0xFF3F4A3D),
                  ),
                ),
                const SizedBox(height: 24),

                // Option 1: System Default
                _buildThemeCard(
                  value: 'system',
                  title: 'System Default',
                  description: 'Automatically matches your device\'s display settings.',
                  previewWidget: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006B23).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings_brightness_rounded,
                      color: Color(0xFF006B23),
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Option 2: Light Mode
                _buildThemeCard(
                  value: 'light',
                  title: 'Light Mode',
                  description: 'Clean, crisp, and bright. Perfect for daytime shopping.',
                  previewWidget: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E2E5)),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 6, width: double.infinity, color: const Color(0xFFF3F3F6)),
                            const SizedBox(height: 4),
                            Container(height: 6, width: 32, color: const Color(0xFFF3F3F6)),
                          ],
                        ),
                        const Align(
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
                  value: 'dark',
                  title: 'Dark Mode',
                  description: 'Easy on the eyes in low light, with high-contrast elements.',
                  previewWidget: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 6, width: double.infinity, color: const Color(0xFF2F3133)),
                            const SizedBox(height: 4),
                            Container(height: 6, width: 32, color: const Color(0xFF2F3133)),
                          ],
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.dark_mode_outlined, color: Color(0xFFF9F9FC), size: 24),
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

  Widget _buildThemeCard({
    required String value,
    required String title,
    required String description,
    required Widget previewWidget,
  }) {
    final isSelected = _selectedTheme == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Theme set to $title'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF006B23) : const Color(0xFFE2E2E5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? const Color(0xFF006B23) : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF006B23) : const Color(0xFFBECAB9),
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
                      color: const Color(0xFF3F4A3D),
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
