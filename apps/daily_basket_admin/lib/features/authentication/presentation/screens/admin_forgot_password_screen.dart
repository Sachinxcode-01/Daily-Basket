import 'package:flutter/material.dart';

/// Stitch Screen: Admin Forgot Password
/// ID: 2a37a3fe8c6045048e88eb54f7a271a4
class AdminForgotPasswordScreen extends StatefulWidget {
  const AdminForgotPasswordScreen({super.key});

  @override
  State<AdminForgotPasswordScreen> createState() => _AdminForgotPasswordScreenState();
}

class _AdminForgotPasswordScreenState extends State<AdminForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'admin@dailybasket.com');
  bool _isSending = false;
  bool _tokenSent = false;

  void _handleResetRequest() async {
    if (_emailController.text.contains('@')) {
      setState(() => _isSending = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _isSending = false;
          _tokenSent = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            const Icon(Icons.password_rounded, size: 48, color: Color(0xFF8CFA93)),
            const SizedBox(height: 16),
            const Text('Forgot Password', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Enter admin email to receive single-use reset token', style: TextStyle(color: Color(0xFFBECAB9), fontSize: 14)),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Admin Work Email',
                labelStyle: const TextStyle(color: Color(0xFFBECAB9)),
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF8CFA93)),
                filled: true,
                fillColor: const Color(0xFF2F3133),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF70DD7A))),
              ),
            ),
            const SizedBox(height: 24),
            if (_tokenSent)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF006B23).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF078730)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: Color(0xFF8CFA93)),
                    SizedBox(width: 12),
                    Expanded(child: Text('Reset token sent to your work email inbox.', style: TextStyle(color: Colors.white, fontSize: 13))),
                  ],
                ),
              ),

            ElevatedButton(
              onPressed: _isSending
                  ? null
                  : () {
                      if (_tokenSent) {
                        Navigator.pushNamed(context, '/admin/reset-password');
                      } else {
                        _handleResetRequest();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006B23),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSending
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('Dispatching Token…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : Text(
                      _tokenSent ? 'Proceed to Reset Password' : 'Send Password Reset Token',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

