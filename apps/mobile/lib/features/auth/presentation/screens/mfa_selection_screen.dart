import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// MFA Selection Screen (Secure Access) — Mobile Only Exact Specification
/// Matches:
/// - Top app bar with back button, Daily Basket badge + "Secure Access" text
/// - Circular green shield badge icon
/// - Title: "Secure Your Account"
/// - Subtitle: "Choose a secondary method to verify your identity."
/// - Interactive Radio Cards for Text Message (SMS), Email, Authenticator App
/// - Primary dark green pill button: "Continue ->"
/// - Footer link: "Need help accessing your account?"
/// - Bottom caption: "END-TO-END ENCRYPTED"
class MfaSelectionScreen extends StatefulWidget {
  const MfaSelectionScreen({super.key});

  @override
  State<MfaSelectionScreen> createState() => _MfaSelectionScreenState();
}

class _MfaSelectionScreenState extends State<MfaSelectionScreen> {
  String _selectedMethod = 'SMS'; // 'SMS', 'EMAIL', 'AUTHENTICATOR'
  bool _isLoading = false;

  void _handleContinue() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      if (_selectedMethod == 'SMS') {
        Navigator.of(context).pushNamed('/auth/otp');
      } else {
        Navigator.of(context).pushReplacementNamed('/customer/home');
      }
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Secure Access',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
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
                          // ─── Circular Shield Lock Badge ─────────────────────
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5EFE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shield_outlined,
                                size: 32,
                                color: AppColors.primary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ─── Title: Secure Your Account ─────────────────────
                          Text(
                            'Secure Your Account',
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          // ─── Subtitle ───────────────────────────────────────
                          Text(
                            'Choose a secondary method to verify your identity.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 20 / 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),

                          // ─── Radio Card Options ─────────────────────────────

                          // Option 1: Text Message (SMS)
                          _buildMfaOptionCard(
                            id: 'SMS',
                            title: 'Text Message (SMS)',
                            subtitle: 'Send a code to ••••••••89',
                            iconData: Icons.chat_bubble_outline_rounded,
                          ),

                          const SizedBox(height: 14),

                          // Option 2: Email
                          _buildMfaOptionCard(
                            id: 'EMAIL',
                            title: 'Email',
                            subtitle: 'Send a link to j***@example.com',
                            iconData: Icons.mail_outline_rounded,
                          ),

                          const SizedBox(height: 14),

                          // Option 3: Authenticator App
                          _buildMfaOptionCard(
                            id: 'AUTHENTICATOR',
                            title: 'Authenticator App',
                            subtitle: 'Use Google or Microsoft Authenticator',
                            iconData: Icons.phonelink_lock_rounded,
                          ),

                          const SizedBox(height: 28),

                          // ─── Primary Pill Button: Continue -> ───────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleContinue,
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
                                          'Continue',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
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

                          const SizedBox(height: 20),

                          // ─── Footer Link ──────────────────────────────────
                          Text(
                            'Need help accessing your account?',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
            ),

            // ─── Bottom Security Caption ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'END-TO-END ENCRYPTED',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
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

  Widget _buildMfaOptionCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData iconData,
  }) {
    final isSelected = _selectedMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4FAF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.40),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Soft Icon Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: AppColors.onSurface,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Titles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Radio Indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
