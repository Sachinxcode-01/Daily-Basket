import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/user_provider.dart';

/// App Navigation Hub Modal Sheet & Drawer for Daily Basket Mobile
/// Displays categorized tiles for all screens in the Flutter Mobile App
/// Includes a live User Profile header, quick shortcut chips, and full route coverage.
class AppNavigationDrawer extends StatelessWidget {
  final bool isDrawer;

  const AppNavigationDrawer({
    super.key,
    this.isDrawer = false,
  });

  static void show(BuildContext context) {
    try {
      final scaffold = Scaffold.maybeOf(context);
      if (scaffold != null && scaffold.hasDrawer) {
        scaffold.openDrawer();
        return;
      }
    } catch (_) {}
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppNavigationDrawer(),
    );
  }

  static void openOrShow(BuildContext context) => show(context);
  static void open(BuildContext context) => show(context);

  @override
  Widget build(BuildContext context) {
    UserProvider? userProvider;
    try {
      userProvider = context.watch<UserProvider>();
    } catch (_) {}

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final drawerBg = isDark ? const Color(0xFF1E2124) : Colors.white;
    final headerBg = isDark ? const Color(0xFF191C1E) : const Color(0xFFF9F9FC);
    final brandColor = isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23);
    final borderColor = isDark
        ? const Color(0xFF2A2D31)
        : const Color(0xFFBECAB9).withValues(alpha: 0.25);
    final titleColor = isDark ? const Color(0xFFF0F0F3) : const Color(0xFF191C1E);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6E7A6C);
    final iconColor = isDark ? const Color(0xFFF0F0F3) : const Color(0xFF1A1C1E);
    final handleColor = isDark ? const Color(0xFF40483E) : const Color(0xFFBECAB9);

    final userName = userProvider?.name ?? 'Aarav Sharma';
    final userPhone = userProvider?.phone ?? '+91 98765 43210';
    final profileImageUrl = userProvider?.profileImageUrl ??
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80';

    final content = Container(
      height: isDrawer
          ? double.infinity
          : MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: drawerBg,
        borderRadius: isDrawer
            ? BorderRadius.zero
            : const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ─── 1. Drawer Header Handle (Modal Only) ───────────────────────
          if (!isDrawer) ...[
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],

          // ─── 2. User Profile Card Header ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: headerBg,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: brandColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: brandColor.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: Image.network(
                            profileImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person,
                              color: brandColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: brandColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: drawerBg, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        userPhone,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    side: BorderSide(color: brandColor),
                    shape: const StadiumBorder(),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Profile',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: brandColor,
                    ),
                  ),
                ),
                if (!isDrawer) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: iconColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          ),

          // ─── 3. Quick Action Shortcut Chips ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickChip(
                  context,
                  isDark: isDark,
                  label: 'Home',
                  icon: Icons.home_rounded,
                  route: '/customer/home',
                ),
                _buildQuickChip(
                  context,
                  isDark: isDark,
                  label: 'Categories',
                  icon: Icons.grid_view_rounded,
                  route: '/categories',
                ),
                _buildQuickChip(
                  context,
                  isDark: isDark,
                  label: 'Cart',
                  icon: Icons.shopping_basket_outlined,
                  route: '/cart',
                ),
                _buildQuickChip(
                  context,
                  isDark: isDark,
                  label: 'Orders',
                  icon: Icons.receipt_long_rounded,
                  route: '/orders',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ─── 4. Categorized Route Items List ─────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCategorySection(
                  context,
                  isDark: isDark,
                  title: 'MAIN STORE & SHOPPING',
                  items: [
                    _RouteItem(
                        'Home Screen', '/customer/home', Icons.home_rounded),
                    _RouteItem('Browse Categories', '/categories',
                        Icons.category_rounded),
                    _RouteItem('Fresh Produce Explorer', '/freshness',
                        Icons.eco_rounded),
                    _RouteItem(
                        'Search Groceries', '/search', Icons.search_rounded),
                    _RouteItem('Visual & Camera Search', '/camera-search',
                        Icons.camera_alt_rounded),
                    _RouteItem('Favorites & Wishlist', '/favorites',
                        Icons.favorite_rounded),
                    _RouteItem('Quick Buy Essentials', '/quick-buy',
                        Icons.flash_on_rounded),
                    _RouteItem('Back in Stock Alerts', '/back-to-stock',
                        Icons.notification_important_rounded),
                    _RouteItem('Store Closed / Resting State', '/store-closed',
                        Icons.storefront_rounded),
                  ],
                ),
                _buildCategorySection(
                  context,
                  isDark: isDark,
                  title: 'CART & CHECKOUT',
                  items: [
                    _RouteItem('Your Shopping Cart', '/cart',
                        Icons.shopping_basket_rounded),
                    _RouteItem('Empty Cart State', '/cart/empty',
                        Icons.shopping_basket_outlined),
                    _RouteItem('Checkout & Schedule', '/checkout',
                        Icons.shopping_cart_checkout_rounded),
                    _RouteItem(
                        'Payment Methods', '/payment', Icons.payment_rounded),
                  ],
                ),
                _buildCategorySection(
                  context,
                  isDark: isDark,
                  title: 'ORDERS & TRACKING',
                  items: [
                    _RouteItem(
                        'Order History', '/orders', Icons.receipt_long_rounded),
                    _RouteItem('Live Delivery Tracking', '/tracking',
                        Icons.near_me_rounded),
                    _RouteItem('Rate Your Delivery', '/rate-delivery',
                        Icons.star_rounded),
                  ],
                ),
                _buildCategorySection(
                  context,
                  title: 'REWARDS & SAVINGS',
                  isDark: isDark,
                  items: [
                    _RouteItem('Refer & Earn Rewards', '/referral',
                        Icons.card_giftcard_rounded),
                    _RouteItem('Referral Details & History',
                        '/referral-history', Icons.history_rounded),
                    _RouteItem('Coupons & Promo Offers', '/coupons',
                        Icons.local_offer_rounded),
                    _RouteItem('Daily Basket Plus VIP', '/loyalty',
                        Icons.workspace_premium_rounded),
                    _RouteItem('Wallet & Transactions', '/wallet',
                        Icons.account_balance_wallet_rounded),
                    _RouteItem('My Environmental Impact', '/my-impact',
                        Icons.forest_rounded),
                  ],
                ),
                _buildCategorySection(
                  context,
                  isDark: isDark,
                  title: 'PROFILE & ACCOUNT SETTINGS',
                  items: [
                    _RouteItem(
                        'Customer Profile', '/profile', Icons.person_rounded),
                    _RouteItem('Personal Information', '/personal-info',
                        Icons.badge_rounded),
                    _RouteItem('Saved Delivery Addresses', '/saved-addresses',
                        Icons.location_on_rounded),
                    _RouteItem('Select Location & Address', '/select-location',
                        Icons.location_pin),
                    _RouteItem('Add New Address', '/add-address',
                        Icons.add_location_alt_rounded),
                    _RouteItem('Manage Payment Methods', '/payment-methods',
                        Icons.credit_card_rounded),
                    _RouteItem('Security & Privacy', '/security',
                        Icons.shield_rounded),
                    _RouteItem('Notification Center', '/notifications',
                        Icons.notifications_rounded),
                    _RouteItem('Notification Preferences',
                        '/notification-preferences', Icons.tune_rounded),
                    _RouteItem('App Theme Settings', '/app-theme',
                        Icons.palette_rounded),
                    _RouteItem(
                        'App Permissions Center',
                        '/permissions-settings',
                        Icons.settings_applications_rounded),
                  ],
                ),
                _buildCategorySection(
                  context,
                  isDark: isDark,
                  title: 'HELP & LEGAL',
                  items: [
                    _RouteItem('Help Center & FAQs', '/help',
                        Icons.help_outline_rounded),
                    _RouteItem('24/7 Live Support Chat', '/live-chat',
                        Icons.chat_rounded),
                    _RouteItem(
                        'About Daily Basket', '/about', Icons.info_rounded),
                    _RouteItem('Privacy Policy', '/privacy-policy',
                        Icons.privacy_tip_rounded),
                    _RouteItem('Terms of Service', '/terms-of-service',
                        Icons.description_rounded),
                    _RouteItem('Delete Account', '/delete-account',
                        Icons.delete_forever_rounded),
                  ],
                ),
                _buildCategorySection(
                  context,
                  isDark: isDark,
                  title: 'ACCOUNT & SECURITY',
                  items: [
                    _RouteItem('Sign In / Switch Account', '/login', Icons.login_rounded),
                    _RouteItem('Create New Account', '/register', Icons.person_add_rounded),
                    _RouteItem('Reset Password', '/forgot-password', Icons.lock_reset_rounded),
                    _RouteItem('Security Settings', '/security', Icons.security_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isDrawer) {
      return Drawer(
        backgroundColor: drawerBg,
        child: SafeArea(child: content),
      );
    }

    return content;
  }

  Widget _buildQuickChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF292C2F) : const Color(0xFFF3F5F3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? const Color(0xFF40483E) : const Color(0xFFC0E8C7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23)),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required List<_RouteItem> items,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFBECAB9) : AppColors.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
        ),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF232629) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF34373B) : AppColors.outlineVariant.withValues(alpha: 0.15),
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF191C1E) : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(item.icon, color: isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23), size: 18),
                ),
                title: Text(
                  item.label,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF0F0F3) : AppColors.onSurface,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark ? const Color(0xFF8A9387) : Colors.grey,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, item.route);
                },
              ),
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _RouteItem {
  final String label;
  final String route;
  final IconData icon;

  _RouteItem(this.label, this.route, this.icon);
}
