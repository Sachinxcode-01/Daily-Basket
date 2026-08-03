import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Customer Homepage — Google Stitch Design System Exact Replica
/// Uses `assets/illustrations/fresharrivalbg.png` for the Fresh Arrivals card background.
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentBottomNavIndex = 0;
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
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // ─── 1. Header (Menu + Logo + Cart) ──────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Image.asset(
                                  'assets/images/daily_basket_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Basket',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF006B23),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF006B23), size: 26),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ─── 2. Delivery Address Bar ──────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F6),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xFF006B23), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '123 Main St, New York',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6E7A6C), size: 20),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ─── 3. Search Bar ────────────────────────────────────
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
                                  hintText: 'Search products...',
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

                      // ─── 4. Fresh Arrivals Card (Using fresharrivalbg.png) ─
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // Background Asset
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/illustrations/fresharrivalbg.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Content Overlay
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Fresh Arrivals',
                                      style: GoogleFonts.outfit(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(color: Colors.black38, blurRadius: 4),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 220),
                                      child: Text(
                                        'Get up to 20% off on organic vegetables this weekend.',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(alpha: 0.95),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF1A1C1E),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Text(
                                        'Shop Now',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ─── 5. Categories Section ─────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See All',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF006B23),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 2x2 Categories Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.1,
                        children: [
                          _buildCategoryCard('Fresh Fruits', '🍎', const Color(0xFFE8F5E9)),
                          _buildCategoryCard('Vegetables', '🥬', const Color(0xFFE8F5E9)),
                          _buildCategoryCard('Dairy & Eggs', '🥛', const Color(0xFFE8F5E9)),
                          _buildCategoryCard('Bakery', '🍞', const Color(0xFFFFF3E0)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ─── 6. Best Sellers Section ───────────────────────────
                      Text(
                        'Best Sellers',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildBestSellerCard('b1', 'Organic Bananas', '1 kg', '\$3.99', '🍌'),
                            const SizedBox(width: 14),
                            _buildBestSellerCard('b2', 'Free Range Eggs', '12 pack', '\$5.49', '🥚'),
                            const SizedBox(width: 14),
                            _buildBestSellerCard('b3', 'Fresh Farm Tomatoes', '500g', '\$2.49', '🍅'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ─── 7. Persistent Bottom Navigation Bar ────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEEEEF0), width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
                  _buildBottomNavItem(1, Icons.receipt_long_outlined, 'Orders'),
                  _buildBottomNavItem(2, Icons.shopping_cart_outlined, 'Cart', badgeCount: _totalCartCount),
                  _buildBottomNavItem(3, Icons.person_outline_rounded, 'Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, String emoji, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerCard(String id, String title, String unit, String price, String emoji) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 40)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1C1E),
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF6E7A6C),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF006B23),
                ),
              ),
              GestureDetector(
                onTap: () => _updateQuantity(id, 1),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006B23),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label, {int badgeCount = 0}) {
    final isActive = _currentBottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentBottomNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF006B23) : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : const Color(0xFF6E7A6C),
                  size: 22,
                ),
                if (badgeCount > 0 && !isActive)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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
