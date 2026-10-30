import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/widgets/app_network_image.dart';

class FlashDealItem {
  final String id;
  final String name;
  final String brand;
  final String unit;
  final String price;
  final String mrp;
  final String discountPercentage;
  final String imageUrl;
  final double claimedPercent; // 0.0 to 1.0

  const FlashDealItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.unit,
    required this.price,
    required this.mrp,
    required this.discountPercentage,
    required this.imageUrl,
    required this.claimedPercent,
  });
}

class FlashDealsBanner extends StatefulWidget {
  final VoidCallback? onViewAll;

  const FlashDealsBanner({
    super.key,
    this.onViewAll,
  });

  @override
  State<FlashDealsBanner> createState() => _FlashDealsBannerState();
}

class _FlashDealsBannerState extends State<FlashDealsBanner> {
  late Duration _remainingTime;
  Timer? _countdownTimer;

  static const List<FlashDealItem> _flashDeals = [
    FlashDealItem(
      id: 'fd_ban1',
      name: 'Fresh Robusta Bananas (Kela)',
      brand: 'Farm Fresh',
      unit: '500 g (3-4 pcs)',
      price: r'₹24',
      mrp: r'₹45',
      discountPercentage: '47% OFF',
      imageUrl: 'assets/products/fresh-vegetables/2483b1e4-6b95-4777-82ba-9ea62a37f40d.png',
      claimedPercent: 0.88,
    ),
    FlashDealItem(
      id: 'fd_veg1',
      name: 'Fresh Hybrid Tomatoes (Tamatar)',
      brand: 'Farm Fresh',
      unit: '500 g',
      price: r'₹18',
      mrp: r'₹30',
      discountPercentage: '40% OFF',
      imageUrl: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
      claimedPercent: 0.94,
    ),
    FlashDealItem(
      id: 'fd_brd1',
      name: 'Harvest Gold 100% Whole Wheat Bread',
      brand: 'Harvest Gold',
      unit: '400 g Pack',
      price: r'₹36',
      mrp: r'₹50',
      discountPercentage: '28% OFF',
      imageUrl: 'assets/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
      claimedPercent: 0.72,
    ),
    FlashDealItem(
      id: 'fd_crd1',
      name: 'Amul Masti Dahi Set Curd',
      brand: 'Amul',
      unit: '400 g Cup',
      price: r'₹28',
      mrp: r'₹40',
      discountPercentage: '30% OFF',
      imageUrl: 'assets/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
      claimedPercent: 0.81,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Default 2 hours, 45 minutes, 10 seconds
    _remainingTime = const Duration(hours: 2, minutes: 45, seconds: 10);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          // Reset to 3 hours when elapsed
          _remainingTime = const Duration(hours: 3);
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try {
      cartProvider = context.watch<CartProvider>();
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header Strip ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 98,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF078730), Color(0xFF2D9D43)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D9D43).withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            size: 16,
                            color: Color(0xFFEAB308),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Flash Deals',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Ends in ',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _formatDuration(_remainingTime),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8CFA93),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (widget.onViewAll != null) {
                      widget.onViewAll!();
                    } else {
                      Navigator.pushNamed(context, '/categories');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2D9D43),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'View All',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ─── Horizontal Product Cards ──────────────────────────────────────
        SizedBox(
          height: 252,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _flashDeals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final deal = _flashDeals[index];
              return _buildDealCard(deal, cartProvider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDealCard(FlashDealItem deal, CartProvider? cartProvider) {
    int qty = 0;
    if (cartProvider != null) {
      qty = cartProvider.getQuantity(deal.id);
    }

    final priceDouble = double.tryParse(deal.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 20.0;

    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFBECAB9).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Discount Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 96,
                  width: double.infinity,
                  color: const Color(0xFFF9F9FC),
                  padding: const EdgeInsets.all(6),
                  child: AppNetworkImage(
                    imageUrl: deal.imageUrl,
                    fit: BoxFit.contain,
                    fallbackIcon: Icons.eco_rounded,
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA1A1A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    deal.discountPercentage,
                    style: GoogleFonts.inter(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Details & Price
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.name,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF191C1E),
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  deal.unit,
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    color: const Color(0xFF6E7A6C),
                  ),
                ),
                const SizedBox(height: 5),

                // Claimed Progress Meter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: LinearProgressIndicator(
                        value: deal.claimedPercent,
                        minHeight: 4,
                        backgroundColor: const Color(0xFFECEEF0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFEAB308),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '🔥 ${(deal.claimedPercent * 100).toInt()}% claimed',
                      style: GoogleFonts.inter(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Price and Add CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.price,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D9D43),
                          ),
                        ),
                        Text(
                          deal.mrp,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            color: const Color(0xFF6E7A6C),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    qty == 0
                        ? SizedBox(
                            width: 28,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                cartProvider?.updateQuantityById(
                                  id: deal.id,
                                  name: deal.name,
                                  subtitle: deal.unit,
                                  price: priceDouble,
                                  image: deal.imageUrl,
                                  delta: 1,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D9D43),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(Icons.add, size: 16),
                            ),
                          )
                        : Container(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D9D43),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    cartProvider?.updateQuantityById(
                                      id: deal.id,
                                      name: deal.name,
                                      subtitle: deal.unit,
                                      price: priceDouble,
                                      image: deal.imageUrl,
                                      delta: -1,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '$qty',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    cartProvider?.updateQuantityById(
                                      id: deal.id,
                                      name: deal.name,
                                      subtitle: deal.unit,
                                      price: priceDouble,
                                      image: deal.imageUrl,
                                      delta: 1,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
