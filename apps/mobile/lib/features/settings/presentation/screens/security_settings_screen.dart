import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';

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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
                onPressed: () => AppNavigationDrawer.show(context),
              ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined, color: Color(0xFF006B23), size: 22),
            const SizedBox(width: 8),
            Text(
              'Security & Privacy',
              style: GoogleFonts.outfit(
                fontSize: 20,
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
                  'AS',
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
              'Security Settings',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account security, 2FA, devices, and privacy preferences.',
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
                      Navigator.of(context).pushNamed('/reset-password');
                    },
                  ),
                  const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                  _buildSettingTile(
                    icon: Icons.shield_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security via SMS/Authenticator',
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
                  const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                  _buildSettingTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Authentication',
                    subtitle: 'Unlock app with Fingerprint / Face ID',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                    onTap: () => Navigator.of(context).pushNamed('/enable-biometrics'),
                  ),
                  const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                  _buildSettingTile(
                    icon: Icons.security_rounded,
                    title: 'App Permissions Center',
                    subtitle: 'Manage location, camera, mic, & notifications',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                    onTap: () => Navigator.of(context).pushNamed('/permissions-settings'),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Text('Active Session', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
                          content: Text(
                            'Current Device: Daily Basket Mobile (Android / iOS)\nLocation: Bengaluru, India\nIP Address: 106.51.78.12\nStatus: Active Now',
                            style: GoogleFonts.inter(fontSize: 13, height: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text('OK', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: const Color(0xFF006B23))),
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
            _buildSectionHeader('Privacy & Data'),
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
                    title: 'Download My Data',
                    subtitle: 'Request a copy of your order & profile data',
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data export request initiated. Check email shortly.'),
                          backgroundColor: Color(0xFF006B23),
                          behavior: SnackBarBehavior.floating,
                        ),
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
                    onTap: () => Navigator.of(context).pushNamed('/delete-account'),
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
