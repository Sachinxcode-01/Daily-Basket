import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/presentation/screens/home_screen.dart' show CustomerHomeScreen;
import '../../../tracking/presentation/screens/tracking_screen.dart' show OrderTrackingScreen;

/// Order Success Screen — Google Stitch Design System Exact Replica
class OrderSuccessScreen extends StatefulWidget {
  final String orderId;
  final String address;
  final String estimatedArrival;

  const OrderSuccessScreen({
    super.key,
    this.orderId = '#DB-8829410',
    this.address = '242 Maplewood Avenue, Flat 4B\nNew York, NY 10012',
    this.estimatedArrival = '12:45 PM Today',
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
      (route) => false,
    );
  }

  void _goToTracking() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Daily Basket',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFF1A1C1E), size: 24),
            onPressed: _goToHome,
          ),
        ],
      ),
      body: Stack(
        children: [
          // ─── 1. Decorative Confetti Particle Floating Overlay ──────────────
          AnimatedBuilder(
            animation: _animCtrl,
            builder: (context, child) {
              return CustomPaint(
                painter: _ConfettiPainter(progress: _animCtrl.value),
                child: const SizedBox.expand(),
              );
            },
          ),

          // ─── 2. Main Body Content ──────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // Big Success Checkmark Badge
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006B23),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF006B23).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3.5),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Headline & Subtitle
                  Text(
                    'Order Placed!',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your groceries will be delivered in 10 minutes.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6E7A6C),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // 3. Order Details Card (White Container with Border)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Order ID Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ORDER ID',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),
                            Text(
                              widget.orderId,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF006B23),
                              ),
                            ),
                          ],
                        ),

                        const Divider(color: Color(0xFFEEEEF0), height: 24),

                        // Delivery Address Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F3F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_shipping_outlined,
                                color: Color(0xFF6E7A6C),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DELIVERY ADDRESS',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: const Color(0xFF6E7A6C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.address,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      height: 18 / 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Estimated Arrival Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F3F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: Color(0xFF6E7A6C),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ESTIMATED ARRIVAL',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: const Color(0xFF6E7A6C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.estimatedArrival,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Ordered Items Preview Thumbnails
                  Row(
                    children: [
                      // Item 1
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Item 2
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Item 3: +4 More Green Container
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '+4 more',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00531A),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // 5. Action Buttons (Track Order & Back to Home)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006B23),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.radar_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Track Order',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE2EBE2),
                        foregroundColor: const Color(0xFF00531A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home_outlined, color: Color(0xFF00531A), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Back to Home',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00531A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for floating confetti particles
class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF006B23),
      const Color(0xFF8CFA93),
      const Color(0xFFC0E8C7),
      const Color(0xFF4CAF50),
    ];

    final particles = [
      Offset(size.width * 0.1, (size.height * 0.15 + progress * 60) % size.height),
      Offset(size.width * 0.25, (size.height * 0.08 + progress * 80) % size.height),
      Offset(size.width * 0.4, (size.height * 0.22 + progress * 50) % size.height),
      Offset(size.width * 0.65, (size.height * 0.12 + progress * 70) % size.height),
      Offset(size.width * 0.82, (size.height * 0.25 + progress * 90) % size.height),
      Offset(size.width * 0.9, (size.height * 0.05 + progress * 40) % size.height),
      Offset(size.width * 0.18, (size.height * 0.40 + progress * 65) % size.height),
      Offset(size.width * 0.75, (size.height * 0.45 + progress * 85) % size.height),
    ];

    for (int i = 0; i < particles.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(center: particles[i], width: 8, height: 8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
