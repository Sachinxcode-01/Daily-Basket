import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Terms of Service Screen — Exact Google Stitch Specification
/// Screen ID: 58ae7db20dd24db38bd4fdc62453ae37
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
            color: Color(0xFF006B23),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Basket',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // Title & Subtitle
                Text(
                  'Terms of Service',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF006B23),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last Updated: October 26, 2023',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF3F4A3D),
                  ),
                ),
                const SizedBox(height: 24),

                // Card Container
                Container(
                  padding: const EdgeInsets.all(24),
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
                      Text(
                        'Welcome to Daily Basket. Please read these Terms of Service carefully before using our application. By accessing or using our service, you agree to be bound by these terms.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.6,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildTermsSection(
                        icon: Icons.description_outlined,
                        title: '1. Acceptance of Terms',
                        body:
                            'By downloading, accessing, or using the Daily Basket app, you acknowledge that you have read, understood, and agree to be legally bound by these Terms of Service. If you do not agree to any of these terms, you must not use the service.',
                      ),
                      const SizedBox(height: 24),

                      _buildTermsSection(
                        icon: Icons.shopping_basket_outlined,
                        title: '2. Use of Service',
                        body:
                            'Daily Basket provides a quick-commerce grocery delivery service. You agree to use the service only for lawful purposes and in accordance with these Terms. You are prohibited from using the service in any way that could damage, disable, overburden, or impair the app\'s functionality.',
                      ),
                      const SizedBox(height: 24),

                      _buildTermsSection(
                        icon: Icons.account_circle_outlined,
                        title: '3. User Accounts',
                        body:
                            'To use certain features, you must register for an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must notify us immediately of any unauthorized use of your account.',
                      ),
                      const SizedBox(height: 24),

                      _buildTermsSection(
                        icon: Icons.credit_card_outlined,
                        title: '4. Payments & Refunds',
                        body:
                            'All prices are listed in the app and are subject to change. Payment must be made at the time of order placement. Refunds may be issued at our discretion in accordance with our Return Policy. We reserve the right to refuse or cancel any order.',
                      ),
                      const SizedBox(height: 24),

                      _buildTermsSection(
                        icon: Icons.copyright_outlined,
                        title: '5. Intellectual Property',
                        body:
                            'The Daily Basket app, including its original content, features, and functionality, is owned by Daily Basket Inc. and is protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
                      ),
                      const SizedBox(height: 24),

                      _buildTermsSection(
                        icon: Icons.gavel_outlined,
                        title: '6. Limitation of Liability',
                        body:
                            'In no event shall Daily Basket, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
                      ),
                      const SizedBox(height: 28),

                      const Divider(color: Color(0xFFE2E2E5), height: 1),
                      const SizedBox(height: 20),

                      Center(
                        child: Text(
                          'If you have any questions about these Terms, please contact us at support@dailybasket.app',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF3F4A3D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF58605A), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF006B23),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.6,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}
