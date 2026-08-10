import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';

/// Stitch Screen: Admin OTP Verification
/// ID: e14a10799e3041499c55ec974015bc15
class AdminOtpVerificationScreen extends StatefulWidget {
  const AdminOtpVerificationScreen({super.key});

  @override
  State<AdminOtpVerificationScreen> createState() => _AdminOtpVerificationScreenState();
}

class _AdminOtpVerificationScreenState extends State<AdminOtpVerificationScreen> {
  final _otpController = TextEditingController(text: '482109');
  bool _isVerifying = false;

  void _handleVerify() async {
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      context.read<AdminAuthProvider>().verifyOtp(_otpController.text);
      Navigator.pushNamed(context, '/admin/device-verification');
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 48, color: Color(0xFF8CFA93)),
            const SizedBox(height: 16),
            const Text('Enter 6-Digit Verification PIN', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Code sent to admin TOTP Authenticator / Mobile', style: TextStyle(color: Color(0xFFBECAB9), fontSize: 14)),
            const SizedBox(height: 32),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(color: Colors.white, fontSize: 32, letterSpacing: 12, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2F3133),
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF70DD7A))),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isVerifying ? null : _handleVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006B23),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isVerifying
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('Authorizing Device…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : const Text('Verify Code & Authorize Device', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

