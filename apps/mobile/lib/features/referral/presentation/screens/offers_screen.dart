import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../providers/coupon_provider.dart';
import 'coupon_details_sheet.dart';

/// Coupons & Offers Screen — Google Stitch Design System Exact Replica
class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0; // 0: All, 1: Grocery, 2: Fruits, 3: Dairy, 4: Snacks
  int _bottomNavIndex = 2; // Offers active

  final List<String> _categories = [
    'All Offers',
    'Grocery',
    'Fruits & Veggies',
    'Dairy & Eggs',
    'Snacks & Drinks',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = context.watch<CouponProvider>();
    final allCoupons = couponProvider.availableCoupons;

    final query = _searchController.text.trim().toLowerCase();
    final filteredCoupons = allCoupons.where((coupon) {
      final matchesQuery = query.isEmpty ||
          coupon.code.toLowerCase().contains(query) ||
          coupon.title.toLowerCase().contains(query) ||
          coupon.subtitle.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_selectedCategoryIndex == 1) {
        return coupon.code.contains('ORGANIC') || coupon.code.contains('DAILY');
      } else if (_selectedCategoryIndex == 2) {
        return coupon.code.contains('ORGANIC') || coupon.code.contains('FRESH');
      } else if (_selectedCategoryIndex == 3) {
        return coupon.code.contains('MILK') || coupon.code.contains('DAILY');
      } else if (_selectedCategoryIndex == 4) {
        return coupon.code.contains('SNACK') || coupon.code.contains('MEGA');
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Coupons & Offers',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ─── 1. Search Bar ─────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search promo code or offer...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF6E7A6C),
                        ),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF006B23)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: Color(0xFF6E7A6C)),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── 2. Category Chips Bar ─────────────────────────────────
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedCategoryIndex == index;
                        return ChoiceChip(
                          label: Text(_categories[index]),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) {
                              setState(() => _selectedCategoryIndex = index);
                            }
                          },
                          selectedColor: const Color(0xFF006B23),
                          backgroundColor: Colors.white,
                          labelStyle: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6E7A6C),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF006B23)
                                  : const Color(0xFFBECAB9)
                                      .withValues(alpha: 0.3),
                            ),
                          ),
                          elevation: 0,
                          pressElevation: 0,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── 3. Section Title ──────────────────────────────────────
                  Text(
                    'Available Offers (${filteredCoupons.length})',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ─── 4. Staggered Coupon Cards List ───────────────────────
                  if (filteredCoupons.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Icon(Icons.local_offer_outlined,
                              size: 48, color: Color(0xFFBECAB9)),
                          const SizedBox(height: 12),
                          Text(
                            'No coupons found',
                            style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1C1E)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try searching for another offer or category',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: const Color(0xFF6E7A6C)),
                          ),
                        ],
                      ),
                    )
                  else
                    AnimationLimiter(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCoupons.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final coupon = filteredCoupons[index];
                          final isApplied =
                              couponProvider.appliedCoupon?.code ==
                                  coupon.code;

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 40.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () => showCouponDetailsBottomSheet(
                                    context,
                                    code: coupon.code,
                                    title: coupon.title,
                                    discountTag:
                                        '${coupon.discountDisplay} ${coupon.discountSub}',
                                  ),
                                  child: Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isApplied
                                            ? const Color(0xFF006B23)
                                            : const Color(0xFFBECAB9)
                                                .withValues(alpha: 0.3),
                                        width: isApplied ? 1.5 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.03),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Left Discount Stub Side
                                        Container(
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: coupon.discountBg,
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    left: Radius.circular(20)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                coupon.discountDisplay,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w800,
                                                  color: coupon.discountColor,
                                                ),
                                              ),
                                              Text(
                                                coupon.discountSub,
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 0.5,
                                                  color: coupon.discountColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Right Content Side
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      coupon.code,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFF1A1C1E),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (isApplied) {
                                                          couponProvider
                                                              .removeCoupon();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Coupon Removed'),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF006B23),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                            ),
                                                          );
                                                        } else {
                                                          final res =
                                                              couponProvider
                                                                  .applyCoupon(
                                                                      coupon,
                                                                      500);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  res.message),
                                                              backgroundColor: res
                                                                      .success
                                                                  ? const Color(
                                                                      0xFF006B23)
                                                                  : const Color(
                                                                      0xFFD32F2F),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        isApplied
                                                            ? 'REMOVE'
                                                            : 'APPLY',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: isApplied
                                                              ? const Color(
                                                                  0xFFD32F2F)
                                                              : const Color(
                                                                  0xFF006B23),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  coupon.title,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xFF1A1C1E),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  coupon.subtitle,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11,
                                                    color:
                                                        const Color(0xFF6E7A6C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ─── 5. Persistent Bottom Navigation Bar ──────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Color(0xFFEEEEF0), width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
                _buildBottomNavItem(1, Icons.grid_view_rounded, 'Categories'),
                _buildBottomNavItem(2, Icons.local_offer_rounded, 'Offers'),
                _buildBottomNavItem(3, Icons.receipt_long_outlined, 'Orders'),
                _buildBottomNavItem(4, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFF006B23)
                  : const Color(0xFF6E7A6C),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF006B23),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
