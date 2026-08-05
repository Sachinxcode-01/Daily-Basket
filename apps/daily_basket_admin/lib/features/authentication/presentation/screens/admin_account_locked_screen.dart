import 'package:flutter/material.dart';

class AdminAccountLockedScreen extends StatelessWidget {
  const AdminAccountLockedScreen({super.key});

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
              const Icon(Icons.lock_clock_rounded, size: 72, color: Color(0xFFEF4444)),
              const SizedBox(height: 24),
              const Text('Account Locked', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Account locked due to 5 consecutive failed login attempts.\nTry again after 15 minutes or contact Security Admin.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/admin/welcome'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Return to Welcome Screen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
