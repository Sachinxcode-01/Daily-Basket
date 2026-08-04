import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Customer Profile / Settings Screen — Google Stitch Design System Exact Replica
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  final String _selectedLanguage = 'English';
  final String _selectedTheme = 'Light Mode';

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // ─── 1. Header (Menu + Daily Basket Logo + Cart) ───────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
                        ),
                        Text(
                          'Daily Basket',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pushNamed('/cart'),
                          icon: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF006B23), size: 24),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ─── 2. Profile Overview Header ───────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFC0E8C7), width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9999),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFFE8F5E9),
                                      child: const Icon(Icons.person, size: 40, color: Color(0xFF006B23)),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF006B23),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Alex Johnson',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+1 (555) 123-4567',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF6E7A6C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 3. SECTION 1: ACCOUNT SETTINGS ────────────────────────
                    _buildSectionHeader('ACCOUNT SETTINGS'),
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
                            icon: Icons.person_outline_rounded,
                            title: 'Personal Information',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.shield_outlined,
                            title: 'Security',
                            trailing: const Icon(Icons.shield_outlined, color: Color(0xFF1A1C1E), size: 20),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.location_on_outlined,
                            title: 'Saved Addresses',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.credit_card_rounded,
                            title: 'Payment Methods',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 4. SECTION 2: PREFERENCES ──────────────────────────────
                    _buildSectionHeader('PREFERENCES'),
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
                            icon: Icons.notifications_none_rounded,
                            title: 'Notification Settings',
                            trailing: Switch(
                              value: _notificationsEnabled,
                              activeTrackColor: const Color(0xFF006B23),
                              onChanged: (val) => setState(() => _notificationsEnabled = val),
                            ),
                            onTap: () => Navigator.of(context).pushNamed('/notification-preferences'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.language_rounded,
                            title: 'Language',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedLanguage,
                                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6E7A6C)),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                              ],
                            ),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.palette_outlined,
                            title: 'App Theme',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedTheme,
                                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6E7A6C)),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                              ],
                            ),
                            onTap: () => Navigator.of(context).pushNamed('/app-theme'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 5. SECTION 3: SUPPORT & LEGAL ──────────────────────────
                    _buildSectionHeader('SUPPORT & LEGAL'),
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
                            icon: Icons.help_outline_rounded,
                            title: 'Help Center',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/help'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.description_outlined,
                            title: 'Terms of Service',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/terms-of-service'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.shield_outlined,
                            title: 'Privacy Policy',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/privacy-policy'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ─── 6. Log Out Button ────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully.'),
                              backgroundColor: Color(0xFFBA1A1A),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDAD6),
                          foregroundColor: const Color(0xFFBA1A1A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.logout_rounded, color: Color(0xFFBA1A1A), size: 20),
                        label: Text(
                          'Log Out',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBA1A1A),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // App Version Text
                    Text(
                      'Version 1.2.0',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6E7A6C),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
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
                  _buildBottomNavItem(0, Icons.storefront_rounded, 'Shop'),
                  _buildBottomNavItem(1, Icons.search_rounded, 'Search'),
                  _buildBottomNavItem(2, Icons.person_rounded, 'Account', isSelected: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: const Color(0xFF006B23),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF006B23), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label, {bool isSelected = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
