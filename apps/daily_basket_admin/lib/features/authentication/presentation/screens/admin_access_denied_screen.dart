import 'package:flutter/material.dart';

class AdminAccessDeniedScreen extends StatelessWidget {
  const AdminAccessDeniedScreen({super.key});

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
              const Icon(Icons.block_rounded, size: 72, color: Color(0xFFEF4444)),
              const SizedBox(height: 24),
              const Text('403 - Access Denied', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Your admin account lacks permissions (RBAC) to view this financial or security module.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/admin/dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Back to Operations Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
