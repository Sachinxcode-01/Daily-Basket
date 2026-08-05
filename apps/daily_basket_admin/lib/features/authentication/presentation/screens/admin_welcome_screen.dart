import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/widgets/staggered_animated_card.dart';

/// Stitch Screen: Admin Welcome Screen
/// ID: 9696fa8e284f4eb092f842f851ab73a7
class AdminWelcomeScreen extends StatelessWidget {
  const AdminWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),

                // Hero Emblem
                StaggeredAnimatedCard(
                  index: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0F766E), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F766E).withValues(alpha: 0.35),
                            blurRadius: 28,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.storefront_rounded, size: 76, color: Color(0xFF2DD4BF)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title & Subtitle
                StaggeredAnimatedCard(
                  index: 1,
                  child: Column(
                    children: [
                      const Text(
                        'Enterprise Admin Portal',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Manage Dark Stores, Real-time Logistics, Inventory, GST Compliance, and AI Telemetry.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 20),

                      // Feature pills
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPill('⚡ 10-Min SLA'),
                          const SizedBox(width: 8),
                          _buildPill('📦 Stock & Expiry'),
                          const SizedBox(width: 8),
                          _buildPill('🛡️ RBAC MFA'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Action Buttons
                StaggeredAnimatedButton(
                  index: 2,
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  onPressed: () => Navigator.pushNamed(context, '/admin/secure-login'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text('Secure SSO & Password Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                StaggeredAnimatedButton(
                  index: 3,
                  backgroundColor: const Color(0xFF1E293B),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: () => Navigator.pushNamed(context, '/admin/google-signin'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata_rounded, size: 30, color: Color(0xFF2DD4BF)),
                      SizedBox(width: 8),
                      Text('Google Workspace SSO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                StaggeredAnimatedButton(
                  index: 4,
                  backgroundColor: Colors.transparent,
                  borderSide: BorderSide(color: const Color(0xFF2DD4BF).withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: () => Navigator.pushNamed(context, '/admin/biometric-login'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fingerprint_rounded, size: 20, color: Color(0xFF2DD4BF)),
                      SizedBox(width: 8),
                      Text('Biometric Passkey Unlock', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2DD4BF))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Footer compliance notice
                const Text(
                  'Authorized Personnel Only • IP Address Logged & Monitored',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }
}
