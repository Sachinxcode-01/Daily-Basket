import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';

/// Stitch Screen: Admin Biometric Login
/// ID: 93a5be138fb54218b971e68aa69f13b9
class AdminBiometricLoginScreen extends StatelessWidget {
  const AdminBiometricLoginScreen({super.key});

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
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F3133),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF8CFA93), width: 3),
                ),
                child: const Icon(Icons.fingerprint_rounded, size: 84, color: Color(0xFF8CFA93)),
              ),
              const SizedBox(height: 32),
              const Text('Biometric Passkey Sign-In', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Touch sensor or use FaceID / Windows Hello to authorize admin session', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFBECAB9), fontSize: 14)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  context.read<AdminAuthProvider>().verifyBiometricSuccess();
                  context.read<AdminAuthProvider>().completeAuthentication();
                  Navigator.pushReplacementNamed(context, '/admin/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006B23),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Authenticate & Access Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

