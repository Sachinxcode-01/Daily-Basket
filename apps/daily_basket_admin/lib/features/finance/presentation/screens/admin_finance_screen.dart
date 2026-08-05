import 'package:flutter/material.dart';

class AdminFinanceScreen extends StatelessWidget {
  const AdminFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Finance, GST & Payout Ledgers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard('Gross Monthly Revenue', '₹4,82,900.00', 'Net Profit: ₹86,900.00', const Color(0xFF0F766E)),
          const SizedBox(height: 16),
          _buildSummaryCard('GST Liability (CGST + SGST)', '₹43,461.00', 'GSTIN: 29AABCD1234E1Z5', const Color(0xFF3B82F6)),
          const SizedBox(height: 16),
          _buildSummaryCard('Supplier Vendor Payouts Due', '₹1,24,500.00', '2 Vendors Processing Settlement', const Color(0xFFF59E0B)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            label: const Text('Export Monthly Financial CSV Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          const SizedBox(height: 8),
          Text(amount, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
