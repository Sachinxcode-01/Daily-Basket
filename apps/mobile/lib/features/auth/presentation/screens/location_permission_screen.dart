import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'notification_permission_screen.dart';

/// Location Permission Screen — Google Stitch Design System
/// Design ref: stitch_daily_basket_quick_commerce_suite/location_access/
///
/// Background: #f9f9fc with glassmorphism blur accents
/// Top Header: Back button (top left)
/// Illustration: 3D Location Pin hovering over map grid (location_pin_3d.png)
/// Title: "Enable Your Location" — Outfit 24px 600
/// Body: "Allow location access to show nearby delivery availability and accurate delivery times."
/// Actions:
///   - "Enable Location" (Primary pill button)
///   - "Skip for Now" (Text pill button)
class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  void _enableLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Location access granted! Finding store near Koramangala...',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _navigateNext();
    });
  }

  void _skipForNow() => _navigateNext();

  void _navigateNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const NotificationPermissionScreen(),
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
          // ─── Ambient Background Blobs ────────────────────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixedDim.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryFixed.withValues(alpha: 0.30),
              ),
            ),
          ),

          // ─── Main Content Canvas ─────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Top App Bar Back Button
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
                        color: AppColors.primary,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColors.secondaryContainer.withValues(alpha: 0.50),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ),
                ),

                // Illustration & Text Area
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.marginMobile,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Floating 3D Location Pin Illustration (Enlarged 290px)
                            SizedBox(
                              width: 290,
                              height: 290,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 270,
                                    height: 270,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryFixedDim
                                          .withValues(alpha: 0.22),
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _floatAnim,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(0, _floatAnim.value),
                                        child: child,
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/illustrations/location_pin_3d.png',
                                      width: 270,
                                      height: 270,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            const SizedBox(height: AppTheme.spacingLg),

                            // Typography
                            Text(
                              'Enable Your Location',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 32 / 24,
                                color: AppColors.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            Text(
                              'Allow location access to show nearby delivery availability and accurate delivery times.',
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
                    ),
                  ),
                ),

                // Action Area
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
                        // Enable Location (Primary Pill)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _enableLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: Text(
                              'Enable Location',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.05 * 12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingMd),

                        // Skip for Now (Text Button)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: _skipForNow,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'Skip for Now',
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
