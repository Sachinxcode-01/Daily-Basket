import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/screens/home_screen.dart' show CustomerHomeScreen;

/// Ready to Shop Screen — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/ready_to_shop/
///
/// Background: celebration gradient
///   linear-gradient(135deg, rgba(140,250,147,0.15) 0%, rgba(249,249,252,1) 50%, rgba(220,229,221,0.3) 100%)
/// Decorative blobs: primary-fixed (top-left, float-slow) + secondary-container (bottom-right, float-fast)
///
/// Hero Container (192×192):
///   - Glassmorphism backdrop: bg-surface/40 blur-md rounded-full
///   - Daily Basket logo icon
///   - Success badge: primary bg, white check, -bottom-2 -right-2
///   - Decorative sparkle icons: arrow_back_ios_new (primary, float-fast), eco (outline, float-slow)
///
/// Typography:
///   - "Everything is " + "Ready!" (primary color) — Outfit 48px 700
///   - Subtitle — Inter 16px on-surface-variant max-w-[280px]
///
/// Actions:
///   - "Start Shopping" — primary btn + shopping_basket icon
///   - "Browse Categories" — secondary btn + grid_view icon
class ReadyToShopScreen extends StatefulWidget {
  const ReadyToShopScreen({super.key});

  @override
  State<ReadyToShopScreen> createState() => _ReadyToShopScreenState();
}

class _ReadyToShopScreenState extends State<ReadyToShopScreen>
    with TickerProviderStateMixin {
  late AnimationController _popInCtrl;
  late Animation<double> _popInScale;
  late Animation<double> _popInOpacity;

  late AnimationController _floatSlowCtrl;
  late AnimationController _floatFastCtrl;
  late Animation<double> _floatSlowAnim;
  late Animation<double> _floatFastAnim;

  @override
  void initState() {
    super.initState();

    // Pop-in animation for hero
    _popInCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _popInScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.05),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _popInCtrl,
      curve: const Cubic(0.175, 0.885, 0.32, 1.275),
    ));
    _popInOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _popInCtrl,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    _popInCtrl.forward();

    // Float slow (blobs)
    _floatSlowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatSlowAnim = Tween<double>(begin: 0, end: -10)
        .animate(CurvedAnimation(parent: _floatSlowCtrl, curve: Curves.easeInOut));

    // Float fast (decorative icons)
    _floatFastCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _floatFastAnim = Tween<double>(begin: 0, end: -10)
        .animate(CurvedAnimation(parent: _floatFastCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _popInCtrl.dispose();
    _floatSlowCtrl.dispose();
    _floatFastCtrl.dispose();
    super.dispose();
  }

  void _startShopping() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CustomerHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Celebration gradient background ────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x268CFA93), // rgba(140,250,147,0.15)
                  Color(0xFFF9F9FC), // #f9f9fc full
                  Color(0x4DDCE5DD), // rgba(220,229,221,0.3)
                ],
                stops: [0.0, 0.50, 1.0],
              ),
            ),
          ),

          // ─── Decorative float blobs ──────────────────────────────────────
          AnimatedBuilder(
            animation: _floatSlowAnim,
            builder: (context, child) => Positioned(
              top: -80 + _floatSlowAnim.value,
              left: -80,
              child: child!,
            ),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed.withValues(alpha: 0.20),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _floatFastAnim,
            builder: (context, child) => Positioned(
              bottom: -80 + _floatFastAnim.value,
              right: -80,
              child: child!,
            ),
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.30),
              ),
            ),
          ),

          // ─── Main Content ────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.marginMobile),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ─── Hero Graphic ──────────────────────────────────────
                      ScaleTransition(
                        scale: _popInScale,
                        child: FadeTransition(
                          opacity: _popInOpacity,
                          child: SizedBox(
                            width: 192,
                            height: 192,
                            child: Stack(
                              children: [
                                // Glassmorphism backdrop circle
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.surface.withValues(alpha: 0.40),
                                    border: Border.all(
                                      color: AppColors.surfaceContainerHighest
                                          .withValues(alpha: 0.50),
                                    ),
                                    boxShadow: AppTheme.level2,
                                  ),
                                ),
                                 // 3D Location Pin Illustration Asset
                                 Center(
                                   child: Padding(
                                     padding: const EdgeInsets.all(24.0),
                                     child: Image.asset(
                                       'assets/illustrations/location_pin_3d.png',
                                       fit: BoxFit.contain,
                                     ),
                                   ),
                                 ),
                                // Decorative eco icon (float slow)
                                AnimatedBuilder(
                                  animation: _floatSlowAnim,
                                  builder: (ctx, child) => Positioned(
                                    bottom: 24 + _floatSlowAnim.value * 0.5,
                                    left: 8,
                                    child: child!,
                                  ),
                                  child: const Icon(
                                    Icons.eco_rounded,
                                    size: 24,
                                    color: AppColors.outline,
                                  ),
                                ),
                                // Decorative sparkle (float fast)
                                AnimatedBuilder(
                                  animation: _floatFastAnim,
                                  builder: (ctx, child) => Positioned(
                                    top: 16 + _floatFastAnim.value * 0.5,
                                    right: 16,
                                    child: child!,
                                  ),
                                  child: const Icon(
                                    Icons.star_rounded,
                                    size: 24,
                                    color: AppColors.primary,
                                  ),
                                ),
                                // Success badge
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.surface,
                                        width: 4,
                                      ),
                                      boxShadow: AppTheme.level1,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: AppColors.onPrimary,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingXl),

                      // ─── Typography ────────────────────────────────────────
                      Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Everything is ',
                                  style: GoogleFonts.outfit(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    height: 56 / 48,
                                    letterSpacing: -0.02 * 48,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Ready!',
                                  style: GoogleFonts.outfit(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    height: 56 / 48,
                                    letterSpacing: -0.02 * 48,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              "Let's start shopping and discover thousands of fresh, organic products waiting for you.",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 24 / 16,
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingXl),

                      // ─── Actions ───────────────────────────────────────────
                      Column(
                        children: [
                          // Start Shopping — primary
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _startShopping,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(
                                  Icons.shopping_basket_outlined, size: 20),
                              label: Text(
                                'Start Shopping',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.05 * 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingMd),

                          // Browse Categories — secondary
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: _startShopping,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                    color: AppColors.outlineVariant),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.grid_view_rounded, size: 20),
                              label: Text(
                                'Browse Categories',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.05 * 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
