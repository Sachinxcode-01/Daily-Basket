import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Wallet & Rewards Screen — Google Stitch Design System Exact Replica
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _bottomNavIndex = 2; // Wallet tab active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Wallet & Rewards',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF006B23)),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // ─── 1. Daily Basket Balance Card ───────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF006B23), Color(0xFF00531A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF006B23).withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAILY BASKET BALANCE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$45.20',
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Quick Actions (Top Up & Send)
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Top Up modal opened'),
                                        backgroundColor: Color(0xFF006B23),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF006B23),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add_circle_outline_rounded,
                                      color: Color(0xFF006B23), size: 20),
                                  label: Text(
                                    'Top Up',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: ElevatedButton.icon(
                                  onPressed: () => Navigator.of(context).pushNamed('/payment'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B8539),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.send_rounded,
                                      color: Colors.white, size: 18),
                                  label: Text(
                                    'Send',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── 2. Quick Utility Icon Grid ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildUtilityTile(Icons.qr_code_scanner_rounded, 'Scan & Pay'),
                      _buildUtilityTile(Icons.history_rounded, 'History'),
                      _buildUtilityTile(Icons.card_giftcard_rounded, 'Store'),
                      _buildUtilityTile(Icons.local_offer_outlined, 'Offers'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── 3. Loyalty Program Integration Card ─────────────────────
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '1,250 Points ',
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                    const Icon(Icons.stars_rounded,
                                        color: Color(0xFF006B23), size: 20),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Gold Member',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF6E7A6C),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8CFA93),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                'NEXT: PLATINUM',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF00531A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: const LinearProgressIndicator(
                            value: 0.72,
                            minHeight: 8,
                            backgroundColor: Color(0xFFEEEEF0),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006B23)),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Reward Goal Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF3F4A3D),
                                    ),
                                    children: [
                                      const TextSpan(text: 'Earn 250 more points to unlock '),
                                      TextSpan(
                                        text: 'Free Delivery',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF006B23),
                                        ),
                                      ),
                                      const TextSpan(text: ' on all orders.'),
                                    ],
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Color(0xFF6E7A6C), size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── 4. Reward Boosters Banner ──────────────────────────────
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.70),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Weekly Booster',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF8CFA93),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '2x Points on Organics',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── 5. Recent Activity Section ─────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/wallet'),
                        child: Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Activity Items List
                  _buildActivityTile(
                    icon: Icons.shopping_bag_outlined,
                    iconBg: const Color(0xFF006B23),
                    iconColor: Colors.white,
                    title: 'Grocery Order #4521',
                    subtitle: 'Oct 24, 2023 • 2:45 PM',
                    amount: '- \$32.40',
                    amountColor: const Color(0xFFBA1A1A),
                    subText: '+32 pts',
                    subTextColor: const Color(0xFF006B23),
                  ),
                  const SizedBox(height: 12),
                  _buildActivityTile(
                    icon: Icons.account_balance_wallet_outlined,
                    iconBg: const Color(0xFFF3F3F6),
                    iconColor: const Color(0xFF1A1C1E),
                    title: 'Wallet Top Up',
                    subtitle: 'Oct 22, 2023 • 10:15 AM',
                    amount: '+ \$50.00',
                    amountColor: const Color(0xFF006B23),
                    subText: 'Bank Transfer',
                    subTextColor: const Color(0xFF6E7A6C),
                  ),
                  const SizedBox(height: 12),
                  _buildActivityTile(
                    icon: Icons.published_with_changes_rounded,
                    iconBg: const Color(0xFFF3F3F6),
                    iconColor: const Color(0xFF1A1C1E),
                    title: 'Refund: Out of Stock',
                    subtitle: 'Oct 20, 2023 • 11:30 AM',
                    amount: '+ \$4.50',
                    amountColor: const Color(0xFF006B23),
                    subText: 'Order #4489',
                    subTextColor: const Color(0xFF6E7A6C),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ─── 6. Persistent Bottom Navigation Bar ──────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEF0), width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
                _buildBottomNavItem(1, Icons.grid_view_rounded, 'Categories'),
                _buildBottomNavItem(2, Icons.account_balance_wallet_rounded, 'Wallet'),
                _buildBottomNavItem(3, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityTile(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: const Color(0xFF1A1C1E), size: 24),
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

  Widget _buildActivityTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
    required String subText,
    required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
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
                    color: const Color(0xFF1A1C1E),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subText,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                ),
              ),
            ],
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
