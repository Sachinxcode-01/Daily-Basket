import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notification Preferences Screen — Exact Google Stitch Specification
/// Screen ID: 33fdfcdbd6fa48479d2f59eedccdeccb
class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  // Order Updates Toggles
  bool _orderStatus = true;
  bool _deliveryTracking = true;
  bool _dailyBasketReceipts = true;

  // Promotions & Offers Toggles
  bool _flashDeals = false;
  bool _personalizedDiscounts = true;
  bool _newsletter = false;

  // Account Activity Toggles
  final bool _securityAlerts = true; // Always ON for account security
  bool _walletUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1A1C1E),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF1A1C1E),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // 1. Order Updates Section
                _buildSectionCard(
                  icon: Icons.local_shipping_rounded,
                  title: 'Order Updates',
                  children: [
                    _buildToggleRow(
                      title: 'Order Status',
                      subtitle:
                          'Get notified when your order is placed, packed, and ready.',
                      value: _orderStatus,
                      onChanged: (val) => setState(() => _orderStatus = val),
                    ),
                    const Divider(color: Color(0xFFE2E2E5), height: 24),
                    _buildToggleRow(
                      title: 'Delivery Tracking',
                      subtitle:
                          'Real-time updates when your driver is approaching.',
                      value: _deliveryTracking,
                      onChanged: (val) =>
                          setState(() => _deliveryTracking = val),
                    ),
                    const Divider(color: Color(0xFFE2E2E5), height: 24),
                    _buildToggleRow(
                      title: 'Daily Basket Receipts',
                      subtitle:
                          'Receive a digital receipt via email after delivery.',
                      value: _dailyBasketReceipts,
                      onChanged: (val) =>
                          setState(() => _dailyBasketReceipts = val),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 2. Promotions & Offers Section
                _buildSectionCard(
                  icon: Icons.local_offer_rounded,
                  title: 'Promotions & Offers',
                  children: [
                    _buildToggleRow(
                      title: 'Flash Deals',
                      subtitle: 'Alerts for limited-time discounts on groceries.',
                      value: _flashDeals,
                      onChanged: (val) => setState(() => _flashDeals = val),
                    ),
                    const Divider(color: Color(0xFFE2E2E5), height: 24),
                    _buildToggleRow(
                      title: 'Personalized Discounts',
                      subtitle: 'Offers tailored to your frequent purchases.',
                      value: _personalizedDiscounts,
                      onChanged: (val) =>
                          setState(() => _personalizedDiscounts = val),
                    ),
                    const Divider(color: Color(0xFFE2E2E5), height: 24),
                    _buildToggleRow(
                      title: 'Newsletter',
                      subtitle:
                          'Weekly updates on new products and seasonal picks.',
                      value: _newsletter,
                      onChanged: (val) => setState(() => _newsletter = val),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 3. Account Activity Section
                _buildSectionCard(
                  icon: Icons.shield_outlined,
                  title: 'Account Activity',
                  children: [
                    _buildToggleRow(
                      title: 'Security Alerts',
                      subtitle:
                          'Important notifications about login attempts and password changes.',
                      value: _securityAlerts,
                      isDisabled: true,
                      onChanged: null,
                    ),
                    const Divider(color: Color(0xFFE2E2E5), height: 24),
                    _buildToggleRow(
                      title: 'Wallet Updates',
                      subtitle:
                          'Balance changes and payment method expirations.',
                      value: _walletUpdates,
                      onChanged: (val) => setState(() => _walletUpdates = val),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
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
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE2E2E5), height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isDisabled = false,
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
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDisabled
                      ? const Color(0xFF1A1C1E).withValues(alpha: 0.6)
                      : const Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF3F4A3D),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: isDisabled ? null : onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF006B23),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFE2E2E5),
        ),
      ],
    );
  }
}
