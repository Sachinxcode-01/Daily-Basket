import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/user_provider.dart';

/// Mobile Phone & Email OTP Verification Screen — Realtime Verification
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final bool isEmailOtp;

  const OtpScreen({
    super.key,
    this.phoneNumber = '+91 98765 43210',
    this.email = 'customer@dailybasket.com',
    this.isEmailOtp = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otpCode = '';
  int _countdown = 28;
  Timer? _timer;
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = 28);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _resendCode() async {
    _startTimer();
    final auth = context.read<AuthProvider>();
    if (widget.isEmailOtp) {
      await auth.sendEmailOtp(widget.email);
    } else {
      await auth.requestPhoneOtp(widget.phoneNumber);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEmailOtp
              ? 'New OTP code sent to ${widget.email}'
              : 'New OTP code sent to ${widget.phoneNumber}'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleKeyTap(String value) {
    if (_otpCode.length < 6) {
      setState(() {
        _otpCode += value;
        _errorMessage = null;
      });
      if (_otpCode.length == 6) {
        _handleVerify();
      }
    }
  }

  void _handleBackspace() {
    if (_otpCode.isNotEmpty) {
      setState(() {
        _otpCode = _otpCode.substring(0, _otpCode.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _handleVerify() async {
    if (_otpCode.length < 6) return;
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthProvider>();
    Map<String, dynamic> res;

    if (widget.isEmailOtp) {
      res = await auth.verifyEmailOtp(email: widget.email, otp: _otpCode);
    } else {
      res = await auth.verifyPhoneOtp(phone: widget.phoneNumber, otp: _otpCode);
    }

    if (!mounted) return;

    if (res['success'] == true) {
      final user = res['user'];
      if (user != null) {
        context.read<UserProvider>().updatePersonalInfo(
              name: user['name'] ?? user['fullName'] ?? 'Daily Basket Customer',
              email: user['email'] ?? widget.email,
              phone: user['phone'] ?? widget.phoneNumber,
            );
      }
      setState(() => _isVerifying = false);
      Navigator.of(context).pushReplacementNamed('/customer/home');
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage = res['error'] ?? res['message'] ?? 'Invalid 6-digit OTP code. Try 123456.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.marginMobile,
                  vertical: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // Top White Logo Badge Card
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.04),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_basket_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Daily Basket',
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Title: Verify Your Identity
                        Text(
                          'Verify Your Identity',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        // Subtitle
                        Text(
                          widget.isEmailOtp
                              ? 'Enter the 6-digit code sent to ${widget.email}'
                              : 'Enter the 6-digit code sent to ${widget.phoneNumber}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                            height: 20 / 14,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFFFCDD2)),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFFD32F2F),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Quick Fill Demo Pin Pill
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _otpCode = widget.isEmailOtp ? '482109' : '123456';
                              _errorMessage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              '⚡ Tap to fill Test PIN: ${widget.isEmailOtp ? "482109" : "123456"}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 6-Digit OTP Box Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            final char =
                                index < _otpCode.length ? _otpCode[index] : '';
                            final isActive = index == _otpCode.length ||
                                (index == 5 && _otpCode.length == 6);

                            return Container(
                              width: 48,
                              height: 56,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isActive
                                      ? const Color(0xFF2563EB)
                                      : Colors.black26,
                                  width: isActive ? 2.0 : 1.0,
                                ),
                              ),
                              child: Center(
                                child: char.isNotEmpty
                                    ? Text(
                                        char,
                                        style: GoogleFonts.inter(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E293B),
                                        ),
                                      )
                                    : isActive
                                        ? const _BlinkingCursor()
                                        : Text(
                                            '·',
                                            style: GoogleFonts.inter(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black38,
                                            ),
                                          ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 28),

                        // Primary Green Verify Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                _isVerifying || _otpCode.length < 6
                                    ? null
                                    : _handleVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor:
                                  AppColors.primary.withValues(alpha: 0.5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isVerifying
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Verify & Continue',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Resend Code Subtext Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive a code? ",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            _countdown > 0
                                ? Text(
                                    'Resend Code (${_countdown}s)',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: _resendCode,
                                    child: Text(
                                      'Resend Code',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
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

            // Custom 3x4 On-Screen Numeric Keypad
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 8),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 8),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 8),
                  _buildBottomKeypadRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys
          .map((key) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    elevation: 0.5,
                    child: InkWell(
                      onTap: () => _handleKeyTap(key),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Center(
                          child: Text(
                            key,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildBottomKeypadRow() {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(height: 52),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              elevation: 0.5,
              child: InkWell(
                onTap: () => _handleKeyTap('0'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: Text(
                      '0',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: _handleBackspace,
                borderRadius: BorderRadius.circular(14),
                child: const SizedBox(
                  height: 52,
                  child: Center(
                    child: Icon(
                      Icons.backspace_outlined,
                      size: 22,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 2,
        height: 24,
        color: const Color(0xFF2563EB),
      ),
    );
  }
}
