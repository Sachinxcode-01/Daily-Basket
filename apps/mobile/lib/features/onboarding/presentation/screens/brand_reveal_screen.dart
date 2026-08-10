// Google Stitch Screen ID: 7e277a60bf7649c08084b509267db422
// Title: Brand Reveal & Loading Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand Reveal & Fluid Preloading Splash Experience
class BrandRevealScreen extends StatefulWidget {
  static const String stitchId = '7e277a60bf7649c08084b509267db422';
  static const String routeName = '/brand-reveal';

  const BrandRevealScreen({super.key});

  @override
  State<BrandRevealScreen> createState() => _BrandRevealScreenState();
}

class _BrandRevealScreenState extends State<BrandRevealScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006B23),
      body: Stack(
        children: [
          // Background Gradient Glow
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    Color(0xFF078730),
                    Color(0xFF006B23),
                    Color(0xFF1A1C1E),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8CFA93).withAlpha(128),

                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_basket_rounded,
                        size: 64,
                        color: Color(0xFF006B23),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'DAILY BASKET',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8CFA93),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '⚡ 10-MINUTE EXPRESS DELIVERY',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF006B23),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8CFA93)),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
