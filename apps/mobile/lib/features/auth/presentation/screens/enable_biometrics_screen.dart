import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Enable Biometrics Screen — Exact Google Stitch Specification
/// Matches:
/// - Top App Bar with back arrow & Daily Basket title
/// - Biometric Fingerprint & Face ID illustration canvas with pulsing ambient rings
/// - Heading: "Enable Biometric Login"
/// - Subtitle: "Use Face ID or Touch ID for faster, more secure access..."
/// - Primary Action Pill: "Enable Now"
/// - Secondary Action Pill: "Maybe Later"
class EnableBiometricsScreen extends StatefulWidget {
  const EnableBiometricsScreen({super.key});

  @override
  State<EnableBiometricsScreen> createState() =>
      _EnableBiometricsScreenState();
}

class _EnableBiometricsScreenState extends State<EnableBiometricsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _handleEnableNow() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/customer/home');
    }
  }

  void _handleMaybeLater() {
    Navigator.of(context).pushReplacementNamed('/customer/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Basket',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.marginMobile,
              vertical: AppTheme.spacingLg,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // ─── Biometric Illustration Canvas ─────────────────────────
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Pulsing Glow Ring
                        AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (context, child) => Container(
                            width: 190 + (_pulseCtrl.value * 10),
                            height: 190 + (_pulseCtrl.value * 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        // Inner Ring
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                        ),

                        // Central Glassmorphism Fingerprint Badge
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.fingerprint_rounded,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        // Floating Face ID Badge
                        Positioned(
                          top: 10,
                          right: 18,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCE5DD),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.face_rounded,
                                size: 22,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ─── Text Content ───────────────────────────────────────────
                  Text(
                    'Enable Biometric Login',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Use Face ID or Touch ID for faster, more secure access to your Daily Basket.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 22 / 15,
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 36),

                  // ─── Call to Actions ────────────────────────────────────────

                  // Primary Button: Enable Now
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleEnableNow,
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
                              'Enable Now',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Secondary Button: Maybe Later
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: _handleMaybeLater,
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFDCE5DD),
                        foregroundColor: AppColors.primary,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Maybe Later',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
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
    );
  }
}
