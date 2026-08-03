import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Security Settings Screen — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/security_settings_daily_basket/
///
/// Features:
///   - Account Security (Change Password, Two-Factor Authentication)
///   - Device Management (Active Devices)
///   - Privacy (Download Data, Delete Account)
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.90),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.security_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Security Settings',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.marginMobile),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
                Text(
                  'Settings',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your account security, devices, and privacy preferences.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),

                // ─── Account Security Section ─────────────────────────────
                _buildSectionHeader('Account Security'),
                _buildCardContainer([
                  _buildSettingsRow(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    subtitle: 'Update your account password regularly',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildSettingsRow(
                    icon: Icons.verified_user_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security',
                    badgeText: 'Enabled',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: AppTheme.spacingLg),

                // ─── Device Management Section ─────────────────────────────
                _buildSectionHeader('Device Management'),
                _buildCardContainer([
                  _buildSettingsRow(
                    icon: Icons.devices_rounded,
                    title: 'Active Devices',
                    subtitle: 'Manage devices logged into your account',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: AppTheme.spacingLg),

                // ─── Privacy Section ─────────────────────────────────────────
                _buildSectionHeader('Privacy'),
                _buildCardContainer([
                  _buildSettingsRow(
                    icon: Icons.download_rounded,
                    title: 'Download Data',
                    subtitle: 'Request a copy of your personal data',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildSettingsRow(
                    icon: Icons.delete_forever_rounded,
                    title: 'Delete Account',
                    subtitle: 'Permanently remove your account and data',
                    isDestructive: true,
                    onTap: () {},
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm, left: 4),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.level1,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badgeText,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? AppColors.error : AppColors.onSecondaryContainer;
    final titleColor = isDestructive ? AppColors.error : AppColors.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.errorContainer.withValues(alpha: 0.3)
                      : AppColors.secondaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right_rounded,
                color: isDestructive ? AppColors.error : AppColors.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
