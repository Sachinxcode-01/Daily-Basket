import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/tracking_provider.dart';

/// Live Order Tracking Screen — Google Stitch Design System Exact Replica
class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    this.orderId = 'DB-892104',
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackingProvider(),
      child: Consumer<TrackingProvider>(
        builder: (context, tracking, child) {
          final isDelivered = tracking.status == DeliveryOrderStatus.delivered;
          final isPacked = tracking.status == DeliveryOrderStatus.packed ||
              tracking.status == DeliveryOrderStatus.outForDelivery ||
              isDelivered;
          final isOnWay = tracking.status == DeliveryOrderStatus.outForDelivery || isDelivered;

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
              title: Column(
                children: [
                  Text(
                    'Order #${widget.orderId}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF006B23),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDelivered ? const Color(0xFF006B23) : const Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isDelivered ? 'Delivered' : 'Live Express GPS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF1A1C1E)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Support Team is available 24/7 for this order'),
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
                  // ─── 1. Map Header Section with Moving Driver Marker ──────────────
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
                            painter: _MapCanvasPainter(progressRatio: tracking.progressRatio),
                            child: const SizedBox.expand(),
                          ),
                        ),

                        // Store Hub Marker (Start Point)
                        Positioned(
                          top: 45,
                          left: 40,
                          child: Column(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1C1E),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.store_mall_directory_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Hub Store #01',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1C1E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Customer Destination Pin (End Point)
                        Positioned(
                          bottom: 25,
                          right: 45,
                          child: Column(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006B23),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF006B23).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Doorstep',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Moving Driver Pin Icon based on progressRatio
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final w = constraints.maxWidth;
                            final start = Offset(w * 0.22, 60);
                            final end = Offset(w * 0.82, 175);
                            final x = start.dx + (end.dx - start.dx) * tracking.progressRatio;
                            final y = start.dy + (end.dy - start.dy) * tracking.progressRatio;

                            return Positioned(
                              left: x - 24,
                              top: y - 24,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.12),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      isDelivered
                                          ? 'Arrived!'
                                          : 'Ramesh • ${tracking.speedKmh} km/h',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF006B23),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF006B23).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isDelivered
                                          ? Icons.check_circle_rounded
                                          : Icons.directions_bike_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        // ─── 2. Live ETA Card ───────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
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
                                isDelivered ? 'Order Status' : 'Estimated Arrival',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6E7A6C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isDelivered ? 'Delivered 🎉' : tracking.etaDisplay,
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF006B23),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tracking.currentStreet,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1A1C1E),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006B23).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.eco_rounded, color: Color(0xFF006B23), size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      isDelivered
                                          ? 'Delivered with Freshness Guarantee'
                                          : '10-Minute Express Delivery in Progress',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ─── 3. Delivery OTP Verification Box ──────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF006B23).withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006B23),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DELIVERY VERIFICATION OTP',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Share with Ramesh only at door',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF384339),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF006B23), width: 1.5),
                                ),
                                child: Text(
                                  tracking.deliveryOtp,
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 4,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ─── 4. Delivery Milestones Horizontal Stepper ──────────────
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
                                  color: isPacked
                                      ? const Color(0xFF006B23)
                                      : const Color(0xFFEEEEF0),
                                ),
                              ),
                              _buildStepItem(
                                Icons.inventory_2_outlined,
                                'Packed',
                                isPacked,
                              ),
                              Expanded(
                                child: Container(
                                  height: 2.5,
                                  color: isOnWay
                                      ? const Color(0xFF006B23)
                                      : const Color(0xFFEEEEF0),
                                ),
                              ),
                              _buildStepItem(
                                Icons.directions_bike_rounded,
                                'On way',
                                isOnWay,
                              ),
                              Expanded(
                                child: Container(
                                  height: 2.5,
                                  color: isDelivered
                                      ? const Color(0xFF006B23)
                                      : const Color(0xFFEEEEF0),
                                ),
                              ),
                              _buildStepItem(
                                Icons.home_rounded,
                                'Delivered',
                                isDelivered,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ─── 5. Delivery Partner Card ──────────────────────────────
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Color(0xFF006B23), size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${tracking.driverInfo['rating']}',
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
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  // Driver Avatar with Green Ring
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF006B23), width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9999),
                                      child: Image.network(
                                        tracking.driverInfo['avatarUrl'] as String,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFFE8F5E9),
                                          child: const Icon(Icons.person, color: Color(0xFF006B23)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tracking.driverInfo['name'] as String,
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1A1C1E),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${tracking.driverInfo['vehicleNumber']} • ${tracking.driverInfo['vehicleType']}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: const Color(0xFF6E7A6C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Call Action Button
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF006B23),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Calling partner ${tracking.driverInfo['name']}...'),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: const Color(0xFF006B23),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ─── 6. Ordered Items Summary Card ─────────────────────────
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Items in Basket',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  Text(
                                    '${tracking.orderItems.length} items',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6E7A6C),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...tracking.orderItems.map((item) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Text(item['icon'] as String, style: const TextStyle(fontSize: 16)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${item['name']} × ${item['qty']}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF1A1C1E),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          item['price'] as String,
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1A1C1E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const Divider(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Paid (Inclusive of taxes)',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  Text(
                                    '₹320',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF006B23),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepItem(IconData icon, String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF006B23) : const Color(0xFFEEEEF0),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isCompleted ? Colors.white : const Color(0xFF6E7A6C),
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
            color: isCompleted ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
          ),
        ),
      ],
    );
  }
}

/// Custom painter to render clean vector streets & animated dashed route line on map header
class _MapCanvasPainter extends CustomPainter {
  final double progressRatio;

  _MapCanvasPainter({required this.progressRatio});

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

    // Dashed route path connecting driver start to customer destination pin
    final start = Offset(size.width * 0.22, 60);
    final end = Offset(size.width * 0.82, 175);

    double dashWidth = 8, dashSpace = 6;
    double totalDist = (end - start).distance;
    Offset dir = (end - start) / totalDist;

    double d = 0;
    while (d < totalDist) {
      final p1 = start + dir * d;
      final p2 = start + dir * (d + dashWidth).clamp(0, totalDist);
      canvas.drawLine(p1, p2, dashPaint);
      d += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) =>
      oldDelegate.progressRatio != progressRatio;
}
