import 'package:flutter/material.dart';

class AdminWelcomeScreen extends StatelessWidget {
  const AdminWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0F766E), width: 2),
                  ),
                  child: const Icon(Icons.storefront_rounded, size: 72, color: Color(0xFF2DD4BF)),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Enterprise Admin Portal',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Manage Dark Stores, Real-time Logistics, Inventory, GST Compliance, and AI Operations.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15, height: 1.5),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/admin/secure-login'),
                icon: const Icon(Icons.lock_rounded, color: Colors.white),
                label: const Text('Secure SSO & Password Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/admin/google-signin'),
                icon: const Icon(Icons.g_mobiledata_rounded, size: 32, color: Colors.white),
                label: const Text('Google Workspace SSO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF334155)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
