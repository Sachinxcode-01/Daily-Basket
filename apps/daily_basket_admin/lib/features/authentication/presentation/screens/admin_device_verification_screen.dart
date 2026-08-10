import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';

/// Stitch Screen: Admin Trusted Device Verification
/// ID: 22b116d8bd9b41e1a34479831a3dd6ac
class AdminDeviceVerificationScreen extends StatelessWidget {
  const AdminDeviceVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AdminAuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.devices_other_rounded, size: 64, color: Color(0xFF8CFA93)),
              const SizedBox(height: 24),
              const Text('Device Trust Verification', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                'Device ID: ${auth.deviceId}\nRisk Score: ${auth.riskScore} (TRUSTED)',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 14),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF2F3133), borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF8CFA93)),
                    SizedBox(width: 12),
                    Expanded(child: Text('Device fingerprint matched & encrypted token stored.', style: TextStyle(color: Colors.white, fontSize: 13))),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  auth.completeAuthentication();
                  Navigator.pushReplacementNamed(context, '/admin/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006B23),
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


