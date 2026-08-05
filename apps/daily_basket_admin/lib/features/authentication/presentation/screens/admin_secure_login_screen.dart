import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_auth_provider.dart';
import '../../../../core/widgets/staggered_animated_card.dart';

/// Stitch Screen: Admin Secure Login
/// ID: 6caea05de61946a88ebf0e431a848aac
class AdminSecureLoginScreen extends StatefulWidget {
  const AdminSecureLoginScreen({super.key});

  @override
  State<AdminSecureLoginScreen> createState() => _AdminSecureLoginScreenState();
}

class _AdminSecureLoginScreenState extends State<AdminSecureLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@dailybasket.com');
  final _passwordController = TextEditingController(text: 'Admin@123456');
  bool _obscurePassword = true;
  bool _rememberDevice = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) {
        context.read<AdminAuthProvider>().login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
        Navigator.pushNamed(context, '/admin/mfa-selection');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Admin Secure Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: AnimationLimiter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // Emblem Header
                  StaggeredAnimatedCard(
                    index: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0F766E)),
                        ),
                        child: const Icon(Icons.shield_rounded, size: 48, color: Color(0xFF2DD4BF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Headline
                  const StaggeredAnimatedCard(
                    index: 1,
                    child: Column(
                      children: [
                        Text(
                          'Enterprise Credentials',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Enter workspace email with assigned RBAC admin permissions',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email Field
                  StaggeredAnimatedCard(
                    index: 2,
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Email is required';
                        if (!val.contains('@')) return 'Enter a valid work email';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Admin Work Email',
                        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2DD4BF)),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF14B8A6)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  StaggeredAnimatedCard(
                    index: 3,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Password is required';
                        if (val.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF2DD4BF)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF14B8A6)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Remember device & Forgot password
                  StaggeredAnimatedCard(
                    index: 4,
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberDevice,
                          activeColor: const Color(0xFF0F766E),
                          checkColor: Colors.white,
                          onChanged: (v) => setState(() => _rememberDevice = v ?? true),
                        ),
                        const Text('Remember device', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/admin/forgot-password'),
                          child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Action Button
                  StaggeredAnimatedButton(
                    index: 5,
                    backgroundColor: const Color(0xFF0F766E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: _isLoading ? () {} : _handleLogin,
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                              SizedBox(width: 12),
                              Text('Verifying Credentials…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Verify Credentials & Proceed', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                  ),
                  const SizedBox(height: 14),

                  // Biometric Unlock Button
                  StaggeredAnimatedButton(
                    index: 6,
                    backgroundColor: const Color(0xFF1E293B),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    onPressed: () => Navigator.pushNamed(context, '/admin/biometric-login'),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fingerprint_rounded, color: Color(0xFF2DD4BF)),
                        SizedBox(width: 8),
                        Text('Biometric Passkey Sign-In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SSO Alternate Link
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/admin/google-signin'),
                      child: const Text(
                        'Or Sign In with Google Workspace SSO',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
