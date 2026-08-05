import 'package:flutter/material.dart';

class AdminOtpVerificationScreen extends StatefulWidget {
  const AdminOtpVerificationScreen({super.key});

  @override
  State<AdminOtpVerificationScreen> createState() => _AdminOtpVerificationScreenState();
}

class _AdminOtpVerificationScreenState extends State<AdminOtpVerificationScreen> {
  final _otpController = TextEditingController(text: '482109');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 48, color: Color(0xFF2DD4BF)),
            const SizedBox(height: 16),
            const Text('Enter 6-Digit Verification PIN', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Code sent to admin TOTP Authenticator / Mobile', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
            const SizedBox(height: 32),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(color: Colors.white, fontSize: 32, letterSpacing: 12, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/device-verification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Verify Code & Authorize Device', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
