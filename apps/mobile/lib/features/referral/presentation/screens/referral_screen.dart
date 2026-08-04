import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/coupon_provider.dart';

/// Refer & Earn Screen — Google Stitch Design System Exact Replica
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final String _referralCode = 'DAILY20-USER';
  bool _isCopied = false;
  int _bottomNavIndex = 2; // Rewards active

  bool _faq1Expanded = false;
  bool _faq2Expanded = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    setState(() => _isCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code DAILY20-USER copied to clipboard!'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = context.watch<CouponProvider>();
    final referralCode = couponProvider.referralCode;

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

                    // ─── 1. Header (Menu + Refer & Earn Title + Profile Avatar) ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26),
                        ),
                        Text(
                          'Refer & Earn',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFC0E8C7), width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Color(0xFF006B23),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ─── 2. Hero Incentive Banner Card ───────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              'LIMITED TIME OFFER',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: const Color(0xFF00531A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Give \$20, Get\n\$20',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              height: 36 / 32,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Invite your friends to Daily Basket. They get \$20 off their first order, and you get \$20 when they complete it.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 18 / 13,
                              color: const Color(0xFF6E7A6C),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Start Referring CTA
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _copyCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006B23),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Start Referring',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Rules & T&C Button
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pushNamed('/terms-of-service'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1A1C1E),
                                side: const BorderSide(color: Color(0xFFEEEEF0)),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'Rules & T&C',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Hero 3D Card Graphic Box
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withValues(alpha: 0.20),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Share the Health!',
                                          style: GoogleFonts.outfit(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Instant \$20 credit added upon friend\'s first order',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: Colors.white.withValues(alpha: 0.90),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 3. Your Unique Invite Code Card ──────────────────────
                    Text(
                      'Your Unique Invite Code',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF8CFA93),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            referralCode,
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: _copyCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006B23),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              icon: Icon(
                                _isCopied ? Icons.check_circle_rounded : Icons.copy_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: Text(
                                _isCopied ? 'Copied!' : 'Copy Code',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Share this code or your personal link below',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6E7A6C),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 4. Share with Friends Grid ───────────────────────────
                    Text(
                      'Share with friends',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildShareTile(Icons.chat_rounded, 'WhatsApp', const Color(0xFFE8F5E9), const Color(0xFF006B23)),
                        _buildShareTile(Icons.sms_rounded, 'SMS', const Color(0xFFE8F5E9), const Color(0xFF006B23)),
                        _buildShareTile(Icons.send_rounded, 'Messenger', const Color(0xFFE3F2FD), const Color(0xFF1E88E5)),
                        _buildShareTile(Icons.share_rounded, 'More', const Color(0xFFF3F3F6), const Color(0xFF1A1C1E)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ─── 5. How it works Section ─────────────────────────────
                    Text(
                      'How it works',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildStepCard(
                      stepNumber: '1',
                      icon: Icons.near_me_outlined,
                      title: '1. Send Invite',
                      subtitle: 'Share your unique code or referral link with your friends and family.',
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      stepNumber: '2',
                      icon: Icons.person_add_alt_1_outlined,
                      title: '2. Friend Joins',
                      subtitle: 'Your friends get \$20 off their very first shop when they use your code.',
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      stepNumber: '3',
                      icon: Icons.account_balance_wallet_outlined,
                      title: '3. Earn Reward',
                      subtitle: 'Once their order is completed, you\'ll receive \$20 in your Daily Basket wallet.',
                    ),

                    const SizedBox(height: 24),

                    // ─── 6. Reward Tracking Summary Card ─────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'SUCCESSFUL REFERRALS',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: const Color(0xFF6E7A6C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${couponProvider.successfulReferrals} / ${couponProvider.totalInvited}',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 14),

                          Text(
                            'TOTAL REWARDS EARNED',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: const Color(0xFF6E7A6C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${couponProvider.referralEarnings.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                          const SizedBox(height: 14),

                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/referral-history'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View Referral Details & History',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF006B23), size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ─── 7. Frequently Asked Questions (FAQ) ─────────────────
                    Text(
                      'Frequently Asked Questions',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildFaqTile(
                      question: 'Is there a limit on how many friends I can refer?',
                      answer: 'No limit! You can refer as many friends as you like and earn \$20 for every successful referral.',
                      isExpanded: _faq1Expanded,
                      onTap: () => setState(() => _faq1Expanded = !_faq1Expanded),
                    ),
                    const SizedBox(height: 10),
                    _buildFaqTile(
                      question: 'When will I get my \$20 reward?',
                      answer: 'Your \$20 wallet credit is automatically deposited within 10 minutes of your friend completing their first order.',
                      isExpanded: _faq2Expanded,
                      onTap: () => setState(() => _faq2Expanded = !_faq2Expanded),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ─── 8. Persistent Bottom Navigation Bar ──────────────────────────
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
                  _buildBottomNavItem(2, Icons.card_giftcard_rounded, 'Rewards'),
                  _buildBottomNavItem(3, Icons.person_outline_rounded, 'Account'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareTile(IconData icon, String label, Color bg, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
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
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF006B23), size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 16 / 12,
              color: const Color(0xFF6E7A6C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (_) => onTap(),
        iconColor: const Color(0xFF1A1C1E),
        collapsedIconColor: const Color(0xFF1A1C1E),
        title: Text(
          question,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        children: [
          Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 16 / 12,
              color: const Color(0xFF6E7A6C),
            ),
          ),
        ],
      ),
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
