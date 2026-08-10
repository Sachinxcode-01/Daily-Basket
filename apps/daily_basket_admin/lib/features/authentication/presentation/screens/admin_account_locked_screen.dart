import 'package:flutter/material.dart';

/// Stitch Screen: Admin Account Locked / Access Denied
/// ID: c1fe585f15c940e2b792b1b3bb89304e
class AdminAccountLockedScreen extends StatelessWidget {
  const AdminAccountLockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBA1A1A), width: 2),
                ),
                child: const Icon(Icons.lock_clock_rounded, size: 64, color: Color(0xFFBA1A1A)),
              ),
              const SizedBox(height: 24),
              const Text('Account Locked', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Account locked due to 5 consecutive failed login attempts.\nTry again after 15 minutes or contact Security Admin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFBECAB9), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/admin/welcome'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Return to Welcome Screen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security alert logged. IT Security Officer notified.')),
                  );
                },
                child: const Text('Contact Security Admin', style: TextStyle(color: Color(0xFFBECAB9), fontSize: 12, decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

