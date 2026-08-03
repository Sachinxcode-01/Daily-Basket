import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final List<String> _filters = ['All Offers', 'Grocery', 'Bakery', 'Dairy'];

  final List<Map<String, dynamic>> _coupons = [
    {
      'id': 'c1',
      'discount': '15%',
      'discountSub': 'OFF',
      'discountBg': const Color(0xFFE8F5E9),
      'discountColor': const Color(0xFF006B23),
      'title': 'Organic Staples Promo',
      'subtitle': 'Valid on all organic pulses and grains above \$50.',
      'expiry': 'EXPIRES IN 3 DAYS',
      'code': 'ORGANIC15',
      'icon': Icons.verified_user_outlined,
      'category': 'Grocery',
      'applied': false,
    },
    {
      'id': 'c2',
      'discount': '\$10',
      'discountSub': 'CASHBACK',
      'discountBg': const Color(0xFFF3F3F6),
      'discountColor': const Color(0xFF1A1C1E),
      'title': 'Dairy Delights',
      'subtitle': 'Get flat \$10 back on milk and cheese orders over \$30.',
      'expiry': 'VALID TILL 30 SEP',
      'code': 'DAIRY10',
      'icon': Icons.star_outline_rounded,
      'category': 'Dairy',
      'applied': false,
    },
    {
      'id': 'c3',
      'discount': 'Free',
      'discountSub': 'DELIVERY',
      'discountBg': const Color(0xFFFFEBEE),
      'discountColor': const Color(0xFFD32F2F),
      'title': 'Weekend Special',
      'subtitle': 'Free delivery on all orders above \$20 this weekend.',
      'expiry': 'VALID THIS WEEKEND',
      'code': 'SHIPFREE',
      'icon': Icons.local_shipping_outlined,
      'category': 'Grocery',
      'applied': false,
    },
  ];

  void _applyCoupon(int index) {
    setState(() {
      _coupons[index]['applied'] = !(_coupons[index]['applied'] as bool);
    });
    final code = _coupons[index]['code'] as String;
    final isApplied = _coupons[index]['applied'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isApplied ? 'Coupon $code Applied!' : 'Coupon $code Removed'),
        backgroundColor: const Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                    // ─── 1. Header (Menu + Daily Basket Logo + Cart Badge) ─────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
                        ),
                        Text(
                          'Daily Basket',
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
                              onPressed: () {},
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
                                  '2',
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─── 3. Best Offers Section ─────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Best Offers',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Horizontal Banner Carousel
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // Banner 1: Fresh Produce Flat 40% OFF
                          Container(
                            width: 280,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF006B23), Color(0xFF00531A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF006B23).withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FRESH PRODUCE',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Flat 40% OFF',
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'On your first 3 orders',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.90),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Text(
                                        'FRESH40',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF006B23),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 14),

                          // Banner 2: Gourmet Buy 1 Get 1
                          Container(
                            width: 240,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3F4A3D),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'GOURMET',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Buy 1 Get 1',
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Artisanal Cheese & Bread',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─── 4. Refer & Earn Card ───────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8CFA93), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC0E8C7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.volunteer_activism_rounded, color: Color(0xFF006B23), size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Refer & Earn ',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00531A),
                                      ),
                                    ),
                                    Text(
                                      '\$20',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Invite friends and get rewards on their first purchase.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    color: const Color(0xFF3F4A3D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Referral link copied to clipboard!'),
                                  backgroundColor: Color(0xFF006B23),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006B23),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Invite Now',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 5. Available Coupons Header & Filter Chips ─────────
                    Text(
                      'Available Coupons',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFilterIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF006B23) : const Color(0xFFEEEEF0),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                _filters[index],
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF6E7A6C),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // ─── 6. Action-Oriented Coupon Cards ────────────────────
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _coupons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final coupon = _coupons[index];
                        final isApplied = coupon['applied'] as bool;
                        return GestureDetector(
                          onTap: () => showCouponDetailsBottomSheet(context),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
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
                                    color: coupon['discountBg'] as Color,
                                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        coupon['discount'] as String,
                                        style: GoogleFonts.outfit(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: coupon['discountColor'] as Color,
                                        ),
                                      ),
                                      Text(
                                        coupon['discountSub'] as String,
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                          color: coupon['discountColor'] as Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right Coupon Info Side
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  coupon['title'] as String,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF1A1C1E),
                                                  ),
                                                ),
                                                Icon(
                                                  coupon['icon'] as IconData,
                                                  size: 16,
                                                  color: const Color(0xFF006B23),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              coupon['subtitle'] as String,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                height: 15 / 12,
                                                color: const Color(0xFF6E7A6C),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  coupon['expiry'] as String,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                    color: const Color(0xFF6E7A6C),
                                                  ),
                                                ),
                                                Text(
                                                  'CODE: ${coupon['code']}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(0xFF1A1C1E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              onPressed: () => _applyCoupon(index),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isApplied
                                                    ? const Color(0xFF006B23)
                                                    : const Color(0xFFF3F3F6),
                                                foregroundColor: isApplied
                                                    ? Colors.white
                                                    : const Color(0xFF006B23),
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                isApplied ? 'Applied' : 'Apply',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
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
