import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Coupon Analytics - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: ad9213e4fcb64313875f1b6cbf1bf92d
class AdminCouponAnalyticsScreen extends StatelessWidget {
  const AdminCouponAnalyticsScreen({super.key});

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
          'Coupon Analytics & ROI',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top Metrics
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Influenced Revenue', style: TextStyle(color: _textMuted, fontSize: 11)),
                        SizedBox(height: 4),
                        Text('₹14.2L', style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Campaign ROI', style: TextStyle(color: _textMuted, fontSize: 11)),
                        SizedBox(height: 4),
                        Text('8.4x', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Performance Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Performing Coupon', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('WELCOME50', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'monospace')),
                      Text('1,420 orders', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
