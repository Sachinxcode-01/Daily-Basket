import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
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

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/customer/home');
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
