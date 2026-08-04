import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../categories/presentation/screens/browse_categories_screen.dart';
import '../../../search/presentation/screens/search_results_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/order_history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

/// Customer Homepage — Google Stitch Design System Exact Replica
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

  void _navigateToProductDetails(String id, String title, String price, String emoji) {
    Navigator.pushNamed(
      context,
      '/product-details',
      arguments: {
        'productId': id,
        'productName': title,
        'price': price,
        'mrp': '₹${(int.tryParse(price.replaceAll('₹', '')) ?? 100) + 30}',
        'unitDetails': '1 Unit / Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _currentBottomNavIndex,
          children: [
            // Index 0: Home Feed Body
            _buildHomeFeed(),
            // Index 1: Categories Screen
            const BrowseCategoriesScreen(),
            // Index 2: Search Screen
            const SearchResultsScreen(),
            // Index 3: Cart Screen
            const CartScreen(),
            // Index 4: Orders Screen
            const OrderHistoryScreen(),
            // Index 5: Profile Screen
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
            _buildBottomNavItem(1, Icons.grid_view_rounded, 'Categories'),
            _buildBottomNavItem(2, Icons.search_rounded, 'Search'),
            _buildBottomNavItem(3, Icons.shopping_basket_outlined, 'Cart', badgeCount: _totalCartCount),
            _buildBottomNavItem(4, Icons.receipt_long_rounded, 'Orders'),
            _buildBottomNavItem(5, Icons.person_outline_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeFeed() {
    return Column(
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
                        onPressed: () => Scaffold.of(context).openDrawer(),
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
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.shopping_bag_rounded,
                                size: 18,
                                color: Color(0xFF006B23),
                              ),
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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, '/cart'),
                            icon: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF006B23), size: 26),
                          ),
                          if (_totalCartCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF006B23),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(
                                  '$_totalCartCount',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ─── 2. Delivery Address Bar ──────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/saved-addresses'),
                    child: Container(
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
                  ),

                  const SizedBox(height: 12),

                  // ─── 3. Search Bar ────────────────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: Color(0xFF6E7A6C), size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Search products...',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF6E7A6C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── 4. Fresh Arrivals Card ───────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006B23),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Fresh Arrivals 🥦',
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 220),
                                child: Text(
                                  'Get up to 20% off on organic vegetables this weekend.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.95),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/categories'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF006B23),
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
                        onPressed: () => setState(() => _currentBottomNavIndex = 1),
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildCategoryChip('Fruits', '🍌'),
                        _buildCategoryChip('Vegetables', '🥦'),
                        _buildCategoryChip('Dairy', '🥛'),
                        _buildCategoryChip('Bakery', '🥐'),
                        _buildCategoryChip('Meat & Fish', '🥩'),
                        _buildCategoryChip('Beverages', '🥤'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── 6. Best Sellers Section ───────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Best Sellers',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/search'),
                        child: Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildBestSellerCard('bs1', 'Organic Hass Avocados', '2 units (approx. 400g)', '₹120', '🥑'),
                        const SizedBox(width: 14),
                        _buildBestSellerCard('bs2', 'Fresh Farm Milk 1L', '1 Liter Bottle', '₹65', '🥛'),
                        const SizedBox(width: 14),
                        _buildBestSellerCard('bs3', 'Artisanal Sourdough', '400g Loaf', '₹90', '🍞'),
                        const SizedBox(width: 14),
                        _buildBestSellerCard('bs4', 'Vine-Ripened Tomatoes', '500g Pack', '₹45', '🍅'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String title, String emoji) {
    return GestureDetector(
      onTap: () => setState(() => _currentBottomNavIndex = 1),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1C1E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellerCard(String id, String title, String unit, String price, String emoji) {
    return GestureDetector(
      onTap: () => _navigateToProductDetails(id, title, price, emoji),
      child: Container(
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
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 40)),
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
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label, {int badgeCount = 0}) {
    final isActive = _currentBottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentBottomNavIndex = index),
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
