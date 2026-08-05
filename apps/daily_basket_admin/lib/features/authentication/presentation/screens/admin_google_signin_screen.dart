import 'package:flutter/material.dart';

class AdminGoogleSigninScreen extends StatelessWidget {
  const AdminGoogleSigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.g_mobiledata_rounded, size: 84, color: Color(0xFF2DD4BF)),
              const SizedBox(height: 24),
              const Text('Google Workspace SSO', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Connecting to @dailybasket.com enterprise domain', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/admin/mfa-selection'),
                icon: const Icon(Icons.verified_user_rounded, color: Colors.white),
                label: const Text('Authorize Google Workspace Identity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
