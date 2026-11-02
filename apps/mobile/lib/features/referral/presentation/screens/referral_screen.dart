import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../providers/coupon_provider.dart';

/// Refer & Earn Screen — Google Stitch Design System Exact Replica
/// Includes:
/// - Working Drawer Navigation Bar trigger (hamburger menu)
/// - Working clickable Profile Section (navigates to `/profile`)
/// - Start Referring interactive share bottom sheet
/// - Rules & Terms & Conditions bottom sheet
/// - One-tap invite code copy with haptic feedback
/// - Interactive Share with Friends tiles (WhatsApp, SMS, Messenger, More)
/// - Referral stats & history link
/// - Pull-to-refresh
/// - Global persistent 6-tab Bottom Navigation Bar
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final String _referralCode = 'DAILY20-USER';
  bool _isCopied = false;

  bool _faq1Expanded = false;
  bool _faq2Expanded = false;

  String get _inviteMessage =>
      'Hey! Use my referral code DAILY20-USER to get \$20 off your first grocery order on Daily Basket! '
      '10-minute ultrafast farm-fresh delivery: https://dailybasket.app/r/DAILY20-USER';

  void _copyCode() {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: _referralCode));
    setState(() => _isCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code DAILY20-USER copied to clipboard!'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  void _shareViaWhatsApp() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: _inviteMessage));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WhatsApp invite message copied! Paste it in your chat.'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareViaSms() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: _inviteMessage));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SMS invite message copied to clipboard!'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareViaMessenger() {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: _inviteMessage));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Messenger invite message copied to clipboard!'),
        backgroundColor: Color(0xFF1E88E5),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showShareModal(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
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
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFBECAB9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Share Your Invite Link',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your friends get \$20 off their first shop, and you earn \$20 wallet credit after their first delivery!',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6E7A6C),
              ),
            ),
            const SizedBox(height: 20),

            // Link Box with Copy Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFBECAB9).withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded,
                      color: Color(0xFF006B23), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'https://dailybasket.app/r/$_referralCode',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1C1E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _copyCode();
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.copy_rounded,
                        size: 16, color: Color(0xFF006B23)),
                    label: Text(
                      'Copy',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF006B23),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Choose sharing app',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildModalShareOption(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  color: const Color(0xFF006B23),
                  bgColor: const Color(0xFFE8F5E9),
                  onTap: () {
                    Navigator.pop(ctx);
                    _shareViaWhatsApp();
                  },
                ),
                _buildModalShareOption(
                  icon: Icons.sms_rounded,
                  label: 'SMS',
                  color: const Color(0xFF006B23),
                  bgColor: const Color(0xFFE8F5E9),
                  onTap: () {
                    Navigator.pop(ctx);
                    _shareViaSms();
                  },
                ),
                _buildModalShareOption(
                  icon: Icons.send_rounded,
                  label: 'Messenger',
                  color: const Color(0xFF1E88E5),
                  bgColor: const Color(0xFFE3F2FD),
                  onTap: () {
                    Navigator.pop(ctx);
                    _shareViaMessenger();
                  },
                ),
                _buildModalShareOption(
                  icon: Icons.qr_code_rounded,
                  label: 'QR Code',
                  color: const Color(0xFF6E7A6C),
                  bgColor: const Color(0xFFF3F3F6),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showQrCodeDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModalShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
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
        ),
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Your Referral QR Code',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBECAB9)),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 160,
                color: Color(0xFF006B23),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Code: $_referralCode',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF006B23),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Have your friend scan this from their camera to auto-apply \$20 discount!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 12, color: const Color(0xFF6E7A6C)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF006B23),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesAndTcModal(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFBECAB9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Referral Rules & T&C',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildRuleItem('1. Eligible Participants',
                      'Only registered Daily Basket users with at least 1 completed order are eligible to invite friends.'),
                  _buildRuleItem('2. Friend Welcome Discount',
                      'Invited friend receives an instant \$20 coupon discount applied at checkout on their first order above \$30.'),
                  _buildRuleItem('3. Referrer Reward Credit',
                      'You will automatically receive \$20 wallet balance within 10 minutes of your friend completing their first order delivery.'),
                  _buildRuleItem('4. Unlimited Invitations',
                      'There is no cap on how many people you can invite! Refer 10 friends to earn \$200 in wallet credit.'),
                  _buildRuleItem('5. Wallet Credit Usability',
                      'Your earned referral credits never expire and can be used to pay for 100% of any subsequent basket.'),
                  _buildRuleItem('6. Fair Use Policy',
                      'Self-referrals, duplicated accounts, or device spoofing are strictly prohibited and will forfeit referral rewards.'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pushNamed('/terms-of-service');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF006B23)),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'View Full Terms of Service',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF006B23),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF006B23),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6E7A6C),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = context.watch<CouponProvider>();
    final referralCode = couponProvider.referralCode;

    UserProvider? userProvider;
    try {
      userProvider = context.watch<UserProvider>();
    } catch (_) {}

    final profileImageUrl = userProvider?.profileImageUrl ??
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppNavigationDrawer(isDrawer: true),
      bottomNavigationBar: const AppBottomNav(currentIndex: -1),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF006B23),
          onRefresh: () async {
            HapticFeedback.lightImpact();
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) setState(() {});
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // ─── 1. Header (Menu + Refer & Earn Title + Profile Avatar) ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              AppNavigationDrawer.show(context);
                            },
                            tooltip: 'Main Navigation Menu',
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Color(0xFF1A1C1E),
                              size: 26,
                            ),
                          ),
                          Text(
                            'Refer & Earn',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pushNamed('/profile');
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFC0E8C7),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF006B23)
                                        .withValues(alpha: 0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9999),
                                child: Image.network(
                                  profileImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: Color(0xFF006B23),
                                  ),
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
                          border: Border.all(
                            color:
                                const Color(0xFFBECAB9).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
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
                                onPressed: () => _showShareModal(context),
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
                                onPressed: () => _showRulesAndTcModal(context),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1A1C1E),
                                  side: const BorderSide(
                                      color: Color(0xFFEEEEF0)),
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
                                        color: Colors.black
                                            .withValues(alpha: 0.20),
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              color: Colors.white
                                                  .withValues(alpha: 0.90),
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
                                  _isCopied
                                      ? Icons.check_circle_rounded
                                      : Icons.copy_rounded,
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
                          _buildShareTile(
                            icon: Icons.chat_rounded,
                            label: 'WhatsApp',
                            bg: const Color(0xFFE8F5E9),
                            iconColor: const Color(0xFF006B23),
                            onTap: _shareViaWhatsApp,
                          ),
                          _buildShareTile(
                            icon: Icons.sms_rounded,
                            label: 'SMS',
                            bg: const Color(0xFFE8F5E9),
                            iconColor: const Color(0xFF006B23),
                            onTap: _shareViaSms,
                          ),
                          _buildShareTile(
                            icon: Icons.send_rounded,
                            label: 'Messenger',
                            bg: const Color(0xFFE3F2FD),
                            iconColor: const Color(0xFF1E88E5),
                            onTap: _shareViaMessenger,
                          ),
                          _buildShareTile(
                            icon: Icons.share_rounded,
                            label: 'More',
                            bg: const Color(0xFFF3F3F6),
                            iconColor: const Color(0xFF1A1C1E),
                            onTap: () => _showShareModal(context),
                          ),
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
                        subtitle:
                            'Share your unique code or referral link with your friends and family.',
                      ),
                      const SizedBox(height: 12),
                      _buildStepCard(
                        stepNumber: '2',
                        icon: Icons.person_add_alt_1_outlined,
                        title: '2. Friend Joins',
                        subtitle:
                            'Your friends get \$20 off their very first shop when they use your code.',
                      ),
                      const SizedBox(height: 12),
                      _buildStepCard(
                        stepNumber: '3',
                        icon: Icons.account_balance_wallet_outlined,
                        title: '3. Earn Reward',
                        subtitle:
                            'Once their order is completed, you\'ll receive \$20 in your Daily Basket wallet.',
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
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.of(context)
                                    .pushNamed('/referral-history');
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Referral Details & History',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right_rounded,
                                        color: Color(0xFF006B23), size: 18),
                                  ],
                                ),
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
                        question:
                            'Is there a limit on how many friends I can refer?',
                        answer:
                            'No limit! You can refer as many friends as you like and earn \$20 for every successful referral.',
                        isExpanded: _faq1Expanded,
                        onTap: () =>
                            setState(() => _faq1Expanded = !_faq1Expanded),
                      ),
                      const SizedBox(height: 10),
                      _buildFaqTile(
                        question: 'When will I get my \$20 reward?',
                        answer:
                            'Your \$20 wallet credit is automatically deposited within 10 minutes of your friend completing their first order.',
                        isExpanded: _faq2Expanded,
                        onTap: () =>
                            setState(() => _faq2Expanded = !_faq2Expanded),
                      ),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareTile({
    required IconData icon,
    required String label,
    required Color bg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
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
        ),
      ),
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
        border:
            Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
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
}
