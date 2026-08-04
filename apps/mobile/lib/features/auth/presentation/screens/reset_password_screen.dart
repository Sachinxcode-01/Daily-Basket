import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Reset Password Screen — Exact User Mockup Specification
/// Matches:
/// - Top bar header with back arrow and centered "Daily Basket" text
/// - Main card container with circular security lock refresh badge
/// - Title: "Reset Password"
/// - Subtitle: "Please create a new password that you don't use on any other site."
/// - Field 1: "New Password" label, soft tinted background (#E5EFE7), lock icon, placeholder "••••••••", eye toggle icon
///   - Subtext under Field 1: "Must be at least 8 characters."
/// - Field 2: "Confirm New Password" label, soft tinted background (#E5EFE7), checkmark circle icon, placeholder "••••••••", eye toggle icon
/// - Primary dark green pill button: "Reset Password"
/// - Bottom footer container with "Daily Basket", Policy links, and Copyright notice
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;
  bool _isLoading = false;
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
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final newPass = _newPassCtrl.text;
    final confirmPass = _confirmPassCtrl.text;

    if (newPass.length < 8) {
      setState(() => _errorMsg = 'Password must be at least 8 characters long.');
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

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/success');
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

                          // ─── Title: Reset Password ──────────────────────
                          Text(
                            'Reset Password',
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
                            "Please create a new password that you don't use on any other site.",
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

                          // ─── Field 1: New Password ───────────────────────
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
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Must be at least 8 characters.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ─── Field 2: Confirm New Password ─────────────────
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Confirm New Password',
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
                                hintText: '••••••••',
                                hintStyle: GoogleFonts.inter(
                                  color: Colors.black38,
                                ),
                                prefixIcon: const Icon(
                                  Icons.check_circle_outline_rounded,
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
                                      _obscureConfirmPass =
                                          !_obscureConfirmPass),
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

                          // ─── Primary Dark Green Pill Button: Reset Password ──
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _handleResetPassword,
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
                                  : Text(
                                      'Reset Password',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
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
