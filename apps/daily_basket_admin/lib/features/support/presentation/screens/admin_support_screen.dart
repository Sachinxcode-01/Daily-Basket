import 'package:flutter/material.dart';

class AdminSupportScreen extends StatelessWidget {
  const AdminSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Support Escalations & AI Agent Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTicketTile('TCK-9912', 'Missing item in order #DB-892010', 'Ananya Sharma', 'ESCALATED_TO_HUMAN', const Color(0xFFEF4444)),
          _buildTicketTile('TCK-9908', 'Damaged organic milk package refund', 'Rohan Gupta', 'REFUND_APPROVED', const Color(0xFF10B981)),
          _buildTicketTile('TCK-9901', 'Address change request during transit', 'Priya Nair', 'RESOLVED_BY_AI', const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildTicketTile(String id, String subject, String customer, String status, Color color) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text('$id • $customer', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subject, style: const TextStyle(color: Color(0xFF94A3B8))),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
