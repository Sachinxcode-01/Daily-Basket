import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Live Order Tracking Screen — Google Stitch Design System Exact Replica
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    this.orderId = '8829',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Order #${widget.orderId}',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF1A1C1E)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support Team is available 24/7'),
                  backgroundColor: Color(0xFF006B23),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ─── 1. Map Header Section with Driver Marker ─────────────────────
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                children: [
                  // Vector Map Canvas Simulation
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5ECE5),
                    ),
                    child: CustomPaint(
                      painter: _MapCanvasPainter(),
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // Map Tooltip: "Alex is nearby"
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Alex is nearby',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Driver Pin Icon
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF006B23),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF006B23).withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_bike_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Customer Destination Pin
                  Positioned(
                    bottom: 30,
                    right: 120,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF006B23), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // ─── 2. Live ETA Card (Arriving in 6 mins) ───────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Arriving in',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '6 mins',
                          style: GoogleFonts.outfit(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF006B23),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Fresh groceries incoming',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── 3. Delivery Milestones Horizontal Stepper ──────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStepItem(Icons.check_rounded, 'Placed', true),
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                        _buildStepItem(Icons.inventory_2_outlined, 'Packed', true),
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: const Color(0xFF006B23),
                          ),
                        ),
                        _buildStepItem(Icons.directions_bike_rounded, 'On way', true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── 4. Delivery Partner Card ──────────────────────────────
                  Container(
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
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Partner',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFF006B23), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '4.9',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            // Driver Avatar with Green Ring
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF006B23), width: 2.5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9999),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFFE8F5E9),
                                    child: const Icon(Icons.person, color: Color(0xFF006B23)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alex M.',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF6E7A6C)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Daily Basket Pro',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF6E7A6C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Chat & Call Action Buttons
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F3F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF1A1C1E), size: 20),
                                    onPressed: () => Navigator.of(context).pushNamed('/help'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF006B23),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Calling delivery partner Alex M...')),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── 5. Order Summary Row Card ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F3F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt_long_outlined, color: Color(0xFF1A1C1E), size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${widget.orderId}',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1C1E),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '4 items • \$32.50',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF6E7A6C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFF6E7A6C), size: 22),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(IconData icon, String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF006B23) : const Color(0xFFEEEEF0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}

/// Custom painter to render clean vector streets & dashed route line on map header
class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = const Color(0xFF006B23)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    // Grid of streets
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), streetPaint);
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.75), streetPaint);
    canvas.drawLine(Offset(size.width * 0.35, 0), Offset(size.width * 0.35, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), streetPaint);

    // Dashed route path connecting driver (center top) to customer pin (bottom right)
    final start = Offset(size.width * 0.5, 100);
    final end = Offset(size.width * 0.7, size.height - 40);

    double dashWidth = 8, dashSpace = 6, startY = start.dy;
    double startX = start.dx;

    while (startY < end.dy) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + (end.dx - start.dx) * 0.08, startY + dashWidth),
        dashPaint,
      );
      startX += (end.dx - start.dx) * 0.12;
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
