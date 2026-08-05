import 'package:flutter/material.dart';

class AdminSessionExpiredScreen extends StatelessWidget {
  const AdminSessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_off_rounded, size: 72, color: Color(0xFFF59E0B)),
              const SizedBox(height: 24),
              const Text('Session Expired', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Your admin session timed out after inactivity for enterprise security.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/admin/secure-login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Re-authenticate Admin SSO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
