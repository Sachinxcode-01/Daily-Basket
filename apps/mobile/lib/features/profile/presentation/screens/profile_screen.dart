import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/app_theme_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/notification_provider.dart';
import '../widgets/profile_photo_picker_sheet.dart';

/// Customer Profile / Settings Screen — Google Stitch Design System Exact Replica
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLanguagePickerModal(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    final availableLangs = languageProvider.availableLanguages;
    final currentLang = languageProvider.selectedLanguage;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              languageProvider.translate('select_language'),
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: availableLangs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final lang = availableLangs[index];
                  final isSelected = lang['name'] == currentLang;

                  return InkWell(
                    onTap: () {
                      languageProvider.setLanguage(lang['name']!);
                      Navigator.pop(ctx);
                      final updatedToast = languageProvider.translate('language_changed_toast');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$updatedToast ${lang['name']} (${lang['native']})'),
                          backgroundColor: const Color(0xFF006B23),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF9F9FC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF006B23) : const Color(0xFFBECAB9).withValues(alpha: 0.3),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${lang['name']} (${lang['native']})',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF006B23) : const Color(0xFF1A1C1E),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF006B23), size: 22),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider? userProvider;
    AppThemeProvider? appThemeProvider;
    LanguageProvider? languageProvider;
    NotificationProvider? notificationProvider;

    try { userProvider = context.watch<UserProvider>(); } catch (_) {}
    try { appThemeProvider = context.watch<AppThemeProvider>(); } catch (_) {}
    try { languageProvider = context.watch<LanguageProvider>(); } catch (_) {}
    try { notificationProvider = context.watch<NotificationProvider>(); } catch (_) {}

    final name = userProvider?.name ?? 'Alex Morgan';
    final phone = userProvider?.phone ?? '+91 98765 43210';
    final profileImageUrl = userProvider?.profileImageUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80';
    final selectedThemeLabel = appThemeProvider?.selectedThemeLabel ?? 'Light Mode';
    final selectedLanguage = languageProvider?.selectedLanguage ?? 'English';
    final notificationsEnabled = notificationProvider?.notificationsEnabled ?? true;

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
                          onPressed: () => AppNavigationDrawer.show(context),
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
                          GestureDetector(
                            onTap: () => ProfilePhotoPickerSheet.show(context),
                            child: Stack(
                              children: [
                                Container(
                                  width: 88,
                                  height: 88,
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
                                      profileImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: const Color(0xFFE8F5E9),
                                        child: const Icon(Icons.person, size: 44, color: Color(0xFF006B23)),
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
                                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            phone,
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
                    _buildSectionHeader(languageProvider?.translate('account_settings', 'ACCOUNT SETTINGS') ?? 'ACCOUNT SETTINGS'),
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
                            title: languageProvider?.translate('personal_info', 'Personal Information') ?? 'Personal Information',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                            onTap: () => Navigator.of(context).pushNamed('/personal-info'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.shield_outlined,
                            title: languageProvider?.translate('security', 'Security') ?? 'Security',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                            onTap: () => Navigator.of(context).pushNamed('/security'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.location_on_outlined,
                            title: languageProvider?.translate('saved_addresses', 'Saved Addresses') ?? 'Saved Addresses',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                            onTap: () => Navigator.of(context).pushNamed('/saved-addresses'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.credit_card_rounded,
                            title: languageProvider?.translate('payment_methods', 'Payment Methods') ?? 'Payment Methods',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                            onTap: () => Navigator.of(context).pushNamed('/payment-methods'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 4. SECTION 2: PREFERENCES ──────────────────────────────
                    _buildSectionHeader(languageProvider?.translate('preferences', 'PREFERENCES') ?? 'PREFERENCES'),
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
                            title: languageProvider?.translate('notification_settings', 'Notification Settings') ?? 'Notification Settings',
                            trailing: GestureDetector(
                              onTap: () {}, // Stop tap propagation to tile onTap
                              child: Switch(
                                value: notificationsEnabled,
                                activeTrackColor: const Color(0xFF006B23),
                                onChanged: (val) {
                                  notificationProvider?.setNotificationsEnabled(val);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(val ? 'Push Notifications Enabled' : 'Push Notifications Disabled'),
                                      backgroundColor: val ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                            onTap: () => Navigator.of(context).pushNamed('/notification-preferences'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.language_rounded,
                            title: languageProvider?.translate('language', 'Language') ?? 'Language',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedLanguage,
                                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6E7A6C)),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)),
                              ],
                            ),
                            onTap: () => _showLanguagePickerModal(context),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.palette_outlined,
                            title: languageProvider?.translate('app_theme', 'App Theme') ?? 'App Theme',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedThemeLabel,
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
                    _buildSectionHeader(languageProvider?.translate('support_legal', 'SUPPORT & LEGAL') ?? 'SUPPORT & LEGAL'),
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
                            icon: Icons.chat_bubble_outline_rounded,
                            title: languageProvider?.translate('live_chat', 'Live Agent Chat') ?? 'Live Agent Chat',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/live-chat'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.eco_outlined,
                            title: 'My Sustainability Impact',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/my-impact'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.help_outline_rounded,
                            title: languageProvider?.translate('help_center', 'Help Center') ?? 'Help Center',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/help'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.description_outlined,
                            title: languageProvider?.translate('terms_of_service', 'Terms of Service') ?? 'Terms of Service',
                            trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1C1E), size: 20),
                            onTap: () => Navigator.of(context).pushNamed('/terms-of-service'),
                          ),
                          const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 60, endIndent: 16),
                          _buildSettingTile(
                            icon: Icons.shield_outlined,
                            title: languageProvider?.translate('privacy_policy', 'Privacy Policy') ?? 'Privacy Policy',
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
                          languageProvider?.translate('logout', 'Log Out') ?? 'Log Out',
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
                  _buildBottomNavItem(context, 0, Icons.storefront_rounded, languageProvider?.translate('shop', 'Shop') ?? 'Shop', route: '/customer/home'),
                  _buildBottomNavItem(context, 1, Icons.search_rounded, languageProvider?.translate('search', 'Search') ?? 'Search', route: '/search'),
                  _buildBottomNavItem(context, 2, Icons.person_rounded, languageProvider?.translate('account', 'Account') ?? 'Account', isSelected: true, route: '/profile'),
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

  Widget _buildBottomNavItem(BuildContext context, int index, IconData icon, String label, {bool isSelected = false, String? route}) {
    return InkWell(
      onTap: () {
        if (!isSelected && route != null) {
          Navigator.of(context).pushReplacementNamed(route);
        }
      },
      borderRadius: BorderRadius.circular(9999),
      child: AnimatedContainer(
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
      ),
    );
  }
}
