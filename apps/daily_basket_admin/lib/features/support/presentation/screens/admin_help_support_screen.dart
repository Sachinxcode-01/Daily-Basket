import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Help & Support - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 91bf727083b347b4b71f60a23bb4a2b8
class AdminHelpSupportScreen extends StatelessWidget {
  const AdminHelpSupportScreen({super.key});

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
          'Help & Support Center',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Quick Support Actions
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: const Column(
                      children: [
                        Icon(Icons.headset_mic_outlined, color: _primaryGreen, size: 28),
                        SizedBox(height: 8),
                        Text('Live Support', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: const Column(
                      children: [
                        Icon(Icons.menu_book_outlined, color: Color(0xFF0284C7), size: 28),
                        SizedBox(height: 8),
                        Text('Docs & Guides', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Frequently Asked Questions', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            _buildFaqItem('How do I configure automatic PO generation?', 'Go to Purchase Management > Suppliers, select a preferred supplier and enable Auto Restock threshold.'),
            _buildFaqItem('What is the SLA for 10-minute delivery dispatch?', 'Orders must be picked and packed within 3 minutes of customer checkout for optimal rider assignment.'),
            _buildFaqItem('How do I process custom GST tax overrides?', 'Navigate to Settings > Finance > GST Liability and upload your state-specific HSN/SAC matrix.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13.5)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Text(answer, style: const TextStyle(color: _textMuted, fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
