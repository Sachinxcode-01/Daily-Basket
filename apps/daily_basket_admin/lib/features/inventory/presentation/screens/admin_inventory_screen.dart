import 'package:flutter/material.dart';

class AdminInventoryScreen extends StatelessWidget {
  const AdminInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Inventory & Goods Inward (GRN)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _buildActionTile('Scan QR Barcode', Icons.qr_code_scanner_rounded, const Color(0xFF0F766E))),
              const SizedBox(width: 12),
              Expanded(child: _buildActionTile('New PO Request', Icons.post_add_rounded, const Color(0xFF3B82F6))),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Near-Expiry Batch Reminders', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildItemCard('Organic Milk 500ml', 'BAT-9921', '14 Units remaining', 'Expires in 2 days (Flash 30% Off)'),
          _buildItemCard('Fresh Sandwich Bread', 'BAT-8812', '8 Units remaining', 'Expires in 1 day (Clearance)'),
          const SizedBox(height: 20),
          const Text('Dark Store Shelf Locations', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildShelfRow('Aisle-1-A4', 'Organic Farm Tomatoes 500g', '142 in stock'),
          _buildShelfRow('Aisle-2-B1', 'Amul Taaza Toned Milk 1L', '88 in stock'),
        ],
      ),
    );
  }

  Widget _buildActionTile(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildItemCard(String name, String batch, String stock, String alert) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('Batch: $batch • $stock', style: const TextStyle(color: Color(0xFF94A3B8))),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFF59E0B).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Text(alert, style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildShelfRow(String shelf, String item, String count) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(8)),
          child: Text(shelf, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
        ),
        title: Text(item, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: Text(count, style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold)),
      ),
    );
  }
}
