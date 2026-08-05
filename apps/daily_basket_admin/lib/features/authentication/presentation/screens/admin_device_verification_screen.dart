import 'package:flutter/material.dart';

class AdminDeviceVerificationScreen extends StatelessWidget {
  const AdminDeviceVerificationScreen({super.key});

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
              const Icon(Icons.devices_other_rounded, size: 64, color: Color(0xFF2DD4BF)),
              const SizedBox(height: 24),
              const Text('Device Trust Verification', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Device ID: dev_macbook_pro_m3_01\nRisk Score: 0.04 (TRUSTED)', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                    SizedBox(width: 12),
                    Expanded(child: Text('Device fingerprint matched & encrypted token stored.', style: TextStyle(color: Colors.white, fontSize: 13))),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/admin/dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Open Operations Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
