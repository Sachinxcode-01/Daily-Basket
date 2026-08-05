import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';
import '../../../../core/widgets/staggered_animated_card.dart';

/// Stitch Screen: Admin Google Sign-In
/// ID: a03e39cacde74e07a722413f8d0b6699
class AdminGoogleSigninScreen extends StatefulWidget {
  const AdminGoogleSigninScreen({super.key});

  @override
  State<AdminGoogleSigninScreen> createState() => _AdminGoogleSigninScreenState();
}

class _AdminGoogleSigninScreenState extends State<AdminGoogleSigninScreen> {
  bool _isAuthenticating = false;

  void _handleGoogleSignIn(BuildContext context) async {
    final nav = Navigator.of(context);
    final auth = context.read<AdminAuthProvider>();
    setState(() => _isAuthenticating = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      auth.login('admin@dailybasket.com', 'GoogleSSO_Token');
      nav.pushNamed('/admin/mfa-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Google Workspace SSO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: AnimationLimiter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Google Icon Emblem
                StaggeredAnimatedCard(
                  index: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2DD4BF).withValues(alpha: 0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2DD4BF).withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.g_mobiledata_rounded, size: 72, color: Color(0xFF2DD4BF)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Headline
                const StaggeredAnimatedCard(
                  index: 1,
                  child: Column(
                    children: [
                      Text(
                        'Single Sign-On Authentication',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Connecting to @dailybasket.com Google Workspace domain',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Account Selection Card
                StaggeredAnimatedCard(
                  index: 2,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF0F766E)),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF0F766E),
                          child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ananya Rao', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('ananya.rao@dailybasket.com', style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 12)),
                              SizedBox(height: 4),
                              Text('Super Admin • Dark Store Lead', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Security info banner
                StaggeredAnimatedCard(
                  index: 3,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.security_rounded, color: Color(0xFFF59E0B), size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Requires 2-Step Verification key approval on your authorized mobile device.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Authorize Button
                StaggeredAnimatedButton(
                  index: 4,
                  backgroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  onPressed: _isAuthenticating ? () {} : () => _handleGoogleSignIn(context),
                  child: _isAuthenticating
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                            SizedBox(width: 12),
                            Text('Authenticating Workspace Token…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user_rounded, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Authorize & Sign In with Google', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                ),
                const SizedBox(height: 14),

                // Switch Account Button
                StaggeredAnimatedButton(
                  index: 5,
                  backgroundColor: Colors.transparent,
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Use a Different Google Account', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
