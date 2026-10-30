import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../referral/providers/coupon_provider.dart';

class OfferCardModel {
  final String code;
  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;

  const OfferCardModel({
    required this.code,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
  });
}

class OffersCarouselSection extends StatelessWidget {
  final VoidCallback? onViewAll;

  const OffersCarouselSection({
    super.key,
    this.onViewAll,
  });

  static const List<OfferCardModel> _offers = [
    OfferCardModel(
      code: 'FRESH40',
      eyebrow: 'FRESH PRODUCE',
      title: 'Flat 40% OFF',
      subtitle: 'On your first 3 orders above ₹199',
      gradientColors: [Color(0xFF2D9D43), Color(0xFF078730)],
      icon: Icons.eco_rounded,
    ),
    OfferCardModel(
      code: 'BOGOCHEESE',
      eyebrow: 'GOURMET SELECTION',
      title: 'Buy 1 Get 1',
      subtitle: 'Artisanal cheese, sourdough & curd',
      gradientColors: [Color(0xFF374151), Color(0xFF1F2937)],
      icon: Icons.bakery_dining_rounded,
    ),
    OfferCardModel(
      code: 'ORGANIC15',
      eyebrow: 'ORGANIC STAPLES',
      title: '15% OFF',
      subtitle: 'Valid on organic pulses and grains',
      gradientColors: [Color(0xFF065F46), Color(0xFF047857)],
      icon: Icons.verified_user_outlined,
    ),
    OfferCardModel(
      code: 'SHIPFREE',
      eyebrow: 'WEEKEND SPECIAL',
      title: 'Free Delivery',
      subtitle: 'Free delivery on all orders this weekend',
      gradientColors: [Color(0xFF0369A1), Color(0xFF0284C7)],
      icon: Icons.local_shipping_outlined,
    ),
  ];

  void _applyCoupon(BuildContext context, String code) {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: code));

    CouponProvider? couponProvider;
    try {
      couponProvider = Provider.of<CouponProvider>(context, listen: false);
      couponProvider.applyCouponByCode(code, 400.0);
    } catch (_) {}

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF191C1E),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF8CFA93), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Coupon "$code" copied & applied! 🎉',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Best Offers',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF191C1E),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (onViewAll != null) {
                    onViewAll!();
                  } else {
                    Navigator.pushNamed(context, '/coupons');
                  }
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D9D43),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal Offer Cards
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _offers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final offer = _offers[index];
              return _buildOfferCard(context, offer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(BuildContext context, OfferCardModel offer) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: offer.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: offer.gradientColors.first.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon Watermark
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              offer.icon,
              size: 110,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),

          // Content Layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.eyebrow,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.title,
                      style: GoogleFonts.outfit(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.90),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Code and Apply Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          offer.code,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _applyCoupon(context, offer.code),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            'APPLY',
                            style: GoogleFonts.outfit(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: offer.gradientColors.first,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
