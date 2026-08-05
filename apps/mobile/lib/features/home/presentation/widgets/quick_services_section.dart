import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/favorites_provider.dart';
import '../../../../core/providers/ai_chat_provider.dart';
import '../../../wallet/providers/wallet_provider.dart';
import '../../../referral/providers/coupon_provider.dart';

/// Premium Quick Services Section — Daily Basket Home Screen
///
/// 10 horizontally-scrollable service cards with:
/// - Gradient backgrounds (unique per card)
/// - Animated badges with live data
/// - Staggered entrance animations using flutter_staggered_animations
/// - Press / bounce haptic feedback
/// - Hero transitions where supported
/// - Real-time data from providers
class QuickServicesSection extends StatefulWidget {
  const QuickServicesSection({super.key});

  @override
  State<QuickServicesSection> createState() => _QuickServicesSectionState();
}

class _QuickServicesSectionState extends State<QuickServicesSection>
    with TickerProviderStateMixin {
  // Per-card press animation controllers
  late List<AnimationController> _pressControllers;
  late List<Animation<double>> _pressAnimations;

  // Stagger entrance controller
  late AnimationController _entranceController;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;
  bool _hasAnimated = false;

  // AI typing animation
  late AnimationController _typingController;

  // Wallet balance shimmer
  late AnimationController _shimmerController;

  static const int _cardCount = 10;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnims = List.generate(_cardCount, (i) {
      final start = i * 0.07;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(_cardCount, (i) {
      final start = i * 0.07;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0.3, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });

    // Press controllers
    _pressControllers = List.generate(
      _cardCount,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        reverseDuration: const Duration(milliseconds: 200),
      ),
    );
    _pressAnimations = _pressControllers
        .map((c) => Tween<double>(begin: 1.0, end: 0.93).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();

    // AI typing dots
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Wallet shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Fire entrance after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasAnimated && mounted) {
        _hasAnimated = true;
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _typingController.dispose();
    _shimmerController.dispose();
    for (final c in _pressControllers) { c.dispose(); }
    super.dispose();
  }

  void _handleTap(int index, VoidCallback action) {
    HapticFeedback.lightImpact();
    _pressControllers[index].forward().then((_) {
      _pressControllers[index].reverse();
      action();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Services',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              Text(
                'All Features',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF006B23),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal scroll of cards
        SizedBox(
          height: 152,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
            itemCount: _cardCount,
            itemBuilder: (context, i) {
              return FadeTransition(
                opacity: _fadeAnims[i],
                child: SlideTransition(
                  position: _slideAnims[i],
                  child: ScaleTransition(
                    scale: _pressAnimations[i],
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildCard(context, i),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    final cards = _cardConfigs(context);
    final cfg = cards[index];

    return GestureDetector(
      onTapDown: (_) => _pressControllers[index].forward(),
      onTapUp: (_) {
        _pressControllers[index].reverse();
        _handleTap(index, cfg.onTap);
      },
      onTapCancel: () => _pressControllers[index].reverse(),
      child: Container(
        width: 126,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: cfg.gradient,
            begin: cfg.gradientBegin,
            end: cfg.gradientEnd,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: cfg.gradient.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background decoration circles
            Positioned(
              right: -12,
              bottom: -12,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: -8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon row + badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1),
                        ),
                        child: Center(
                          child: cfg.iconWidget ??
                              Icon(cfg.icon!, size: 22, color: Colors.white),
                        ),
                      ),
                      if (cfg.badge != null) cfg.badge!,
                    ],
                  ),
                  const Spacer(),

                  // Title
                  Text(
                    cfg.title,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Subtitle / data line
                  Text(
                    cfg.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Card Configs ──────────────────────────────────────────────────────────

  List<_ServiceCard> _cardConfigs(BuildContext context) {
    FavoritesProvider? favProv;
    WalletProvider? walletProv;
    CouponProvider? couponProv;
    AiChatProvider? aiProv;

    try { favProv = context.watch<FavoritesProvider>(); } catch (_) {}
    try { walletProv = context.watch<WalletProvider>(); } catch (_) {}
    try { couponProv = context.watch<CouponProvider>(); } catch (_) {}
    try { aiProv = context.watch<AiChatProvider>(); } catch (_) {}

    final favCount = favProv?.favoriteIds.length ?? 0;
    final walletBalance = walletProv?.balance ?? 0.0;
    final couponCount = couponProv?.availableCoupons.length ?? 0;

    return [
      // ── 1. Offers ──────────────────────────────────────────────────────────
      _ServiceCard(
        title: 'Offers',
        subtitle: "Today's Best Deals",
        gradient: const [Color(0xFFFF5F6D), Color(0xFFCC1F3F)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        icon: Icons.local_fire_department_rounded,
        badge: _pulseBadge('12 Active'),
        onTap: () => Navigator.pushNamed(context, '/coupons'),
      ),

      // ── 2. Coupons ─────────────────────────────────────────────────────────
      _ServiceCard(
        title: 'Coupons',
        subtitle: couponCount > 0 ? '$couponCount Available' : 'Save More Today',
        gradient: const [Color(0xFFF7971E), Color(0xFFD4600A)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        icon: Icons.confirmation_number_rounded,
        badge: couponCount > 0
            ? _countBadge('$couponCount', const Color(0xFFFFECB3))
            : null,
        onTap: () => Navigator.pushNamed(context, '/coupons'),
      ),

      // ── 3. Fresh Produce ───────────────────────────────────────────────────
      _ServiceCard(
        title: 'Farm Fresh',
        subtitle: 'Fresh From Farm',
        gradient: const [Color(0xFF11998E), Color(0xFF006B23)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: const Text('🥬', style: TextStyle(fontSize: 22)),
        badge: _tagBadge('Seasonal'),
        onTap: () => Navigator.pushNamed(context, '/freshness'),
      ),

      // ── 4. Wallet ──────────────────────────────────────────────────────────
      _ServiceCard(
        title: 'Wallet',
        subtitle: '₹${walletBalance.toStringAsFixed(0)} Balance',
        gradient: const [Color(0xFF667EEA), Color(0xFF3B2CC0)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: _animatedWalletIcon(),
        badge: _cashbackBadge('+₹20 CB'),
        onTap: () => Navigator.pushNamed(context, '/wallet'),
      ),

      // ── 5. Daily Basket Plus ───────────────────────────────────────────────
      _ServiceCard(
        title: 'DB Plus',
        subtitle: 'VIP Membership',
        gradient: const [Color(0xFFF9A825), Color(0xFFC67B00)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: const Text('⭐', style: TextStyle(fontSize: 22)),
        badge: _tagBadge('GOLD', color: const Color(0xFFFFF9C4)),
        onTap: () => Navigator.pushNamed(context, '/loyalty'),
      ),

      // ── 6. Favorites ───────────────────────────────────────────────────────
      _ServiceCard(
        title: 'Favorites',
        subtitle: favCount > 0 ? '$favCount Saved' : 'Wishlist',
        gradient: const [Color(0xFFE040FB), Color(0xFF9C1DE7)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: _heartIcon(),
        badge: favCount > 0 ? _countBadge('$favCount', Colors.white) : null,
        onTap: () => Navigator.pushNamed(context, '/catalog/favorites'),
      ),

      // ── 7. Order Again ─────────────────────────────────────────────────────
      _ServiceCard(
        title: 'Reorder',
        subtitle: 'Buy Again Fast',
        gradient: const [Color(0xFF0F9B8E), Color(0xFF007369)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        icon: Icons.replay_rounded,
        badge: _tagBadge('Quick'),
        onTap: () => Navigator.pushNamed(context, '/orders'),
      ),

      // ── 8. AI Shopping Assistant ───────────────────────────────────────────
      _ServiceCard(
        title: 'AI Assistant',
        subtitle: 'Ask Anything',
        gradient: const [Color(0xFF1A73E8), Color(0xFF0A3B8C)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: _aiIcon(aiProv),
        badge: _onlineBadge(),
        onTap: () => Navigator.pushNamed(context, '/live-chat'),
      ),

      // ── 9. Recipe To Cart ──────────────────────────────────────────────────
      _ServiceCard(
        title: 'Recipe Cart',
        subtitle: 'Cook Today',
        gradient: const [Color(0xFF56CCF2), Color(0xFF227BCB)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: const Text('🥗', style: TextStyle(fontSize: 22)),
        badge: _tagBadge('New'),
        onTap: () => Navigator.pushNamed(context, '/live-chat'),
      ),

      // ── 10. Refer & Earn ───────────────────────────────────────────────────
      _ServiceCard(
        title: 'Refer & Earn',
        subtitle: 'Earn ₹100 / Invite',
        gradient: const [Color(0xFFFF6F61), Color(0xFFDE1A35)],
        gradientBegin: Alignment.topLeft,
        gradientEnd: Alignment.bottomRight,
        iconWidget: const Text('🎁', style: TextStyle(fontSize: 22)),
        badge: _tagBadge('₹100', color: const Color(0xFFFFE0E0)),
        onTap: () => Navigator.pushNamed(context, '/referral'),
      ),
    ];
  }

  // ─── Badge Builders ────────────────────────────────────────────────────────

  static Widget _pulseBadge(String text) {
    return _StaticBadge(text: text, color: Colors.white.withValues(alpha: 0.25));
  }

  static Widget _countBadge(String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Text(
        count,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget _tagBadge(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget _cashbackBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF4ADE80).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4ADE80).withValues(alpha: 0.6)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _onlineBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _typingController,
          builder: (context, child) {
            return Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: Color.lerp(
                  const Color(0xFF4ADE80),
                  const Color(0xFF22C55E),
                  (math.sin(_typingController.value * math.pi * 2) + 1) / 2,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ADE80).withValues(alpha: 0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        Text(
          'Online',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _animatedWalletIcon() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final shimmerX = _shimmerController.value * 2 - 0.5;
            return LinearGradient(
              colors: const [
                Color(0xFFFFD700),
                Colors.white,
                Color(0xFFFFD700),
              ],
              stops: [
                (shimmerX - 0.3).clamp(0.0, 1.0),
                shimmerX.clamp(0.0, 1.0),
                (shimmerX + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: const Icon(Icons.account_balance_wallet_rounded,
              size: 22, color: Colors.white),
        );
      },
    );
  }

  Widget _heartIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.15),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      builder: (context, val, child) {
        return Transform.scale(
          scale: val,
          child: const Icon(Icons.favorite_rounded, size: 22, color: Colors.white),
        );
      },
      onEnd: () => setState(() {}), // re-trigger
    );
  }

  Widget _aiIcon(AiChatProvider? aiProv) {
    return AnimatedBuilder(
      animation: _typingController,
      builder: (context, child) {
        final dotPhase = (_typingController.value * math.pi * 2);
        return Stack(
          children: [
            const Icon(Icons.smart_toy_rounded, size: 22, color: Colors.white),
            // Typing dots overlay at bottom-right
            Positioned(
              right: 0,
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final dot = (math.sin(dotPhase + i * 1.0) + 1) / 2;
                  return Container(
                    width: 3,
                    height: 3,
                    margin: const EdgeInsets.only(right: 1),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: dot),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Static Badge Widget ──────────────────────────────────────────────────────

class _StaticBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StaticBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─── Card Config Model ─────────────────────────────────────────────────────────

class _ServiceCard {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? badge;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.gradientBegin,
    required this.gradientEnd,
    this.icon,
    this.iconWidget,
    this.badge,
    required this.onTap,
  });
}
