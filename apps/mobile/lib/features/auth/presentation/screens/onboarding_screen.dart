import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'location_permission_screen.dart';

/// Unified Onboarding Screen — Google Stitch Design System
/// Implements ALL 4 onboarding pages from Stitch:
///
/// Page 0 (onboarding_freshness):
///   "Freshness Delivered Every Day"
///   "Shop farm-fresh fruits, vegetables, dairy..."
///   Illustration: basket emoji/icon
///
/// Page 1 (onboarding_speed):
///   "Lightning Fast Delivery"
///   "Get your essentials delivered quickly with real-time tracking..."
///   Illustration: delivery rider
///
/// Page 2 (onboarding_rewards):
///   "Earn While You Shop"
///   "Collect Daily Points on every order..."
///   Illustration: gift box
///
/// Page 3 (onboarding_security):
///   "Safe & Secure Payments"
///   "Shop with confidence with our encrypted payment gateway..."
///   Illustration: payment shield
///
/// Navigation:
/// - Back arrow (top left)
/// - Skip button (top right, hidden on last page)
/// - Progress dots (bottom left, active dot wider: w-8)
/// - "Next" pill button (bottom right) → on last page → "Get Started" → LoginScreen

class OnboardingScreen extends StatefulWidget {
  final int pageIndex;

  const OnboardingScreen({super.key, this.pageIndex = 0});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _enterCtrl;
  late Animation<double> _enterFade;
  late Animation<Offset> _enterSlide;

  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      title: 'Freshness Delivered Every Day',
      subtitle:
          'Shop farm-fresh fruits, vegetables, dairy, groceries, and daily essentials from your trusted local store.',
      icon: Icons.shopping_basket_rounded,
      assetPath: 'assets/illustrations/grocery_basket_3d.png',
      iconColor: AppColors.primary,
      bgColor1: AppColors.secondaryContainer,
      bgColor2: AppColors.primaryFixed,
    ),
    _OnboardingPage(
      title: 'Lightning Fast Delivery',
      subtitle:
          'Get your essentials delivered quickly with real-time order tracking from checkout to your doorstep.',
      icon: Icons.delivery_dining_rounded,
      assetPath: 'assets/illustrations/delivery_rider_3d.png',
      iconColor: AppColors.primary,
      bgColor1: AppColors.primaryFixed,
      bgColor2: AppColors.secondaryContainer,
    ),
    _OnboardingPage(
      title: 'Easy Payments & Secure Checkout',
      subtitle:
          'Pay securely using UPI, cards, wallets, or cash on delivery with enterprise-grade security.',
      icon: Icons.security_rounded,
      assetPath: 'assets/illustrations/secure_payments_3d.png',
      iconColor: AppColors.primary,
      bgColor1: AppColors.secondaryContainer,
      bgColor2: AppColors.primaryFixed,
    ),
    _OnboardingPage(
      title: 'Rewards, Offers & Savings',
      subtitle:
          'Earn loyalty points, unlock exclusive deals, cashback coupons, and save more on every order.',
      icon: Icons.card_giftcard_rounded,
      assetPath: 'assets/illustrations/gift_box_rewards_3d.png',
      iconColor: AppColors.primary,
      bgColor1: AppColors.primaryFixed,
      bgColor2: AppColors.secondaryContainer,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageIndex.clamp(0, _pages.length - 1);
    _pageController = PageController(initialPage: _currentPage);

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _enterFade  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut),
    );
    _enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _enterCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }


  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() => _completeOnboarding();

  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LocationPermissionScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Decorative background blobs ────────────────────────────────
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.20),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed.withValues(alpha: 0.10),
              ),
            ),
          ),

          // ─── Main Page View ──────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (idx) {
              setState(() => _currentPage = idx);
              _enterCtrl
                ..reset()
                ..forward();
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _buildPage(page);
            },
          ),

          // ─── Top: Back + Skip ────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.marginMobile,
              ),
              child: SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.onSurfaceVariant,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: const CircleBorder(),
                      ),
                    ),

                    // Skip button (hidden on last page)
                    if (!isLast)
                      TextButton(
                        onPressed: _skip,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.05 * 12,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 56),
                  ],
                ),
              ),
            ),
          ),

          // ─── Bottom: Progress dots + Next button ─────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // Frosted glass footer
              padding: EdgeInsets.fromLTRB(
                AppTheme.marginMobile,
                AppTheme.spacingMd,
                AppTheme.marginMobile,
                MediaQuery.of(context).padding.bottom + AppTheme.spacingLg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0),
                    AppColors.background.withValues(alpha: 0.95),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress dots (centered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Full-width Next / Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLast ? 'Get Started' : 'Next',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isLast
                                ? Icons.shopping_basket_outlined
                                : Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
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

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.marginMobile),
      child: Column(
        children: [
          // Spacer for top nav
          const SizedBox(height: 72),

          // ─── Illustration Area (Enlarged Hero + Realtime Float Animation) ──
          Expanded(
            flex: 5,
            child: FadeTransition(
              opacity: _enterFade,
              child: SlideTransition(
                position: _enterSlide,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient Glow blob behind illustration
                      Container(
                        width: 310,
                        height: 310,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: page.bgColor1.withValues(alpha: 0.25),
                        ),
                      ),
                      // Realtime Floating 3D PNG Illustration Asset (Enlarged 300px)
                      AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset(
                            page.assetPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


          // ─── Text Content (Glassmorphism card) ──────────────────────────
          FadeTransition(
            opacity: _enterFade,
            child: SlideTransition(
              position: _enterSlide,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacingXl),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        page.title,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 32 / 24,
                          color: AppColors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        page.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom spacer for progress bar overlay
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final String assetPath;
  final Color iconColor;
  final Color bgColor1;
  final Color bgColor2;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.assetPath,
    required this.iconColor,
    required this.bgColor1,
    required this.bgColor2,
  });
}
