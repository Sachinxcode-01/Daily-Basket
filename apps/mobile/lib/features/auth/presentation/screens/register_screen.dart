import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/user_provider.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';


/// Create Account Screen — Google Stitch Design System & User Mockup Specification
/// Matches exact layout provided:
/// - Top branded Daily Basket logo card
/// - "Daily Basket" brand title
/// - "Create Account" Outfit heading
/// - Subtitle: "Join us to start filling your basket with fresh, organic goods."
/// - Form fields with leading icons: Full Name, Email, Password, Confirm Password
/// - Primary green pill button with active touch scale animation
/// - Footer link to Login
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _isLoading = false;
  String? _errorMsg;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    setState(() => _errorMsg = null);

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    final confirm = _confirmPassCtrl.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMsg = 'Please enter your full name');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMsg = 'Please enter a valid email address');
      return;
    }
    if (pass.length < 6) {
      setState(() => _errorMsg = 'Password must be at least 6 characters');
      return;
    }
    if (pass != confirm) {
      setState(() => _errorMsg = 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Ambient Organic Blob Background ────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withValues(alpha: 0.20),
              ),
            ),
          ),

          // ─── Content ──────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.marginMobile,
                  vertical: AppTheme.spacingLg,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ─── Logo Card ─────────────────────────────────
                          Container(
                            width: 64,
                            height: 64,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppTheme.level1,
                              border: Border.all(
                                color: AppColors.outlineVariant
                                    .withValues(alpha: 0.20),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/daily_basket_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Brand Title: "Daily Basket"
                          Text(
                            'Daily Basket',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingLg),

                          // Heading: "Create Account"
                          Text(
                            'Create Account',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'Join us to start filling your basket with fresh, organic goods.',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 22 / 15,
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppTheme.spacingXl),

                          // Error Message Alert
                          if (_errorMsg != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(16),
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
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLg),
                          ],

                          // ─── Input Form Fields ─────────────────────────

                          // Full Name
                          _buildLabel('Full Name'),
                          _buildTextField(
                            controller: _nameCtrl,
                            hintText: 'Jane Doe',
                            icon: Icons.person_outline_rounded,
                          ),

                          const SizedBox(height: AppTheme.spacingMd),

                          // Email Address
                          _buildLabel('Email Address'),
                          _buildTextField(
                            controller: _emailCtrl,
                            hintText: 'jane@example.com',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: AppTheme.spacingMd),

                          // Password
                          _buildLabel('Password'),
                          _buildTextField(
                            controller: _passCtrl,
                            hintText: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePass,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.onSurfaceVariant,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingMd),

                          // Confirm Password
                          _buildLabel('Confirm Password'),
                          _buildTextField(
                            controller: _confirmPassCtrl,
                            hintText: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePass,
                          ),

                          const SizedBox(height: AppTheme.spacingXl),

                          // ─── Primary Create Account Button ───────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
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

                                  : Text(
                                      'Create Account',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

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

                          const SizedBox(height: 16),

                          // ─── Sign up with Google ──────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () async {
                                setState(() => _isLoading = true);
                                if (mounted) {
                                  try {
                                    context.read<UserProvider>().updatePersonalInfo(
                                      name: _nameCtrl.text.trim().isNotEmpty
                                          ? _nameCtrl.text.trim()
                                          : 'Sachin Kumar',
                                      email: _emailCtrl.text.trim().isNotEmpty
                                          ? _emailCtrl.text.trim()
                                          : 'sachiii8827@gmail.com',
                                      phone: '+91 98765 43210',
                                    );
                                  } catch (_) {}
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Account connected with Google credentials (Sachin Kumar)',
                                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                                    ),
                                    backgroundColor: AppColors.primary,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                                await Future.delayed(const Duration(milliseconds: 500));
                                if (!mounted) return;
                                setState(() => _isLoading = false);
                                Navigator.of(context).pushReplacementNamed('/customer/home');
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.outlineVariant.withValues(alpha: 0.8),
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.g_mobiledata_rounded,
                                    size: 26,
                                    color: Color(0xFF4285F4),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sign up with Google',
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

                          const SizedBox(height: AppTheme.spacingXl),


                          // ─── Footer Link: Login ────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                ),
                                child: Text(
                                  'Log in',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.outline,
          ),
          prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
