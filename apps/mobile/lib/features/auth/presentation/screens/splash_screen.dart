import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'welcome_screen.dart';

/// Splash Screen — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/splash_screen/
///
/// Background: linear-gradient(135deg, #078730 → #00531a)
/// Logo: 128×128 rounded-3xl glassmorphism container
/// Title: Outfit 48px/56px bold, white, fade-in-up
/// Subtitle: "Fresh Groceries Delivered Fast", Outfit 20px/28px, white/80%
/// Bottom: 3 pulsing white dots loader
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ─── Fade-In-Up Animations ────────────────────────────────────────────────
  late AnimationController _logoCtrl;
  late AnimationController _titleCtrl;
  late AnimationController _subtitleCtrl;
  late AnimationController _dotsCtrl;

  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _dotsOpacity;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _subtitleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final curve = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _logoSlide   = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(curve);

    final curveTitle = CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut);
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(curveTitle);
    _titleSlide   = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(curveTitle);

    final curveSub = CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOut);
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(curveSub);
    _subtitleSlide   = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(curveSub);

    final curveDots = CurvedAnimation(parent: _dotsCtrl, curve: Curves.easeOut);
    _dotsOpacity = Tween<double>(begin: 0, end: 1).animate(curveDots);

    // Staggered: logo → title (100ms) → subtitle+dots (300ms)
    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _titleCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _subtitleCtrl.forward();
        _dotsCtrl.forward();
      }
    });

    // Navigate after 3 seconds (matching Stitch 3000ms timeout)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ─── Stitch: linear-gradient(135deg, #078730 0%, #00531a 100%)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF078730), Color(0xFF00531A)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Center Content ────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.marginMobile,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container (glassmorphism, 128×128, rounded-3xl)
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: SlideTransition(
                          position: _logoSlide,
                          child: Container(
                            width: 128,
                            height: 128,
                            margin: const EdgeInsets.only(bottom: AppTheme.spacingLg),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(24), // rounded-3xl
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.20),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Frosted glass blur layer
                                  Container(
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                  // Official Daily Basket Logo Asset
                                  Image.asset(
                                    'assets/images/daily_basket_logo.png',
                                    width: 104,
                                    height: 104,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Title: "Daily Basket" — Outfit 48px 700, white
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Text(
                            'Daily Basket',
                            style: GoogleFonts.outfit(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              height: 56 / 48,
                              letterSpacing: -0.02 * 48,
                              color: AppColors.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingSm),

                      // Subtitle: "Fresh Groceries Delivered Fast" — Outfit 20px 500, white/80%
                      FadeTransition(
                        opacity: _subtitleOpacity,
                        child: SlideTransition(
                          position: _subtitleSlide,
                          child: Text(
                            'Fresh Groceries Delivered Fast',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 28 / 20,
                              color: AppColors.onPrimary.withValues(alpha: 0.80),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Bottom: 3 pulsing white dots ─────────────────────────
              FadeTransition(
                opacity: _dotsOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppTheme.spacingLg * 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return _PulsingDot(delayMs: i * 150);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pulsing dot loader matching Stitch splash pulse animation
class _PulsingDot extends StatefulWidget {
  final int delayMs;
  const _PulsingDot({required this.delayMs});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _anim = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FadeTransition(
        opacity: _anim,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.onPrimary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
