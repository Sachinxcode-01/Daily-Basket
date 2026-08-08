import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_motion.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

/// Welcome to Daily Basket — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/welcome/
///
/// Background: #f9f9fc with two ambient corner blobs
/// Hero: w-48 h-48 rounded-full bg-surface-container, Daily Basket logo
/// Title: "Welcome to Daily Basket" — Outfit 32px 700 on-surface — typewriter
/// Subtitle: Inter 16px on-surface-variant — fade-in after title
/// CTA: "Get Started" — full-width h-12 primary green rounded-lg
/// Divider: "or" (lowercase)
/// Social buttons: 3 stacked full-width h-12 outline pills
/// Footer: Terms of Service & Privacy Policy links (primary)
///
/// Animation order (staggered entry):
///   0ms  → Logo  (scale + fade)
///   400ms→ Title (typewriter)
///   1200ms→ Subtitle (fade-up)
///   1500ms→ Buttons (stagger, 80ms apart)
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  late AnimationController _subtitleCtrl;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;

  late AnimationController _buttonsCtrl;
  late Animation<double> _buttonsFade;
  late Animation<Offset> _buttonsSlide;

  bool _showTypewriter = false;

  @override
  void initState() {
    super.initState();

    // Logo: scale 0.8→1.0 + fade
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );

    // Subtitle fade-up
    _subtitleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOut),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOutCubic));

    // Buttons fade-up
    _buttonsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _buttonsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonsCtrl, curve: Curves.easeOut),
    );
    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _buttonsCtrl, curve: Curves.easeOutCubic));

    _startSequence();
  }

  void _startSequence() async {
    // 1. Logo pops in
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // 2. Typewriter title starts
    if (mounted) setState(() => _showTypewriter = true);
    await Future.delayed(const Duration(milliseconds: 900)); // ~65ms × 14 chars

    // 3. Subtitle fades in
    if (mounted) _subtitleCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    // 4. Buttons fade in
    if (mounted) _buttonsCtrl.forward();
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _subtitleCtrl.dispose();
    _buttonsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Ambient corner blobs (Stitch spec) ──────────────────────────
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

          // ─── Main Content ────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.marginMobile),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(),

                  // Hero Image — Logo, animated
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Container(
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
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Title — Typewriter "Welcome to Daily Basket"
                  if (_showTypewriter)
                    TypewriterText(
                      text: 'Welcome to Daily Basket',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 40 / 32,
                        letterSpacing: -0.01 * 32,
                        color: AppColors.onSurface,
                      ),
                      cursorColor: AppColors.primary,
                      charDuration: const Duration(milliseconds: 55),
                    )
                  else
                    const SizedBox(height: 40),

                  const SizedBox(height: AppTheme.spacingSm),

                  // Subtitle — fade + slide
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: SlideTransition(
                      position: _subtitleSlide,
                      child: Text(
                        'Fresh groceries, daily essentials, and exclusive offers delivered to your doorstep in minutes.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingXl),

                  // Buttons — fade + slide
                  FadeTransition(
                    opacity: _buttonsFade,
                    child: SlideTransition(
                      position: _buttonsSlide,
                      child: Column(
                        children: [
                          // Get Started
                          _WelcomeButton(
                            label: 'Get Started',
                            isPrimary: true,
                            onTap: () => Navigator.of(context).push(
                              AppPageTransitions.sharedAxisX(
                                const OnboardingScreen(pageIndex: 0),
                              ),
                            ),
                          ),

                          // "or" divider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                            child: Row(
                              children: [
                                Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('or', style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant)),
                                ),
                                Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
                              ],
                            ),
                          ),

                          _WelcomeButton(
                            label: 'Continue with Google',
                            icon: Icons.g_mobiledata_rounded,
                            iconColor: const Color(0xFF4285F4),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Connecting Google account...', style: GoogleFonts.inter(fontSize: 13, color: Colors.white)),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              Future.delayed(const Duration(milliseconds: 600), () {
                                if (context.mounted) {
                                  Navigator.of(context).push(
                                    AppPageTransitions.sharedAxisX(const OnboardingScreen(pageIndex: 0)),
                                  );
                                }
                              });
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          _WelcomeButton(
                            label: 'Continue with Phone',
                            icon: Icons.phone_iphone_rounded,
                            iconColor: AppColors.primary,
                            onTap: () => Navigator.of(context).push(
                              AppPageTransitions.sharedAxisX(const LoginScreen()),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          _WelcomeButton(
                            label: 'Continue with Email',
                            icon: Icons.mail_outline_rounded,
                            iconColor: AppColors.secondary,
                            onTap: () => Navigator.of(context).push(
                              AppPageTransitions.sharedAxisX(const LoginScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Footer — ToS & Privacy
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                    child: Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to our ',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isPrimary;
  final VoidCallback onTap;

  const _WelcomeButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Ink(
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: isPrimary ? null : Border.all(color: AppColors.outlineVariant),
            boxShadow: isPrimary ? AppTheme.level1 : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: isPrimary ? AppColors.onPrimary : (iconColor ?? AppColors.primary)),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
