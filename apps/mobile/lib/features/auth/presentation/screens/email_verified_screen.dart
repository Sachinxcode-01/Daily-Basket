import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Email Verified Successfully Screen — Exact User Mockup Specification
/// Matches:
/// - Soft organic ambient gradient background
/// - Centered white rounded card container (28px corner radius)
/// - Solid green circle badge icon with white checkmark circle ring
/// - Title: "Email Verified Successfully"
/// - Subtitle: "Your account has been confirmed.\nYou are ready to start shopping for\nfresh, organic groceries."
/// - Primary dark green pill button: "Continue to App"
class EmailVerifiedScreen extends StatelessWidget {
  const EmailVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Glow Blob
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(alpha: 0.25),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.marginMobile,
                  vertical: AppTheme.spacingLg,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ─── Solid Green Checkmark Badge Icon ──────────────────
                        Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 52,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ─── Title: Email Verified Successfully ────────────────
                        Text(
                          'Email Verified Successfully',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // ─── Subtitle ──────────────────────────────────────────
                        Text(
                          'Your account has been confirmed.\nYou are ready to start shopping for\nfresh, organic groceries.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 22 / 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // ─── Primary Dark Green Pill Button: Continue to App ────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/customer/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: Text(
                              'Continue to App',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
