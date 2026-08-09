import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Go Live & Launch Checklist - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: eece7072c79f45dc8785946e46beab3b
class AdminLaunchChecklistScreen extends StatelessWidget {
  const AdminLaunchChecklistScreen({super.key});

  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
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
        title: const Row(
          children: [
            Icon(Icons.rocket_launch_outlined, color: _primaryGreen, size: 20),
            SizedBox(width: 8),
            Text('Go Live & Launch Checklist', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Progress Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('System Readiness Score', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('85% Ready', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const LinearProgressIndicator(
                      value: 0.85,
                      minHeight: 8,
                      backgroundColor: Color(0xFFF1F5F9),
                      color: _primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Pre-Launch Verification Tasks', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            _buildCheckitem('NestJS Production Database Connection', true),
            _buildCheckitem('Stripe & Razorpay Live API Keys Configured', true),
            _buildCheckitem('Dark Store Warehouses & Inventory Seeded', true),
            _buildCheckitem('Delivery Partner Geofencing & Zone Bounds Set', true),
            _buildCheckitem('Domain SSL Certificate & DNS Verification', false),
            _buildCheckitem('Push Notification Firebase Service Account JSON', false),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckitem(String title, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isDone ? _primaryGreen : _textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDone ? _textDark : _textMuted,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
