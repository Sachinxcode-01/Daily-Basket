import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
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
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackingProvider(orderId: widget.orderId),
      child: Consumer<TrackingProvider>(
        builder: (context, tracking, child) {
          final isDelivered = tracking.status == DeliveryOrderStatus.delivered;
          final isPacked = tracking.status == DeliveryOrderStatus.packed ||
              tracking.status == DeliveryOrderStatus.outForDelivery ||
              isDelivered;
          final isOnWay = tracking.status == DeliveryOrderStatus.outForDelivery || isDelivered;

          UserProvider? userProvider;
          try {
            userProvider = context.watch<UserProvider>();
          } catch (_) {}
          final profileImageUrl = userProvider?.profileImageUrl ??
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80';

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            drawer: const AppNavigationDrawer(isDrawer: true),
            bottomNavigationBar: const AppBottomNav(currentIndex: 4),
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  tooltip: 'Order Support',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pushNamed('/help');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E)),
                  tooltip: 'Navigation Hub',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    AppNavigationDrawer.show(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pushNamed('/profile');
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2D9D43).withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          profileImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const CircleAvatar(
                            backgroundColor: Color(0xFF2D9D43),
                            child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ─── 1. Live Interactive OpenStreetMap (100% Free • No API Key) ──────
                  Container(
                    height: 290,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F3F6),
                    ),
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: tracking.driverLocation,
                            initialZoom: 15.0,
                            minZoom: 11.0,
                            maxZoom: 18.5,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.pinchZoom |
                                  InteractiveFlag.drag |
                                  InteractiveFlag.doubleTapZoom,
                            ),
                          ),
                          children: [
                            // 100% Free OpenStreetMap Tile Layer
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.daily_basket_mobile',
                            ),

                            // Real road-following route polylines (OSRM geometry)
                            if (tracking.routePoints.isNotEmpty) ...[
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: tracking.routePoints,
                                    color: const Color(0xFF078730).withValues(alpha: 0.3),
                                    strokeWidth: 8.0,
                                  ),
                                  Polyline(
                                    points: tracking.routePoints,
                                    color: const Color(0xFF2D9D43),
                                    strokeWidth: 4.5,
                                  ),
                                ],
                              ),
                            ],

                            // Interactive Markers Layer
                            MarkerLayer(
                              markers: [
                                // 1. Dark Store Hub Marker (Start)
                                Marker(
                                  point: tracking.storeLocation,
                                  width: 90,
                                  height: 56,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black12, blurRadius: 4),
                                          ],
                                        ),
                                        child: Text(
                                          'Hub Store #01',
                                          style: GoogleFonts.outfit(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF191C1E),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF191C1E),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black26, blurRadius: 4),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.storefront_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 2. Customer Destination Marker (End)
                                Marker(
                                  point: tracking.customerLocation,
                                  width: 80,
                                  height: 56,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.black12, blurRadius: 4),
                                          ],
                                        ),
                                        child: Text(
                                          'Doorstep',
                                          style: GoogleFonts.outfit(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF2D9D43),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2D9D43),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF2D9D43).withValues(alpha: 0.4),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.home_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 3. Real-Time Moving Rider / Scooter Marker with Heading
                                Marker(
                                  point: tracking.driverLocation,
                                  width: 140,
                                  height: 70,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(9999),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.15),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          isDelivered
                                              ? 'Arrived!'
                                              : 'Ramesh • ${tracking.speedKmh} km/h',
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF2D9D43),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Transform.rotate(
                                        angle: (tracking.driverBearing * pi / 180.0),
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2D9D43),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2.5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF2D9D43).withValues(alpha: 0.5),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isDelivered
                                                ? Icons.check_circle_rounded
                                                : Icons.navigation_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Floating Live GPS Badge (Top-Left)
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 6),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2D9D43),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Live Express GPS (OSM)',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF191C1E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Recenter on Rider Button (Top-Right)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: InkWell(
                            onTap: () {
                              _mapController.move(tracking.driverLocation, 15.5);
                            },
                            borderRadius: BorderRadius.circular(9999),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 6),
                                ],
                              ),
                              child: const Icon(
                                Icons.my_location_rounded,
                                size: 19,
                                color: Color(0xFF2D9D43),
                              ),
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
