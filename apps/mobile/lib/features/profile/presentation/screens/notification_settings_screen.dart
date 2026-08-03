import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notification Settings Screen — Google Stitch Design System Exact Replica
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Order Updates Switches
  bool _orderStatus = true;
  bool _deliveryTracking = true;
  bool _dailyReceipts = true;

  // Promotions & Offers Switches
  bool _flashDeals = false;
  bool _personalizedDiscounts = true;
  bool _newsletter = false;

  // Account Activity Switches
  bool _securityAlerts = true;
  bool _walletUpdates = true;

  int _bottomNavIndex = 3; // Account active

  @override
  Widget build(BuildContext context) {
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
          'Notifications',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A1C1E)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // ─── 1. Order Updates Card ───────────────────────────────
                  _buildCategoryCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Order Updates',
                    children: [
                      _buildSwitchTile(
                        title: 'Order Status',
                        subtitle: 'Get notified when your order is placed, packed, and ready.',
                        value: _orderStatus,
                        onChanged: (val) => setState(() => _orderStatus = val),
                      ),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      _buildSwitchTile(
                        title: 'Delivery Tracking',
                        subtitle: 'Real-time updates when your driver is approaching.',
                        value: _deliveryTracking,
                        onChanged: (val) => setState(() => _deliveryTracking = val),
                      ),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      _buildSwitchTile(
                        title: 'Daily Basket Receipts',
                        subtitle: 'Receive a digital receipt via email after delivery.',
                        value: _dailyReceipts,
                        onChanged: (val) => setState(() => _dailyReceipts = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── 2. Promotions & Offers Card ─────────────────────────
                  _buildCategoryCard(
                    icon: Icons.local_offer_outlined,
                    title: 'Promotions & Offers',
                    children: [
                      _buildSwitchTile(
                        title: 'Flash Deals',
                        subtitle: 'Alerts for limited-time discounts on groceries.',
                        value: _flashDeals,
                        onChanged: (val) => setState(() => _flashDeals = val),
                      ),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      _buildSwitchTile(
                        title: 'Personalized Discounts',
                        subtitle: 'Offers tailored to your frequent purchases.',
                        value: _personalizedDiscounts,
                        onChanged: (val) => setState(() => _personalizedDiscounts = val),
                      ),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      _buildSwitchTile(
                        title: 'Newsletter',
                        subtitle: 'Weekly updates on new products and seasonal picks.',
                        value: _newsletter,
                        onChanged: (val) => setState(() => _newsletter = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── 3. Account Activity Card ────────────────────────────
                  _buildCategoryCard(
                    icon: Icons.shield_outlined,
                    title: 'Account Activity',
                    children: [
                      _buildSwitchTile(
                        title: 'Security Alerts',
                        subtitle: 'Important notifications about login attempts and password changes.',
                        value: _securityAlerts,
                        onChanged: (val) => setState(() => _securityAlerts = val),
                      ),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      _buildSwitchTile(
                        title: 'Wallet Updates',
                        subtitle: 'Balance changes and payment method expirations.',
                        value: _walletUpdates,
                        onChanged: (val) => setState(() => _walletUpdates = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ─── 4. Persistent Bottom Navigation Bar ──────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEF0), width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(0, Icons.home_outlined, 'Home'),
                _buildBottomNavItem(1, Icons.search_rounded, 'Search'),
                _buildBottomNavItem(2, Icons.notifications_none_rounded, 'Notifications'),
                _buildBottomNavItem(3, Icons.person_rounded, 'Account'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF006B23), size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFEEEEF0), height: 1),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 16 / 12,
                  color: const Color(0xFF6E7A6C),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          activeTrackColor: const Color(0xFF006B23),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF006B23),
                  fontWeight: FontWeight.w700,
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
