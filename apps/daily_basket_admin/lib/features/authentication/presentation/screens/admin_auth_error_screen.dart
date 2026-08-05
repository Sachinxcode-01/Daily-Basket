import 'package:flutter/material.dart';

class AdminAuthErrorScreen extends StatelessWidget {
  const AdminAuthErrorScreen({super.key});

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
              const Icon(Icons.gpp_bad_rounded, size: 72, color: Color(0xFFEF4444)),
              const SizedBox(height: 24),
              const Text('Authentication Error', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Invalid token, failed MFA challenge, or network timeout.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/admin/secure-login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Return to Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
