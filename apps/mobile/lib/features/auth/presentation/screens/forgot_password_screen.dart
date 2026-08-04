import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Forgot Password Screen — Exact User Mockup Specification
/// Matches:
/// - Top bar header with back arrow and centered "Daily Basket" text
/// - Main card container with circular security lock refresh badge
/// - Title: "Forgot Password"
/// - Subtitle: "Enter the email address associated with your account..."
/// - Input field: "Email Address" label, soft tinted background (#E5EFE7), mail icon, placeholder "your@email.com"
/// - Primary dark green pill button: "Send Reset Link ->"
/// - Link: "<- Back to Login"
/// - Bottom footer container with "Daily Basket", Policy links, and Copyright notice
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isSent = false;
  String? _errorMsg;

  late AnimationController _spinCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _handleSendResetLink() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMsg = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.of(context).pop(),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.marginMobile,
                    vertical: AppTheme.spacingLg,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Container(
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
                          color: AppColors.outlineVariant
                              .withValues(alpha: 0.20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ─── Circular Security Lock Refresh Badge ─────────
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5EFE7),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: RotationTransition(
                                turns: _spinCtrl,
                                child: const Icon(
                                  Icons.rotate_right_rounded,
                                  size: 36,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ─── Title: Forgot Password ──────────────────────
                          Text(
                            'Forgot Password',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          // ─── Subtitle ────────────────────────────────────
                          Text(
                            "Enter the email address associated with your account and we'll send you a link to reset your password.",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 20 / 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
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

                          if (_isSent) ...[
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
                                      'Reset link sent to ${_emailCtrl.text}!',
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
                          ] else ...[
                            // ─── Email Address Input Field ──────────────────
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

                            // ─── Primary Pill Button: Send Reset Link -> ────
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed:
                                    _isLoading ? null : _handleSendResetLink,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Send Reset Link',
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

                            // ─── Back to Login Link ────────────────────────
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
                vertical: 24,
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
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 6),
                  Text(
                    '© 2024 Daily Basket. All rights reserved.',
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
