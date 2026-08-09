import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Coupon Details - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 5df6d74f836347239bf3d817d21685ac
class AdminCouponDetailsScreen extends StatelessWidget {
  const AdminCouponDetailsScreen({super.key});

  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Coupon Details: WELCOME50',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WELCOME50', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 24, fontFamily: 'monospace')),
                  SizedBox(height: 6),
                  Text('50% OFF up to ₹100 for New Users', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 4),
                  Text('Total Redemptions: 1,420 • Status: ACTIVE', style: TextStyle(color: _textMuted, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
