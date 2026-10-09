import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

/// Login Screen — Exact User Mockup Specification
/// Matches:
/// - Green circular badge with white shopping basket icon + "Daily Basket" text
/// - Title: "Welcome back"
/// - Subtitle: "Enter your details to access your account."
/// - Uppercase Labels: "EMAIL ADDRESS" and "PASSWORD"
/// - Soft tinted input fields (#E5EFE7 background with rounded corners)
/// - Right-aligned "Forgot Password?" green link
/// - Primary dark green pill button: "Login ->" with right arrow icon
/// - Footer text: "Don't have an account? Sign up"
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final pass = _passController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMsg = 'Please enter a valid email address.');
      return;
    }
    if (pass.isEmpty) {
      setState(() => _errorMsg = 'Please enter your password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final auth = context.read<AuthProvider>();
    final res = await auth.loginEmail(email: email, password: pass);

    if (!mounted) return;

    if (res['success'] == true) {
      final user = res['user'];
      if (user != null) {
        context.read<UserProvider>().updatePersonalInfo(
              name: user['name'] ?? user['fullName'] ?? 'Daily Basket Customer',
              email: user['email'] ?? email,
              phone: user['phone'] ?? user['phoneNumber'] ?? '+91 98765 43210',
            );
      }
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/customer/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMsg = res['error'] ?? res['message'] ?? 'Invalid email address or password.';
      });
    }
  }

  void _handleGoogleLogin() async {
    final typedEmail = _emailController.text.trim();
    if (typedEmail.isNotEmpty && typedEmail.contains('@')) {
      await _executeGoogleLogin(
        email: typedEmail,
        name: typedEmail.split('@').first,
      );
      return;
    }

    // Show Google Account Picker Modal with real-time selection
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.g_mobiledata_rounded, color: Color(0xFF4285F4), size: 36),
                const SizedBox(width: 8),
                Text(
                  'Sign in with Google',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Choose an account to continue to Daily Basket',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE5EFE7),
                child: Text('S', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              title: Text('Sachin Kumar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text('sachiii8827@gmail.com', style: GoogleFonts.inter(fontSize: 13)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.of(ctx).pop();
                _executeGoogleLogin(email: 'sachiii8827@gmail.com', name: 'Sachin Kumar');
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE5EFE7),
                child: Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary),
              ),
              title: Text('Use another email', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text('Enter custom email address in login field', style: GoogleFonts.inter(fontSize: 13)),
              trailing: const Icon(Icons.edit_outlined, size: 18),
              onTap: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Type your email above and tap "Continue with Google"'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _executeGoogleLogin({
    required String email,
    required String name,
  }) async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final auth = context.read<AuthProvider>();
    final res = await auth.googleLogin(
      email: email,
      name: name,
      avatarUrl: 'https://lh3.googleusercontent.com/a/default-user',
    );

    if (!mounted) return;

    if (res['success'] == true) {
      final user = res['user'];
      if (user != null) {
        context.read<UserProvider>().updatePersonalInfo(
              name: user['name'] ?? user['fullName'] ?? name,
              email: user['email'] ?? email,
              phone: user['phone'] ?? '+91 98765 43210',
            );
      }
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/customer/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMsg = res['error'] ?? res['message'] ?? 'Google sign-in failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.marginMobile,
              vertical: AppTheme.spacingLg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ─── Brand Header: Green Circular Badge + Daily Basket ──────
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_basket_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Daily Basket',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ─── Main White Card Container ──────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // Title: Welcome back
                        Text(
                          'Welcome back',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Enter your details to access your account.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Error Banner
                        if (_errorMsg != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMsg!,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // ─── EMAIL ADDRESS Field ──────────────────────────
                        Text(
                          'EMAIL ADDRESS',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5EFE7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'name@example.com',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.black38,
                              ),
                              prefixIcon: const Icon(
                                Icons.mail_outline_rounded,
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ─── PASSWORD Field ───────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PASSWORD',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5EFE7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: _passController,
                            obscureText: _obscurePass,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.black38,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.black54,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.black54,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePass = !_obscurePass),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ─── Primary Dark Green Pill Button: Login -> ────────
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ─── Divider: OR ──────────────────────────────────
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ─── Continue with Google ─────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _handleGoogleLogin,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.outlineVariant),
                              shape: const StadiumBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.g_mobiledata_rounded,
                                  size: 24,
                                  color: Color(0xFF4285F4),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Continue with Google',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ─── Continue with Phone OTP ──────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () {
                              Navigator.of(context).pushNamed('/auth/otp');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.outlineVariant),
                              shape: const StadiumBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone_iphone_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Continue with Phone OTP',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        const SizedBox(height: 28),

                        // ─── Footer: Don't have an account? Sign up ──────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

