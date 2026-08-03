import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Customer Homepage — Google Stitch Design System
/// Ref: stitch_daily_basket_quick_commerce_suite/home_screen/ & website/app/page.tsx
///
/// Palette: Primary Grocery Green (#006B23), Surface (#F9F9FC), Container (#EEEEF0)
/// Typography: Outfit (headlines/titles), Inter (body/labels)
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final Map<String, int> _cartItems = {};

  void _updateQuantity(String id, int delta) {
    setState(() {
      final current = _cartItems[id] ?? 0;
      final updated = current + delta;
      if (updated <= 0) {
        _cartItems.remove(id);
      } else {
        _cartItems[id] = updated;
      }
    });
  }

  int get _totalCartCount => _cartItems.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // ─── Top Header with Delivery Badge & Location ─────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.marginMobile),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 10 MINS Pill Badge (Stitch Signature)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(9999),
                                boxShadow: AppTheme.level1,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.bolt_rounded, color: AppColors.onPrimary, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '10 MINS',
                                    style: GoogleFonts.inter(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // User Profile Avatar
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                              ),
                              child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        // Delivery location line
                        Row(
                          children: [
                            Text(
                              'Delivery to ',
                              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 13),
                            ),
                            const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              'Koramangala 4th Block',
                              style: GoogleFonts.outfit(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.onSurfaceVariant, size: 18),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        // Stitch Search Bar with voice icon
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                            boxShadow: AppTheme.level1,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Search "tomatoes", "milk", "bread"...',
                                    hintStyle: GoogleFonts.inter(
                                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: false,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const Icon(Icons.mic_none_rounded, color: AppColors.primary, size: 22),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Stitch Hero Promo Banner ──────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.marginMobile),
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF078730), Color(0xFF00531A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.level2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'FLASH SALE 40% OFF',
                            style: GoogleFonts.inter(
                              color: AppColors.onPrimaryFixed,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          'Farm Fresh Vegetables',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Delivered to your kitchen in 10 minutes.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Flash Deals Section Title ─────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppTheme.marginMobile, AppTheme.spacingLg, AppTheme.marginMobile, AppTheme.spacingSm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '⚡ 10-Min Flash Deals',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── Flash Deals Product Grid ──────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.marginMobile),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildProductCard('p1', 'Organic Farm Tomatoes', '500g', '₹24', '₹40', Icons.local_grocery_store_rounded),
                      _buildProductCard('p2', 'Amul Fresh Toned Milk', '1 Litre', '₹54', '₹56', Icons.local_drink_rounded),
                      _buildProductCard('p3', 'Brown Sandwich Bread', '400g', '₹45', '₹50', Icons.bakery_dining_rounded),
                      _buildProductCard('p4', 'Alphonso Mangoes', '1 kg', '₹299', '₹450', Icons.eco_rounded),
                    ]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),

            // ─── Floating Cart Summary Bar ─────────────────────────────────
            if (_totalCartCount > 0)
              Positioned(
                bottom: 20,
                left: AppTheme.marginMobile,
                right: AppTheme.marginMobile,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.level3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primaryFixed,
                            child: Text(
                              '$_totalCartCount',
                              style: GoogleFonts.inter(
                                color: AppColors.onPrimaryFixed,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Items Added',
                                style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
                              ),
                              Text(
                                'Instant 10-Min Delivery',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          elevation: 0,
                        ),
                        child: Text(
                          'View Cart',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String id, String title, String unit, String price, String mrp, IconData icon) {
    final qty = _cartItems[id] ?? 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: AppTheme.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, size: 48, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(unit, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(color: AppColors.onSurface, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.outfit(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mrp,
                    style: GoogleFonts.inter(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              if (qty == 0)
                InkWell(
                  onTap: () => _updateQuantity(id, 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.15),
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'ADD',
                      style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _updateQuantity(id, -1),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.remove, size: 14, color: Colors.white),
                        ),
                      ),
                      Text('$qty', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      GestureDetector(
                        onTap: () => _updateQuantity(id, 1),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.add, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
