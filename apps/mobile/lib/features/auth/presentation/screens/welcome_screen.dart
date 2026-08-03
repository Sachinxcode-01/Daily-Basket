import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

/// Welcome Screen — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/welcome_to_daily_basket/
///
/// Background: #f9f9fc with ambient blobs (secondary-container + primary-container)
/// Panel: Glassmorphism card — rgba(255,255,255,0.7) + blur(12px)
/// Logo: 128×128 circular, rounded, shadow
/// Title: "Welcome to Daily Basket" — Outfit 48px 700, primary green
/// Subtitle: "Fresh groceries, daily essentials..." — Inter 16px, onSurfaceVariant
/// CTA: "Get Started" — full-width pill, primary green, shadow
/// Divider: "Or continue with"
/// Google OAuth: full-width white pill with G logo
/// Phone + Email: 2-column pill buttons
/// Footer: Terms & Privacy links
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Ambient Background Blobs ────────────────────────────────────
          Positioned(
            top: -100,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.30),
              ),
              // Blur effect via opacity — full BackdropFilter requires separate widget
            ),
          ),
          Positioned(
            bottom: -120,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(alpha: 0.10),
              ),
            ),
          ),

          // ─── Main Content ────────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.marginMobile),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.spacingXl),

                      // ─── Glassmorphism Card ──────────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.spacingXl),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.70),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.50),
                            ),
                            boxShadow: AppTheme.level2,
                          ),
                          child: Column(
                            children: [
                              // Logo
                              Container(
                                width: 128,
                                height: 128,
                                margin: const EdgeInsets.only(
                                    bottom: AppTheme.spacingLg),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest,
                                  shape: BoxShape.circle,
                                  boxShadow: AppTheme.level1,
                                ),
                                child: const Icon(
                                  Icons.shopping_basket_rounded,
                                  size: 64,
                                  color: AppColors.primary,
                                ),
                              ),

                              // Title: "Welcome to Daily Basket"
                              Text(
                                'Welcome to Daily Basket',
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  height: 40 / 32,
                                  letterSpacing: -0.01 * 32,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: AppTheme.spacingXl),

                              // Subtitle
                              Text(
                                'Fresh groceries, daily essentials, and exclusive offers delivered to your doorstep.',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 24 / 16,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: AppTheme.spacingXl),

                              // ─── Actions ──────────────────────────────────

                              // "Get Started" primary pill button
                              _WelcomeButton(
                                label: 'Get Started',
                                isPrimary: true,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const OnboardingScreen(pageIndex: 0),
                                  ),
                                ),
                              ),

                              // ─── Divider ──────────────────────────────────
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppTheme.spacingMd),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.outlineVariant
                                            .withValues(alpha: 0.50),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        'OR CONTINUE WITH',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.05 * 10,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.outlineVariant
                                            .withValues(alpha: 0.50),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Google OAuth pill
                              _WelcomeButton(
                                label: 'Continue with Google',
                                icon: Icons.g_mobiledata_rounded,
                                onTap: () {}, // TODO: Google OAuth
                              ),

                              const SizedBox(height: AppTheme.spacingMd),

                              // Phone + Email 2-column
                              Row(
                                children: [
                                  Expanded(
                                    child: _WelcomeButton(
                                      label: 'Phone',
                                      icon: Icons.smartphone_rounded,
                                      onTap: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacingMd),
                                  Expanded(
                                    child: _WelcomeButton(
                                      label: 'Email',
                                      icon: Icons.mail_outline_rounded,
                                      onTap: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Terms footer
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: AppTheme.spacingLg),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'By continuing, you agree to our ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.70),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingXl),
                    ],
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

/// Reusable pill button matching Stitch welcome screen buttons
class _WelcomeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _WelcomeButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primary
                : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(9999),
            border: isPrimary
                ? null
                : Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.30),
                  ),
            boxShadow: isPrimary ? AppTheme.level2 : AppTheme.level1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: isPrimary ? AppColors.onPrimary : AppColors.primary,
                ),
                const SizedBox(width: AppTheme.spacingXs),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05 * 12,
                  color: isPrimary ? AppColors.onPrimary : AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
