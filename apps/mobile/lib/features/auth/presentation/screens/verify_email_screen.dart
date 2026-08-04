import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Verify Your Email Screen — Exact User Mockup Specification
/// Matches:
/// - Top "Daily Basket" brand title
/// - White card container with rounded corners (28px radius)
/// - Green envelope line-art with paper plane flying illustration
/// - Title: "Verify your email"
/// - Subtitle: "We've sent a verification link to your email address. Please check your inbox."
/// - Primary action pill button: "Open Email App" with open_in_new icon
/// - Secondary action pill button: "Resend Link" (light green-gray pill)
/// - Footer text: "Didn't receive it? Check your spam folder or contact support."
class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    this.email = 'jane@example.com',
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _planeCtrl;
  late Animation<double> _planeAnim;

  bool _isResending = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _planeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _planeAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _planeCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _planeCtrl.dispose();
    super.dispose();
  }

  void _openEmailApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening default mail app...',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resendLink() async {
    setState(() {
      _isResending = true;
      _statusMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isResending = false;
        _statusMessage = 'Verification link resent successfully!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle dot background grid simulation
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 16,
                ),
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
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
                    children: [
                      // ─── Brand Header: "Daily Basket" ─────────────────────
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          'Daily Basket',
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // ─── Main White Card (28px Radius) ────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 36,
                        ),
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
                          children: [
                            // ─── Envelope with Paper Plane Graphic ──────────
                            SizedBox(
                              width: 140,
                              height: 120,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Green Line-Art Envelope
                                  Positioned(
                                    bottom: 0,
                                    child: CustomPaint(
                                      size: const Size(90, 60),
                                      painter: _LineEnvelopePainter(),
                                    ),
                                  ),
                                  // Floating Green Paper Plane
                                  AnimatedBuilder(
                                    animation: _planeAnim,
                                    builder: (context, child) => Positioned(
                                      top: 10 + _planeAnim.value,
                                      right: 14,
                                      child: child!,
                                    ),
                                    child: Transform.rotate(
                                      angle: -0.2,
                                      child: const Icon(
                                        Icons.send_rounded,
                                        size: 32,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ─── Title: "Verify your email" ─────────────────
                            Text(
                              'Verify your email',
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            // ─── Subtitle ───────────────────────────────────
                            Text(
                              "We've sent a verification link to your email address. Please check your inbox.",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                height: 22 / 15,
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            if (_statusMessage != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _statusMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],

                            const SizedBox(height: 28),

                            // ─── Action Buttons ──────────────────────────────

                            // Primary Dark Green Pill Button: Open Email App
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _openEmailApp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: const StadiumBorder(),
                                  elevation: 0,
                                ),
                                icon: const Icon(
                                  Icons.open_in_new_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  'Open Email App',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Secondary Light Pill Button: Resend Link
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: TextButton(
                                onPressed: _isResending ? null : _resendLink,
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFE5EFE7),
                                  foregroundColor: const Color(0xFF1E293B),
                                  shape: const StadiumBorder(),
                                ),
                                child: _isResending
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF1E293B),
                                        ),
                                      )
                                    : Text(
                                        'Resend Link',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1E293B),
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ─── Footer Notice ─────────────────────────────
                            Text(
                              "Didn't receive it? Check your spam folder or contact support.",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 18 / 13,
                                color: AppColors.onSurfaceVariant
                                    .withValues(alpha: 0.80),
                              ),
                              textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}

/// Custom Painter for Green Line-Art Envelope Graphic
class _LineEnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF078730)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, paint);

    final path = Path()
      ..moveTo(2, 2)
      ..lineTo(size.width / 2, size.height * 0.6)
      ..lineTo(size.width - 2, 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
