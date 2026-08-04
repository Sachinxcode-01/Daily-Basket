import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

/// Welcome to Daily Basket — Google Stitch Design (ID: 0a02e61939ee4e0fa2b27bc15761b067)
///
/// Layout: full-screen, content vertically centred, no card/glassmorphism
/// Background: #f9f9fc with two ambient corner blobs
/// Hero: w-48 h-48 rounded-full bg-surface-container, fruit basket image
/// Title: "Welcome to Daily Basket" — Outfit 32px 700 on-surface
/// Subtitle: Inter 16px on-surface-variant
/// CTA: "Get Started" — full-width h-12 primary green rounded-lg
/// Divider: "or" (lowercase)
/// Social buttons: 3 stacked full-width h-12 outline pills
///   - Continue with Google (Google colour logo)
///   - Continue with Phone (phone_iphone icon, primary)
///   - Continue with Email (mail icon, secondary)
/// Footer: Terms of Service & Privacy Policy links (primary)
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Decorative corner blobs (matches Stitch bg blobs) ─────────────
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.05),
              ),
            ),
          ),

          // ─── Main Content ─────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.marginMobile,
              ),
              child: Column(
                children: [
                  // Top spacer — pushes content to centre
                  const Spacer(),

                  // ─── Hero Image ─────────────────────────────────────────
                  Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainer,
                      boxShadow: AppTheme.level1,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/daily_basket_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── Typography ──────────────────────────────────────────
                  Text(
                    'Welcome to Daily Basket',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 40 / 32,
                      letterSpacing: -0.01 * 32,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
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

                  // ─── Get Started ─────────────────────────────────────────
                  _ActionButton(
                    label: 'Get Started',
                    isPrimary: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen(pageIndex: 0),
                      ),
                    ),
                  ),

                  // ─── "or" divider ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacingMd),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color:
                                AppColors.outlineVariant.withValues(alpha: 0.6),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color:
                                AppColors.outlineVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─── Social / Auth Buttons (stacked, full-width) ─────────
                  _ActionButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    iconColor: const Color(0xFF4285F4),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Connecting Google account...',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.white),
                          ),
                          backgroundColor: AppColors.primary,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      Future.delayed(const Duration(milliseconds: 600), () {
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const OnboardingScreen(pageIndex: 0),
                            ),
                          );
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  _ActionButton(
                    label: 'Continue with Phone',
                    icon: Icons.phone_iphone_rounded,
                    iconColor: AppColors.primary,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  _ActionButton(
                    label: 'Continue with Email',
                    icon: Icons.mail_outline_rounded,
                    iconColor: AppColors.secondary,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),

                  // Bottom spacer
                  const Spacer(),

                  // ─── Terms Footer ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                    child: Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to our ',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
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
        ],
      ),
    );
  }
}

/// Shared action button — primary green fill OR outlined white
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: isPrimary
                  ? null
                  : Border.all(color: AppColors.outlineVariant),
              boxShadow: isPrimary ? AppTheme.level1 : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: isPrimary
                        ? AppColors.onPrimary
                        : (iconColor ?? AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        isPrimary ? AppColors.onPrimary : AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
