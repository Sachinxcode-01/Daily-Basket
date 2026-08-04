import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../../core/theme/app_theme.dart';

/// Account Locked Screen — Exact Google Stitch Specification
/// Matches:
/// - Red error container top header with pulsing lock badge
/// - Title: "Account Temporarily Locked"
/// - Message: "Due to multiple unsuccessful login attempts, your account is locked for 30 minutes..."
/// - Live 30-minute countdown timer box ("29:59 remaining")
/// - Warning info box callout
/// - Action Buttons: "Contact Support" & "Go to Help Center"
/// - Bottom "Daily Basket" footer branding
class AccountLockedScreen extends StatefulWidget {
  const AccountLockedScreen({super.key});

  @override
  State<AccountLockedScreen> createState() => _AccountLockedScreenState();
}

class _AccountLockedScreenState extends State<AccountLockedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  int _secondsRemaining = 1799; // 29m 59s
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSec) {
    final mins = totalSec ~/ 60;
    final secs = totalSec % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  // Main Card Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.20),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // ─── Red Error Header Area ─────────────────────────
                        Container(
                          width: double.infinity,
                          color: const Color(0xFFFFDAD6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 32,
                          ),
                          child: Column(
                            children: [
                              // Pulsing Lock Circle Badge
                              AnimatedBuilder(
                                animation: _pulseCtrl,
                                builder: (context, child) => Container(
                                  width: 72 + (_pulseCtrl.value * 6),
                                  height: 72 + (_pulseCtrl.value * 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBA1A1A),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFBA1A1A)
                                            .withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.lock_rounded,
                                      size: 38,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                'Account Temporarily Locked',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF93000A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // ─── Main Content Area ──────────────────────────────
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'Due to multiple unsuccessful login attempts, your account is locked for 30 minutes for security.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  height: 20 / 14,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              // Countdown Timer Box
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEF0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.timer_outlined,
                                      size: 20,
                                      color: Color(0xFF5A5C5C),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTime(_secondsRemaining),
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'remaining',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Warning Info Callout Box
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E2E5),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      size: 20,
                                      color: Color(0xFF3F4A3D),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'If you did not attempt to log in, your account may be at risk. Please contact our support team immediately to secure your account.',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          height: 17 / 12,
                                          color: const Color(0xFF3F4A3D),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Action Buttons
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Connecting to support...',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Contact Support',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFDCE5DD),
                                    foregroundColor: const Color(0xFF404943),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Go to Help Center',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF404943),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom Branding
                  Text(
                    'Daily Basket',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.50),
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
