import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Referral History Screen — Google Stitch Design System Exact Replica
class ReferralHistoryScreen extends StatefulWidget {
  const ReferralHistoryScreen({super.key});

  @override
  State<ReferralHistoryScreen> createState() => _ReferralHistoryScreenState();
}

class _ReferralHistoryScreenState extends State<ReferralHistoryScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Successful, 2: Pending
  int _bottomNavIndex = 3; // Rewards active

  final List<Map<String, dynamic>> _referrals = [
    {
      'id': 'r1',
      'name': 'Sarah Jenkins',
      'date': 'Oct 24, 2023',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'amount': '+\$20',
      'hint': null,
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
    },
    {
      'id': 'r2',
      'name': 'Marcus Chen',
      'date': 'Nov 02, 2023',
      'status': 'JOINED',
      'statusColor': const Color(0xFF1E88E5),
      'statusBg': const Color(0xFFE3F2FD),
      'amount': '+\$20',
      'hint': 'Waiting for first order',
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
    },
    {
      'id': 'r3',
      'name': 'Elena Rodriguez',
      'date': 'Oct 18, 2023',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'amount': '+\$20',
      'hint': null,
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
    },
    {
      'id': 'r4',
      'name': 'David Wu',
      'date': 'Nov 05, 2023',
      'status': 'PENDING',
      'statusColor': const Color(0xFFE65100),
      'statusBg': const Color(0xFFFFF3E0),
      'amount': '+\$20',
      'hint': null,
      'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80',
    },
    {
      'id': 'r5',
      'name': 'Aisha Khan',
      'date': 'Oct 12, 2023',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'amount': '+\$20',
      'hint': null,
      'avatarUrl': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80',
    },
  ];

  List<Map<String, dynamic>> get _filteredReferrals {
    if (_selectedTabIndex == 1) {
      return _referrals.where((r) => r['status'] == 'COMPLETED').toList();
    } else if (_selectedTabIndex == 2) {
      return _referrals.where((r) => r['status'] == 'PENDING' || r['status'] == 'JOINED').toList();
    }
    return _referrals;
  }

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
          'Referral Details',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF1A1C1E)),
            onPressed: () => Navigator.of(context).pushNamed('/help'),
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
                children: [
                  const SizedBox(height: 12),

                  // ─── 1. High-Impact Earnings Summary Header Card ───────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF006B23), Color(0xFF00531A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF006B23).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL EARNED',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$120',
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_rounded, color: Color(0xFF006B23), size: 14),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '6 Successful Referrals',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.trending_up_rounded, color: Color(0xFF8CFA93), size: 22),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── 2. Categorized Tracking Tab Bar ───────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem(0, 'All'),
                      _buildTabItem(1, 'Successful'),
                      _buildTabItem(2, 'Pending'),
                    ],
                  ),
                  const Divider(color: Color(0xFFEEEEF0), height: 1),

                  const SizedBox(height: 16),

                  // ─── 3. Detailed Referral Cards List ───────────────────────
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredReferrals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filteredReferrals[index];
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
                            // Friend Avatar Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: Image.network(
                                item['avatarUrl'] as String,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 46,
                                  height: 46,
                                  color: const Color(0xFFE8F5E9),
                                  child: const Icon(Icons.person, color: Color(0xFF006B23)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Referral Details Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${item['date']} • ',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF6E7A6C),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: item['statusBg'] as Color,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['status'] as String,
                                          style: GoogleFonts.inter(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                            color: item['statusColor'] as Color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item['hint'] != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.info_outline_rounded,
                                            size: 13, color: Color(0xFF6E7A6C)),
                                        const SizedBox(width: 4),
                                        Text(
                                          item['hint'] as String,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: const Color(0xFF6E7A6C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Reward Amount Text
                            Text(
                              item['amount'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: item['status'] == 'COMPLETED'
                                    ? const Color(0xFF006B23)
                                    : const Color(0xFF1A1C1E),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ─── 4. Persistent Bottom Navigation Bar ──────────────────────────
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
                _buildBottomNavItem(2, Icons.receipt_long_outlined, 'Orders'),
                _buildBottomNavItem(3, Icons.card_giftcard_rounded, 'Rewards'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
              ),
            ),
          ),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF006B23) : Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
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
