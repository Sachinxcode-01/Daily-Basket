import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Privacy Policy & Terms - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 5d9958f69a2144ddbdd4f1f8d89d44b6
class AdminPrivacyPolicyScreen extends StatelessWidget {
  const AdminPrivacyPolicyScreen({super.key});

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
          'Privacy Policy & Terms',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                  Text('Data Protection & Security Standard', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 8),
                  Text(
                    'Daily Basket platform complies with DPDP regulations and GDPR standards. All customer telemetry and payment tokens are encrypted at rest using AES-256 and in transit via TLS 1.3.',
                    style: TextStyle(color: _textMuted, fontSize: 12.5, height: 1.4),
                  ),
                  SizedBox(height: 12),
                  Text('Last Updated: August 9, 2026', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
