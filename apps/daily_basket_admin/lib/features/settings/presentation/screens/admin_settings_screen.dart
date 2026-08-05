import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('RBAC Roles & System Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Access Control & Roles'),
          _buildSettingsTile('Role-Based Access Control (RBAC)', 'Manage Store Manager & Admin permissions', Icons.security_rounded),
          _buildSettingsTile('Passkeys & FIDO2 Enrollment', 'WebAuthn hardware security keys', Icons.fingerprint_rounded),
          _buildSettingsTile('API Key & Secret Rotation', 'Rotate NestJS JWT and gateway secrets', Icons.key_rounded),
          const SizedBox(height: 20),
          _buildSectionHeader('System Integrations'),
          _buildSettingsTile('Razorpay Payment Gateway', 'Status: LIVE (Production Mode)', Icons.payment_rounded),
          _buildSettingsTile('Google Maps Distance Matrix', 'Status: CONNECTED', Icons.map_outlined),
          _buildSettingsTile('Gemini AI Provider Suite', 'Status: OPERATIONAL (v2.0 Flash)', Icons.auto_awesome_rounded),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2DD4BF)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 14),
      ),
    );
  }
}
