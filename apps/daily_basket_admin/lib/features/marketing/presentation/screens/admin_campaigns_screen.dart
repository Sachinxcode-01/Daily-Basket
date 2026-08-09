import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Campaign & Offers - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 2dda772b4d834ef69b76b0da69bbc596
class AdminCampaignsScreen extends StatelessWidget {
  const AdminCampaignsScreen({super.key});

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
          'Campaigns & Banners',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diwali Mega Sale Banner', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 4),
                  Text('Active • 1 Nov - 10 Nov', style: TextStyle(color: _textMuted, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
