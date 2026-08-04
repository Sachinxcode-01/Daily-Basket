import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../../core/theme/app_theme.dart';

/// MFA Verification Screen (Verify Your Identity) — Mobile Only Exact Specification
/// Matches:
/// - Top white rounded logo badge card with Daily Basket logo
/// - Title: "Verify Your Identity"
/// - Subtitle: "Enter the 6-digit code sent to your mobile device."
/// - 6-Digit OTP Box Grid (Active blue outline box with blinking cursor)
/// - Sage green "Verify" button
/// - "Didn't receive a code? Resend Code (28s)" countdown timer
/// - Custom 3x4 bottom numeric keypad grid (1-9, 0, backspace key)
class MfaVerificationScreen extends StatefulWidget {
  final String destination;

  const MfaVerificationScreen({
    super.key,
    this.destination = 'your mobile device',
  });

  @override
  State<MfaVerificationScreen> createState() => _MfaVerificationScreenState();
}

class _MfaVerificationScreenState extends State<MfaVerificationScreen> {
  String _otpCode = '1'; // Pre-filled '1' matching user screenshot!
  int _countdown = 28;
  Timer? _timer;
  bool _isVerifying = false;

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleKeyTap(String value) {
    if (_otpCode.length < 6) {
      setState(() {
        _otpCode += value;
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
      });
    }
  }

  void _handleVerify() async {
    if (_otpCode.length < 6) return;
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isVerifying = false);
      Navigator.of(context).pushReplacementNamed('/customer/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Main Content Area ──────────────────────────────────────────
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

                        // ─── Top White Logo Badge Card ─────────────────────
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

                        // ─── Title: Verify Your Identity ────────────────────
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

                        // ─── Subtitle ───────────────────────────────────────
                        Text(
                          'Enter the 6-digit code sent to ${widget.destination}.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF64748B),
                            height: 20 / 14,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // ─── 6-Digit OTP Box Grid ───────────────────────────
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
                                      ? const Color(0xFF2563EB) // Focused Blue
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

                        const SizedBox(height: 32),

                        // ─── Primary Sage Green Verify Button ───────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                _isVerifying || _otpCode.length < 6
                                    ? null
                                    : _handleVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF72AB8B),
                              disabledBackgroundColor:
                                  const Color(0xFF72AB8B).withValues(alpha: 0.65),
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
                                    'Verify',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ─── Resend Code Subtext Row ────────────────────────
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
                                    onTap: _startTimer,
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

            // ─── Custom 3x4 On-Screen Numeric Keypad ─────────────────────────
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
        // Empty Left Key
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(height: 52),
          ),
        ),
        // Key 0
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
        // Backspace Key
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

/// Blinking Cursor Widget for Active Input Box
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
