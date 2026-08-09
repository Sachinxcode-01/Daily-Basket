import 'package:flutter/material.dart';

/// Google Stitch Source of Truth Screen: Reports & Analytics Center - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 744f3887c5604ad183aca8a23d31dcb8
class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

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
        title: const Text(
          'Reports & Analytics Center',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Stat Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gross Revenue', style: TextStyle(color: _textMuted, fontSize: 11)),
                        SizedBox(height: 4),
                        Text('₹45.8L', style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Orders', style: TextStyle(color: _textMuted, fontSize: 11)),
                        SizedBox(height: 4),
                        Text('12,840', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Available Downloadable Reports
            const Text('Exportable Reports', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            _buildReportDownloadTile('Sales & Revenue Summary', 'Monthly revenue, order volume & AOV', Icons.bar_chart_rounded),
            _buildReportDownloadTile('Inventory Spoilage Report', 'Perishable wastage & stock loss ledger', Icons.inventory_2_outlined),
            _buildReportDownloadTile('Delivery Partner Performance', 'Rider SLA, rating & payout ledger', Icons.local_shipping_outlined),
            _buildReportDownloadTile('GST Tax Liability Statement', 'Input tax credit & CGST/SGST breakdown', Icons.receipt_long_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildReportDownloadTile(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: _primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13.5)),
                Text(subtitle, style: const TextStyle(color: _textMuted, fontSize: 11.5)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: _primaryGreen),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
