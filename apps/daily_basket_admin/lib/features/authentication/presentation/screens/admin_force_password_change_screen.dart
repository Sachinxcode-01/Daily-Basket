import 'package:flutter/material.dart';

class AdminForcePasswordChangeScreen extends StatelessWidget {
  const AdminForcePasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.published_with_changes_rounded, size: 48, color: Color(0xFFF59E0B)),
            const SizedBox(height: 16),
            const Text('Mandatory Password Rotation', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your admin password has expired (90-day policy). Update password to continue.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
            const SizedBox(height: 32),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF2DD4BF)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/terms-acceptance'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Update Password & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
