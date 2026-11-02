import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';

/// Reusable Global Bottom Navigation Bar for Daily Basket
/// Matches Google Stitch design tokens: 6-item navigation shell
/// (Home, Categories, Search, Cart, Orders, Profile)
/// Supports dynamic adaptation for Light and Dark theme modes.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    this.currentIndex = -1,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/customer/home',
          (route) => false,
        );
        break;
      case 1:
        Navigator.of(context).pushNamed('/categories');
        break;
      case 2:
        Navigator.of(context).pushNamed('/search');
        break;
      case 3:
        Navigator.of(context).pushNamed('/cart');
        break;
      case 4:
        Navigator.of(context).pushNamed('/orders');
        break;
      case 5:
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark
        ? const Color(0xFF191C1E).withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.92);
    final borderColor = isDark
        ? const Color(0xFF2A2D31)
        : const Color(0xFFBECAB9).withValues(alpha: 0.25);
    final activeColor = isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23);
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6E7A6C);

    int cartCount = 0;
    LanguageProvider? languageProvider;
    try {
      final cartProvider = context.watch<CartProvider>();
      cartCount = cartProvider.itemCount;
    } catch (_) {}
    try {
      languageProvider = context.watch<LanguageProvider>();
    } catch (_) {}

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: navBg,
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.home_rounded,
                label: languageProvider?.translate('shop', 'Home') ?? 'Home',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.grid_view_rounded,
                label: languageProvider?.translate('categories', 'Categories') ?? 'Categories',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.search_rounded,
                label: languageProvider?.translate('search', 'Search') ?? 'Search',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.shopping_basket_outlined,
                label: languageProvider?.translate('cart', 'Cart') ?? 'Cart',
                badgeCount: cartCount,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context,
                index: 4,
                icon: Icons.receipt_long_rounded,
                label: languageProvider?.translate('orders', 'Orders') ?? 'Orders',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildNavItem(
                context,
                index: 5,
                icon: Icons.person_outline_rounded,
                label: languageProvider?.translate('account', 'Profile') ?? 'Profile',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    int badgeCount = 0,
  }) {
    final isSelected = index == currentIndex;

    return InkWell(
      onTap: () => _onItemTapped(context, index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
