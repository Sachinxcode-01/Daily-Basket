import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int _selectedFilterIndex = 0;
  int _bottomNavIndex = 2; // Offers tab active
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = ['All Offers', 'Grocery', 'Bakery', 'Dairy'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = context.watch<CouponProvider>();
    final selectedCategory = _filters[_selectedFilterIndex];

    final filteredCoupons = couponProvider.availableCoupons.where((coupon) {
      final matchesCategory = selectedCategory == 'All Offers' || coupon.category == selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          coupon.code.toLowerCase().contains(_searchQuery) ||
          coupon.title.toLowerCase().contains(_searchQuery) ||
          coupon.subtitle.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ─── 1. Header (Menu + Title + Cart Badge) ─────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
                        ),
                        Text(
                          'Coupons & Offers',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pushNamed('/cart'),
                              icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF006B23), size: 24),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(
                                  '4',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ─── 2. Search Bar ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: Color(0xFF6E7A6C), size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1C1E)),
                              decoration: InputDecoration(
                                hintText: 'Search brand, category, or coupon...',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF6E7A6C),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () => _searchController.clear(),
                              child: const Icon(Icons.close_rounded, color: Color(0xFF6E7A6C), size: 20),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Active Applied Coupon Alert Banner
                    if (couponProvider.appliedCoupon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF006B23)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF006B23), size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Active Coupon: ${couponProvider.appliedCoupon!.code}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  Text(
                                    couponProvider.appliedCoupon!.subtitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF006B23),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                couponProvider.removeCoupon();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coupon Removed'),
                                    backgroundColor: Color(0xFF006B23),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Text(
                                'REMOVE',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFD32F2F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ─── 3. Category Filter Chips ───────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(_filters.length, (index) {
                          final isSelected = _selectedFilterIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FilterChip(
                              label: Text(_filters[index]),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilterIndex = index;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: const Color(0xFFE8F5E9),
                              checkmarkColor: const Color(0xFF006B23),
                              labelStyle: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFF006B23) : const Color(0xFF1A1C1E),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF006B23) : const Color(0xFFBECAB9).withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─── 4. Coupon Cards List ─────────────────────────────
                    if (filteredCoupons.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Icon(Icons.local_offer_outlined, size: 48, color: Color(0xFFBECAB9)),
                            const SizedBox(height: 12),
                            Text(
                              'No coupons found',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try searching for another offer or category',
                              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6E7A6C)),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCoupons.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final coupon = filteredCoupons[index];
                          final isApplied = couponProvider.appliedCoupon?.code == coupon.code;

                          return GestureDetector(
                            onTap: () => showCouponDetailsBottomSheet(
                              context,
                              code: coupon.code,
                              title: coupon.title,
                              discountTag: '${coupon.discountDisplay} ${coupon.discountSub}',
                            ),
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isApplied ? const Color(0xFF006B23) : const Color(0xFFBECAB9).withValues(alpha: 0.3),
                                  width: isApplied ? 1.5 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
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
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                coupon.code,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF1A1C1E),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (isApplied) {
                                                    couponProvider.removeCoupon();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Coupon Removed'),
                                                        backgroundColor: Color(0xFF006B23),
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  } else {
                                                    final res = couponProvider.applyCoupon(coupon, 500);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(res.message),
                                                        backgroundColor: res.success ? const Color(0xFF006B23) : const Color(0xFFD32F2F),
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  isApplied ? 'REMOVE' : 'APPLY',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: isApplied ? const Color(0xFFD32F2F) : const Color(0xFF006B23),
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
                                              color: const Color(0xFF1A1C1E),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            coupon.subtitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: const Color(0xFF6E7A6C),
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
                        },
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── 7. Persistent Bottom Navigation Bar ────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEF0), width: 1)),
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
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF006B23) : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF6E7A6C),
              size: 20,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
