import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'ready_to_shop_screen.dart';

/// Notification Permission Screen — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/stay_updated/
///
/// Background: #f9f9fc + gradient from secondary-container/20 at bottom
/// Header: back button (left), transparent
/// Illustration: 3D notification bell — notification icon, 256×256
///    Glow blob: primary-container/20, blur
/// Title: "Stay Updated" — Outfit 24px 600, on-surface
/// Body: "Receive order updates, delivery notifications..." — Inter 16px
/// CTA 1: "Allow Notifications" — full-width primary pill
/// CTA 2: "Maybe Later" — full-width text-only primary color
class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _hoverAnim;

  @override
  void initState() {
    super.initState();
    // Float animation on illustration
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _hoverAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  void _allow() {
    // TODO: Request notification permission from OS
    _navigate();
  }

  void _maybeLater() => _navigate();

  void _navigate() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ReadyToShopScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ─── Atmospheric bottom gradient ────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.secondaryContainer.withOpacity(0.20),
                  ],
                ),
              ),
            ),
          ),

          // ─── Main Content ────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.marginMobile,
                  ),
                  child: SizedBox(
                    height: 56,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.onSurfaceVariant,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColors.secondaryContainer.withOpacity(0.50),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ),
                ),

                // ─── Illustration ──────────────────────────────────────────
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.marginMobile),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bell illustration with float animation + glow
                          SizedBox(
                            width: 256,
                            height: 256,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow blob
                                Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryContainer
                                        .withOpacity(0.20),
                                  ),
                                ),
                                // Floating illustration
                                AnimatedBuilder(
                                  animation: _hoverAnim,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _hoverAnim.value),
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.secondaryContainer.withOpacity(0.40),
                                      shape: BoxShape.circle,
                                      boxShadow: AppTheme.level2,
                                    ),
                                    child: const Icon(
                                      Icons.notifications_rounded,
                                      size: 90,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingLg + 8),

                          // ─── Text Content ──────────────────────────────────
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: Column(
                              children: [
                                Text(
                                  'Stay Updated',
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    height: 32 / 24,
                                    color: AppColors.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                Text(
                                  'Receive order updates, delivery notifications, exclusive offers, and reward alerts directly to your device.',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 24 / 16,
                                    color: AppColors.onSurfaceVariant,
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

                // ─── Actions ─────────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppTheme.marginMobile,
                    AppTheme.spacingLg,
                    AppTheme.marginMobile,
                    MediaQuery.of(context).padding.bottom + AppTheme.spacingLg,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        // Allow Notifications — primary pill
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _allow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: Text(
                              'Allow Notifications',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.05 * 12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingMd),

                        // Maybe Later — text-only
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: _maybeLater,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'Maybe Later',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.05 * 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
