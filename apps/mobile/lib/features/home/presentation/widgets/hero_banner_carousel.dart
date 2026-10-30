import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroBannerData {
  final String id;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String ctaText;
  final String? assetPath;
  final String route;
  final List<Color> gradientColors;
  final IconData badgeIcon;

  const HeroBannerData({
    required this.id,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    this.assetPath,
    required this.route,
    required this.gradientColors,
    required this.badgeIcon,
  });
}

class HeroBannerCarousel extends StatefulWidget {
  final VoidCallback? onOffersTap;
  final VoidCallback? onCategoriesTap;

  const HeroBannerCarousel({
    super.key,
    this.onOffersTap,
    this.onCategoriesTap,
  });

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  bool _isUserInteracting = false;

  static const List<HeroBannerData> _banners = [
    HeroBannerData(
      id: 'fresh_arrivals',
      eyebrow: 'FARM FRESH DIRECT',
      title: 'Fresh Arrivals',
      subtitle: 'Up to 20% off organic vegetables & dewy greens',
      ctaText: 'Shop Now',
      assetPath: 'assets/illustrations/fresharrivalbg.png',
      route: '/categories',
      gradientColors: [
        Color(0xFF2D9D43),
        Color(0xFF078730),
      ],
      badgeIcon: Icons.eco_rounded,
    ),
    HeroBannerData(
      id: 'kirana_express',
      eyebrow: '⚡ 10-MIN EXPRESS',
      title: 'Morning Essentials',
      subtitle: 'Free delivery on milk, eggs, bread & poha staples',
      ctaText: 'Order Essentials',
      assetPath: 'assets/illustrations/delivery_rider_3d.png',
      route: '/categories',
      gradientColors: [
        Color(0xFF0F766E),
        Color(0xFF0D9488),
      ],
      badgeIcon: Icons.bolt_rounded,
    ),
    HeroBannerData(
      id: 'flash_offers',
      eyebrow: 'SUPER SAVER FEST',
      title: 'Flat 40% OFF',
      subtitle: 'Apply code FRESH40 on your first 3 farm orders',
      ctaText: 'View Offers',
      assetPath: 'assets/illustrations/gift_box_rewards_3d.png',
      route: '/coupons',
      gradientColors: [
        Color(0xFFB45309),
        Color(0xFFD97706),
      ],
      badgeIcon: Icons.local_offer_rounded,
    ),
    HeroBannerData(
      id: 'quality_promise',
      eyebrow: '100% ORGANIC & PURE',
      title: 'Daily Basket Select',
      subtitle: 'Handpicked daily from verified sustainable farms',
      ctaText: 'Explore Select',
      assetPath: 'assets/illustrations/grocery_basket_3d.png',
      route: '/freshness',
      gradientColors: [
        Color(0xFF1E3A8A),
        Color(0xFF2563EB),
      ],
      badgeIcon: Icons.verified_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_isUserInteracting || !mounted) return;
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _handleBannerTap(HeroBannerData banner) {
    HapticFeedback.lightImpact();
    if (banner.route == '/coupons' && widget.onOffersTap != null) {
      widget.onOffersTap!();
    } else if (banner.route == '/categories' &&
        widget.onCategoriesTap != null) {
      widget.onCategoriesTap!();
    } else {
      Navigator.pushNamed(context, banner.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 185,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _isUserInteracting = true;
              } else if (notification is ScrollEndNotification) {
                _isUserInteracting = false;
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (idx) => setState(() => _currentPage = idx),
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildBannerCard(banner),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildPageIndicators(),
      ],
    );
  }

  Widget _buildBannerCard(HeroBannerData banner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () => _handleBannerTap(banner),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: banner.gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: banner.gradientColors.first.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Illustration / Artwork
              if (banner.assetPath != null)
                Positioned(
                  right: -10,
                  bottom: -15,
                  top: -10,
                  width: 170,
                  child: Opacity(
                    opacity: 0.88,
                    child: Image.asset(
                      banner.assetPath!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                ),

              // Gradient Scrim for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      banner.gradientColors.first.withValues(alpha: 0.95),
                      banner.gradientColors.first.withValues(alpha: 0.70),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.58, 1.0],
                  ),
                ),
              ),

              // Text Content & Actions
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Eyebrow Chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(banner.badgeIcon, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            banner.eyebrow,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Main Headline
                    Text(
                      banner.title,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 210),
                      child: Text(
                        banner.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // CTA Pill Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            banner.ctaText,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: banner.gradientColors.first,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: banner.gradientColors.first,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_banners.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF2D9D43)
                : const Color(0xFFBECAB9).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(9999),
          ),
        );
      }),
    );
  }
}
