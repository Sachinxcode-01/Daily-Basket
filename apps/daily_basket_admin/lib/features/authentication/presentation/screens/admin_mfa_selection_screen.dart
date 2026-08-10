import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';

/// Stitch Screen: Admin MFA Selection
/// ID: 481e31130e7f4f4abe8c43d8e77f7a3d
class AdminMfaSelectionScreen extends StatelessWidget {
  const AdminMfaSelectionScreen({super.key});

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
            const Icon(Icons.phonelink_lock_rounded, size: 48, color: Color(0xFF8CFA93)),
            const SizedBox(height: 16),
            const Text('MFA Selection', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Choose Multi-Factor Authentication Method', style: TextStyle(color: Color(0xFFBECAB9), fontSize: 14)),
            const SizedBox(height: 32),
            _buildOption(
              context,
              title: 'Authenticator App (TOTP)',
              subtitle: 'Google Authenticator / 1Password / Authy',
              icon: Icons.security_rounded,
              onTap: () {
                context.read<AdminAuthProvider>().selectMfaType(MfaType.totp);
                Navigator.pushNamed(context, '/admin/otp-verification');
              },
            ),
            const SizedBox(height: 16),
            _buildOption(
              context,
              title: 'SMS OTP Code',
              subtitle: 'Send 6-digit PIN to registered mobile',
              icon: Icons.sms_outlined,
              onTap: () {
                context.read<AdminAuthProvider>().selectMfaType(MfaType.sms);
                Navigator.pushNamed(context, '/admin/otp-verification');
              },
            ),
            const SizedBox(height: 16),
            _buildOption(
              context,
              title: 'Security Key / WebAuthn Passkey',
              subtitle: 'Biometric hardware key',
              icon: Icons.vpn_key_outlined,
              onTap: () {
                context.read<AdminAuthProvider>().selectMfaType(MfaType.biometric);
                Navigator.pushNamed(context, '/admin/biometric-login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2F3133),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6E7A6C)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF006B23).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF8CFA93)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFFBECAB9), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}

