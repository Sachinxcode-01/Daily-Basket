import 'package:flutter/material.dart';

/// Stitch Screen: Admin Settings & Security
/// ID: 991df21338de4f7187a9a7f259acd1c7
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _mfaEnabled = true;
  bool _biometricEnabled = true;
  bool _pushNotifications = true;
  bool _orderAlerts = true;
  bool _stockAlerts = true;
  bool _maintenanceMode = false;
  bool _darkMode = true;
  bool _autoAssignRiders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Settings & Security', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Admin profile card
          _buildProfileCard(),

          // Security section
          _sectionHeader('🔒 Security & Authentication'),
          _buildToggleTile(
            icon: Icons.security_rounded,
            iconColor: const Color(0xFF3B82F6),
            title: 'Multi-Factor Authentication (MFA)',
            subtitle: 'Required for all admin logins',
            value: _mfaEnabled,
            onChanged: (v) => setState(() => _mfaEnabled = v),
          ),
          _buildToggleTile(
            icon: Icons.fingerprint_rounded,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Biometric Login',
            subtitle: 'Fingerprint / Face ID unlock',
            value: _biometricEnabled,
            onChanged: (v) => setState(() => _biometricEnabled = v),
          ),
          _buildNavTile(
            icon: Icons.password_rounded,
            iconColor: const Color(0xFF0F766E),
            title: 'Change Admin Password',
            subtitle: 'Last changed 30 days ago',
            onTap: () => Navigator.pushNamed(context, '/admin/reset-password'),
          ),
          _buildNavTile(
            icon: Icons.devices_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Trusted Devices',
            subtitle: '2 devices registered',
            onTap: () {},
          ),
          _buildNavTile(
            icon: Icons.history_rounded,
            iconColor: const Color(0xFF64748B),
            title: 'Login Activity Log',
            subtitle: 'View recent sign-in history',
            onTap: () => _showLoginLog(context),
          ),

          // Notifications section
          _sectionHeader('🔔 Notifications'),
          _buildToggleTile(
            icon: Icons.notifications_active_rounded,
            iconColor: const Color(0xFF10B981),
            title: 'Push Notifications',
            subtitle: 'App-wide push alerts',
            value: _pushNotifications,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          _buildToggleTile(
            icon: Icons.shopping_bag_outlined,
            iconColor: const Color(0xFF3B82F6),
            title: 'Order Alerts',
            subtitle: 'New orders & status changes',
            value: _orderAlerts,
            onChanged: (v) => setState(() => _orderAlerts = v),
          ),
          _buildToggleTile(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFFEF4444),
            title: 'Stock & Expiry Alerts',
            subtitle: 'Low stock & near-expiry reminders',
            value: _stockAlerts,
            onChanged: (v) => setState(() => _stockAlerts = v),
          ),

          // Operations section
          _sectionHeader('⚙️ Operations'),
          _buildToggleTile(
            icon: Icons.two_wheeler_rounded,
            iconColor: const Color(0xFF14B8A6),
            title: 'Auto-Assign Riders',
            subtitle: 'Nearest rider auto-dispatch',
            value: _autoAssignRiders,
            onChanged: (v) => setState(() => _autoAssignRiders = v),
          ),
          _buildToggleTile(
            icon: Icons.build_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: 'Maintenance Mode',
            subtitle: 'Pauses all customer-facing orders',
            value: _maintenanceMode,
            onChanged: (v) => setState(() => _maintenanceMode = v),
          ),
          _buildNavTile(
            icon: Icons.local_offer_rounded,
            iconColor: const Color(0xFF8B5CF6),
            title: 'GST & Tax Configuration',
            subtitle: 'GSTIN: 29XXXXXXXXXXXXZ',
            onTap: () {},
          ),
          _buildNavTile(
            icon: Icons.attach_money_rounded,
            iconColor: const Color(0xFF10B981),
            title: 'Payment Gateway Settings',
            subtitle: 'Razorpay • Stripe • UPI',
            onTap: () {},
          ),
          _buildNavTile(
            icon: Icons.map_rounded,
            iconColor: const Color(0xFF3B82F6),
            title: 'Delivery Zone Configuration',
            subtitle: '3 active zones • Bengaluru',
            onTap: () {},
          ),

          // App section
          _sectionHeader('📱 App & Display'),
          _buildToggleTile(
            icon: Icons.dark_mode_rounded,
            iconColor: const Color(0xFF64748B),
            title: 'Dark Mode',
            subtitle: 'Admin app display theme',
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          _buildNavTile(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF0F766E),
            title: 'Language & Region',
            subtitle: 'English (India) • ₹ INR',
            onTap: () {},
          ),

          // Team section
          _sectionHeader('👥 Team & Access'),
          _buildNavTile(
            icon: Icons.admin_panel_settings_rounded,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Admin User Management',
            subtitle: '4 admin users • 2 managers',
            onTap: () {},
          ),
          _buildNavTile(
            icon: Icons.shield_rounded,
            iconColor: const Color(0xFF0F766E),
            title: 'Role & Permission Matrix',
            subtitle: 'Super Admin • Admin • Manager',
            onTap: () {},
          ),

          // About
          _sectionHeader('ℹ️ About'),
          _buildNavTile(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF64748B),
            title: 'App Version',
            subtitle: 'Daily Basket Admin v2.0.0 (Build 512)',
            onTap: () {},
          ),
          _buildNavTile(
            icon: Icons.description_rounded,
            iconColor: const Color(0xFF64748B),
            title: 'Terms & Privacy Policy',
            subtitle: 'Legal documentation',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // Danger zone
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 16),
                        SizedBox(width: 8),
                        Text('DANGER ZONE', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                    title: const Text('Logout Admin Session', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                    subtitle: const Text('End current session on this device', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F2034)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF14B8A6)]),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ananya Rao', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Text('Senior Director • Super Admin', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: const Text('Active Session', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text('admin@dailybasket.com', style: TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Color(0xFF2DD4BF), size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.6)),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2DD4BF),
          inactiveTrackColor: const Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B)),
        onTap: onTap,
      ),
    );
  }

  void _showLoginLog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Login Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _logEntry('Today 09:14 AM', 'Samsung Galaxy S24 Ultra', 'Bengaluru, KA', true),
            _logEntry('Yesterday 06:22 PM', 'MacBook Pro M3', 'Bengaluru, KA', true),
            _logEntry('3 days ago 11:48 AM', 'iPad Pro 12.9"', 'Bengaluru, KA', false),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _logEntry(String time, String device, String location, bool isCurrent) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.devices_rounded, color: isCurrent ? const Color(0xFF2DD4BF) : const Color(0xFF64748B)),
      title: Text(device, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text('$time • $location', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
      trailing: isCurrent ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
        child: const Text('Current', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout Admin Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to end your current session?', style: TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/admin/welcome');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
