import 'package:flutter/material.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Customer Lifetime Value & VIPs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCustomerTile('Ananya Sharma', 'ananya@gmail.com', '₹14,250 CLV (VIP Tier)', '42 Orders Completed', true),
          _buildCustomerTile('Rohan Gupta', 'rohan.g@yahoo.com', '₹8,400 CLV (Gold Tier)', '26 Orders Completed', false),
          _buildCustomerTile('Priya Nair', 'priya.nair@hotmail.com', '₹5,120 CLV (Silver Tier)', '15 Orders Completed', false),
          _buildCustomerTile('Karan Verma', 'karan.v@gmail.com', '₹12,800 CLV (VIP Tier)', '38 Orders Completed', true),
        ],
      ),
    );
  }

  Widget _buildCustomerTile(String name, String email, String clv, String orders, bool isVip) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isVip ? const Color(0xFFF59E0B) : const Color(0xFF0F766E),
          child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        title: Row(
          children: [
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            if (isVip) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(6)),
                child: const Text('VIP', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        subtitle: Text('$email\n$clv • $orders', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 14),
      ),
    );
  }
}
