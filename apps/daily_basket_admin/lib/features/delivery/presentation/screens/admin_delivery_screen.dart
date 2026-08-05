import 'package:flutter/material.dart';

class AdminDeliveryScreen extends StatelessWidget {
  const AdminDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Delivery Fleet & Live GPS Tracking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRiderTile('Ramesh Kumar', '+91 98765 00112', 'KA 01 EB 4821', '18 Deliveries Today', '4.9 Rating', true),
          _buildRiderTile('Suresh Patel', '+91 98765 00113', 'KA 01 EB 9920', '14 Deliveries Today', '4.8 Rating', true),
          _buildRiderTile('Vikram Singh', '+91 98765 00114', 'KA 01 EB 1124', 'Off Duty (Leave)', '4.7 Rating', false),
        ],
      ),
    );
  }

  Widget _buildRiderTile(String name, String phone, String vehicle, String deliveries, String rating, bool isOnline) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
          child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 20),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('$phone • $vehicle\n$deliveries • $rating', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOnline ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFF64748B).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(isOnline ? 'ONLINE' : 'OFFLINE', style: TextStyle(color: isOnline ? const Color(0xFF10B981) : const Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
