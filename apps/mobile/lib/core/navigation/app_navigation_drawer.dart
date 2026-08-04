import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

/// App Navigation Hub Modal Sheet / Drawer for Mobile
/// Displays categorized tiles for all 23+ screens in the Flutter Mobile App
class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppNavigationDrawer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.grid_view_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Screen Navigator Hub',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'Direct access to all mobile application screens',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Categorized Route Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCategorySection(
                  context,
                  title: 'MAIN STORE & SHOPPING',
                  items: [
                    _RouteItem('Home Screen', '/customer/home', Icons.home_rounded),
                    _RouteItem('Search Results', '/search', Icons.search_rounded),
                    _RouteItem('Browse Categories', '/categories', Icons.category_rounded),
                    _RouteItem('Fresh Produce Explorer', '/freshness', Icons.eco_rounded),
                    _RouteItem('Empty Cart State', '/cart/empty', Icons.shopping_basket_outlined),
                  ],
                ),

                _buildCategorySection(
                  context,
                  title: 'ORDERS & SERVICES',
                  items: [
                    _RouteItem('Live Delivery Tracking', '/tracking', Icons.near_me_rounded),
                    _RouteItem('Rate Your Delivery', '/rate-delivery', Icons.star_rounded),
                    _RouteItem('Notification Center', '/notifications', Icons.notifications_rounded),
                    _RouteItem('Wallet & Transactions', '/wallet', Icons.account_balance_wallet_rounded),
                    _RouteItem('Coupons & Promo Offers', '/coupons', Icons.local_offer_rounded),
                    _RouteItem('Refer & Earn Rewards', '/referral', Icons.card_giftcard_rounded),
                    _RouteItem('Daily Basket Plus VIP', '/loyalty', Icons.workspace_premium_rounded),
                    _RouteItem('Help Center & Support', '/help', Icons.help_outline_rounded),
                  ],
                ),

                _buildCategorySection(
                  context,
                  title: 'PROFILE & ACCOUNT SETTINGS',
                  items: [
                    _RouteItem('Customer Profile', '/profile', Icons.person_rounded),
                    _RouteItem('Personal Information', '/personal-info', Icons.badge_rounded),
                    _RouteItem('Saved Delivery Addresses', '/saved-addresses', Icons.location_on_rounded),
                    _RouteItem('Add New Address', '/add-address', Icons.add_location_alt_rounded),
                    _RouteItem('Security Settings', '/mfa-selection', Icons.shield_rounded),
                    _RouteItem('App Theme Settings', '/app-theme', Icons.palette_rounded),
                    _RouteItem('Privacy Policy', '/privacy-policy', Icons.privacy_tip_rounded),
                    _RouteItem('Terms of Service', '/terms-of-service', Icons.description_rounded),
                    _RouteItem('About Daily Basket', '/about', Icons.info_rounded),
                    _RouteItem('Delete Account', '/delete-account', Icons.delete_forever_rounded),
                  ],
                ),

                _buildCategorySection(
                  context,
                  title: 'AUTHENTICATION & SECURITY',
                  items: [
                    _RouteItem('Login Options', '/login', Icons.login_rounded),
                    _RouteItem('Create Account', '/register', Icons.person_add_rounded),
                    _RouteItem('Verify Email Code', '/verify-email', Icons.mark_email_unread_rounded),
                    _RouteItem('Email Verified Success', '/success', Icons.check_circle_rounded),
                    _RouteItem('Forgot Password', '/forgot-password', Icons.lock_reset_rounded),
                    _RouteItem('Reset Password', '/reset-password', Icons.password_rounded),
                    _RouteItem('MFA Option Selection', '/mfa-selection', Icons.security_rounded),
                    _RouteItem('MFA 6-Digit Verification', '/mfa-verify', Icons.pin_rounded),
                    _RouteItem('Enable Biometrics', '/enable-biometrics', Icons.fingerprint_rounded),
                    _RouteItem('Account Locked State', '/account-locked', Icons.lock_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context, {
    required String title,
    required List<_RouteItem> items,
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
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
        ),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.15),
                ),
              ),
              child: ListTile(
                leading: Icon(item.icon, color: AppColors.primary, size: 20),
                title: Text(
                  item.label,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, item.route);
                },
              ),
            )),
        const SizedBox(height: 12),
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
