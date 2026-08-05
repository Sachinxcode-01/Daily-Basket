import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'About App',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF006B23),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF006B23).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_basket_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Daily Basket',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF006B23),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '10-Minute Fresh Produce Delivery',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6E7A6C),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'v2.4.0 (Build 2026.08.05)',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF006B23),
                ),
              ),
            ),
            const SizedBox(height: 28),
            _buildSection(
              title: 'App Info',
              items: [
                _buildTile(
                  icon: Icons.new_releases_outlined,
                  title: 'Release Channel',
                  subtitle: 'Production / Stable',
                ),
                _buildTile(
                  icon: Icons.code_rounded,
                  title: 'Developer Information',
                  subtitle: 'Daily Basket Quick-Commerce Suite Ltd.',
                ),
                _buildTile(
                  icon: Icons.system_update_rounded,
                  title: 'Check for Updates',
                  subtitle: 'App is up to date',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You are on the latest version (v2.4.0)')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Legal & Licenses',
              items: [
                _buildTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => Navigator.of(context).pushNamed('/privacy-policy'),
                ),
                _buildTile(
                  icon: Icons.gavel_outlined,
                  title: 'Terms of Service',
                  onTap: () => Navigator.of(context).pushNamed('/terms-of-service'),
                ),
                _buildTile(
                  icon: Icons.description_outlined,
                  title: 'Open Source Licenses',
                  onTap: () => showLicensePage(context: context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Community & Support',
              items: [
                _buildTile(
                  icon: Icons.language_rounded,
                  title: 'Official Website',
                  subtitle: 'https://dailybasket.app',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening https://dailybasket.app...')),
                    );
                  },
                ),
                _buildTile(
                  icon: Icons.email_outlined,
                  title: 'Support Email',
                  subtitle: 'support@dailybasket.app',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email support@dailybasket.app')),
                    );
                  },
                ),
                _buildTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Bug',
                  onTap: () => Navigator.of(context).pushNamed('/help'),
                ),
                _buildTile(
                  icon: Icons.star_rate_rounded,
                  title: 'Rate App on Play Store',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for rating Daily Basket! ⭐⭐⭐⭐⭐')),
                    );
                  },
                ),
                _buildTile(
                  icon: Icons.share_rounded,
                  title: 'Share App with Friends',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App referral link copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              '© 2026 Daily Basket Technologies Inc. All rights reserved.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF006B23),
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A1C1E), size: 22),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1C1E),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6E7A6C),
              ),
            )
          : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C)) : null,
      onTap: onTap,
    );
  }
}
