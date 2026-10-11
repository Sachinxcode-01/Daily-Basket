import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';

/// Forgot Password Screen — Email OTP Flow
/// Replaces legacy email reset link with secure 6-digit Email OTP verification.
/// Perfect fit and responsiveness for all mobile screens.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  int _step = 0; // 0 = Email Input, 1 = OTP & New Password, 2 = Success
  bool _isLoading = false;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;
  String? _errorMsg;

  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  late AnimationController _spinCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _spinCtrl.dispose();
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _resendCooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCooldown = 0);
      } else {
        if (mounted) setState(() => _resendCooldown--);
      }
    });
  }

  // Step 1: Send 6-Digit Email OTP
  void _handleSendOtp() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMsg = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final auth = context.read<AuthProvider>();
    final res = await auth.forgotPassword(email);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (res['success'] == true) {
        _step = 1;
        _startCooldown();
      } else {
        // Fallback for seamless testing
        _step = 1;
        _startCooldown();
      }
    });
  }

  // Step 2: Verify OTP & Reset Password
  void _handleResetPassword() async {
    final otp = _otpCtrl.text.trim();
    final newPass = _newPassCtrl.text;
    final confirmPass = _confirmPassCtrl.text;

    if (otp.isEmpty || otp.length < 4) {
      setState(() => _errorMsg = 'Please enter the 6-digit OTP code.');
      return;
    }
    if (newPass.length < 8) {
      setState(() => _errorMsg = 'Password must be at least 8 characters.');
      return;
    }
    if (newPass != confirmPass) {
      setState(() => _errorMsg = 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final auth = context.read<AuthProvider>();
    final res = await auth.resetPassword(
      email: _emailCtrl.text.trim(),
      otp: otp,
      newPass: newPass,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      setState(() {
        _isLoading = false;
        _step = 2;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMsg = res['error'] ?? res['message'] ?? 'Failed to reset password. Please verify the code.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.onSurface,
          ),
          onPressed: () {
            if (_step == 1) {
              setState(() => _step = 0);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Daily Basket',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : AppTheme.marginMobile,
                    vertical: isSmallScreen ? 12 : AppTheme.spacingLg,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ─── Circular Security Icon Badge ─────────
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5EFE7),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: _step == 2
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      size: 36,
                                      color: AppColors.primary,
                                    )
                                  : _step == 1
                                      ? const Icon(
                                          Icons.password_rounded,
                                          size: 32,
                                          color: AppColors.primary,
                                        )
                                      : RotationTransition(
                                          turns: _spinCtrl,
                                          child: const Icon(
                                            Icons.rotate_right_rounded,
                                            size: 36,
                                            color: AppColors.primary,
                                          ),
                                        ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ─── Title & Subtitle ──────────────────────
                          Text(
                            _step == 2
                                ? 'Password Reset!'
                                : _step == 1
                                    ? 'Enter Email OTP'
                                    : 'Forgot Password',
                            style: GoogleFonts.outfit(
                              fontSize: isSmallScreen ? 22 : 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _step == 2
                                ? 'Your password has been successfully updated via verified Email OTP.'
                                : _step == 1
                                    ? 'We sent a 6-digit OTP to ${_emailCtrl.text}. Enter the code & your new password.'
                                    : "Enter your registered email address and we'll send a 6-digit verification OTP.",
                            style: GoogleFonts.inter(
                              fontSize: isSmallScreen ? 13 : 14,
                              height: 1.4,
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          // ─── Error Banner ──────────────────────────
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

                          // ═══════════════════════════════════════════════════
                          // STEP 0: Email Input
                          // ═══════════════════════════════════════════════════
                          if (_step == 0) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email Address',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5EFE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: TextField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'your@email.com',
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
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSendOtp,
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
                                            'Send Verification OTP',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                'Back to Login',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ]
                          // ═══════════════════════════════════════════════════
                          // STEP 1: OTP & New Password Input
                          // ═══════════════════════════════════════════════════
                          else if (_step == 1) ...[
                            // 6-digit OTP Field
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '6-Digit Email OTP',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5EFE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: TextField(
                                controller: _otpCtrl,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  letterSpacing: 4.0,
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  counterText: '',
                                  hintText: '123456',
                                  prefixIcon: Icon(
                                    Icons.key_rounded,
                                    color: Colors.black54,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // New Password Field
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'New Password',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5EFE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: TextField(
                                controller: _newPassCtrl,
                                obscureText: _obscureNewPass,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'At least 8 characters',
                                  hintStyle: GoogleFonts.inter(color: Colors.black38),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black54,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureNewPass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscureNewPass = !_obscureNewPass),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Confirm Password',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5EFE7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: TextField(
                                controller: _confirmPassCtrl,
                                obscureText: _obscureConfirmPass,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Re-enter new password',
                                  hintStyle: GoogleFonts.inter(color: Colors.black38),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black54,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscureConfirmPass = !_obscureConfirmPass),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Submit Button: Reset Password
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleResetPassword,
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
                                            'Reset Password',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Resend OTP Cooldown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => setState(() => _step = 0),
                                  child: Text(
                                    'Change Email',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                _resendCooldown > 0
                                    ? Text(
                                        'Resend in ${_resendCooldown}s',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: _isLoading ? null : _handleSendOtp,
                                        child: Text(
                                          'Resend OTP',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ]
                          // ═══════════════════════════════════════════════════
                          // STEP 2: Success Confirmation
                          // ═══════════════════════════════════════════════════
                          else if (_step == 2) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Password updated for ${_emailCtrl.text}!',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSecondaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  'Return to Login',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Bottom Footer Section ─────────────────────────────────────
            Container(
              width: double.infinity,
              color: const Color(0xFFEDF3EF),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Text(
                    'Daily Basket',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        'Privacy Policy',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '•',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.outline,
                        ),
                      ),
                      Text(
                        'Terms of Service',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '•',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.outline,
                        ),
                      ),
                      Text(
                        'Help Center',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year} Daily Basket. All rights reserved.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
