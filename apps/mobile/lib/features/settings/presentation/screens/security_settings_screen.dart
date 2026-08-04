import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Security Settings Screen — Google Stitch Design System Exact Replica
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined, color: Color(0xFF006B23), size: 22),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1A1C1E), size: 24),
            onPressed: () => Navigator.of(context).pushNamed('/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'SA',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00531A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Screen Header Title & Subtitle
            Text(
              'Settings',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account security, devices, and privacy preferences.',
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 20 / 14,
                color: const Color(0xFF6E7A6C),
              ),
            ),

            const SizedBox(height: 24),

            // ─── 1. Account Security Section ─────────────────────────────────
            _buildSectionHeader('Account Security'),
            const SizedBox(height: 8),

            Container(
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
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.password_rounded,
                    title: 'Change Password',
                    subtitle: 'Update your account password regularly',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigating to Change Password...'),
                          backgroundColor: Color(0xFF006B23),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                  _buildSettingTile(
                    icon: Icons.shield_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0E8C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Enabled',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00531A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/mfa-selection'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── 2. Device Management Section ────────────────────────────────
            _buildSectionHeader('Device Management'),
            const SizedBox(height: 8),

            Container(
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
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.devices_rounded,
                    title: 'Active Devices',
                    subtitle: 'Manage devices logged into your account',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Active Session'),
                          content: const Text('Current Device: Flutter Mobile (Android/iOS)\nIP: 192.168.1.10\nStatus: Active Now'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── 3. Privacy Section ──────────────────────────────────────────
            _buildSectionHeader('Privacy'),
            const SizedBox(height: 8),

            Container(
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
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.download_rounded,
                    title: 'Download Data',
                    subtitle: 'Request a copy of your personal data',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Personal data download request submitted.')),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                  _buildSettingTile(
                    icon: Icons.delete_forever_outlined,
                    iconBg: const Color(0xFFFFDAD6),
                    iconColor: const Color(0xFFBA1A1A),
                    title: 'Delete Account',
                    titleColor: const Color(0xFFBA1A1A),
                    subtitle: 'Permanently remove your account and data',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFBA1A1A)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Account'),
                          content: const Text('Are you sure you want to request permanent account deletion?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF006B23),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    Color iconBg = const Color(0xFFF3F3F6),
    Color iconColor = const Color(0xFF1A1C1E),
    required String title,
    Color titleColor = const Color(0xFF1A1C1E),
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF6E7A6C),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
