import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Empty Basket Screen — Exact Google Stitch Specification
/// Matches:
/// - Top App Bar: "Your Shopping Basket"
/// - White rounded container card (28px corner radius)
/// - Empty shopping basket icon badge
/// - Title: "Your Basket is Empty"
/// - Subtitle: "Looks like you haven't added any fresh groceries to your basket yet."
/// - Primary dark green pill button: "Start Shopping"
class EmptyBasketScreen extends StatelessWidget {
  const EmptyBasketScreen({super.key});

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
          'Your Shopping Basket',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.marginMobile),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Empty Basket Badge Icon
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_basket_outlined,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Your Basket is Empty',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Looks like you haven\'t added any fresh groceries to your basket yet.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 20 / 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/customer/home');
                        },
                        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                        label: Text(
                          'Start Shopping',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
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
    );
  }
}
