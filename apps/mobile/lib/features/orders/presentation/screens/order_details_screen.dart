import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../tracking/presentation/screens/tracking_screen.dart';

/// Order Details Screen — Google Stitch Design System Exact Replica
class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    this.orderId = '#DB-8829410',
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  Map<String, dynamic>? _remoteOrder;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final cleanId = widget.orderId.replaceAll('#', '').replaceAll('DB-', '');
    try {
      final res = await _apiClient.get('/orders/$cleanId');
      if (res['success'] == true) {
        final orderData = res['data'] is Map<String, dynamic>
            ? res['data'] as Map<String, dynamic>
            : res['order'] is Map<String, dynamic>
                ? res['order'] as Map<String, dynamic>
                : null;
        if (orderData != null && mounted) {
          setState(() {
            _remoteOrder = orderData;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderId = widget.orderId;
    final status = (_remoteOrder?['status'] ?? 'PROCESSING').toString().toUpperCase();
    final isDelivered = status == 'DELIVERED';
    final isOutForDelivery = status == 'OUT_FOR_DELIVERY';
    final isPacked = status == 'READY_FOR_PICKUP' || isOutForDelivery || isDelivered;
    final isConfirmed = status == 'CONFIRMED' || status == 'PROCESSING' || isPacked;

    final addressObj = _remoteOrder?['address'] as Map<String, dynamic>?;
    final addressText = addressObj != null
        ? '${addressObj['houseNo'] ?? ''}, ${addressObj['street'] ?? ''}\n${addressObj['city'] ?? ''} ${addressObj['pincode'] ?? ''}'.trim()
        : 'Flat 402, Green Valley Apartments\n100ft Road, Indiranagar, Bengaluru 560038';

    final remoteItems = _remoteOrder?['items'] as List<dynamic>? ?? [];
    final rawTotal = (_remoteOrder?['totalAmount'] as num?)?.toDouble();
    final rawSubtotal = (_remoteOrder?['subtotal'] as num?)?.toDouble();
    final rawDeliveryFee = (_remoteOrder?['deliveryFee'] as num?)?.toDouble();
    final rawTaxes = (_remoteOrder?['taxAmount'] as num?)?.toDouble() ??
        (_remoteOrder?['taxes'] as num?)?.toDouble();

    final deliveryFee = rawDeliveryFee ?? 0.0;

    final double subtotal;
    if (rawSubtotal != null) {
      subtotal = rawSubtotal;
    } else if (remoteItems.isNotEmpty) {
      subtotal = remoteItems.fold<double>(0.0, (sum, item) {
        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        final price = (item['price'] as num?)?.toDouble() ?? 0.0;
        return sum + (price * qty);
      });
    } else if (rawTotal != null) {
      final remaining = rawTotal - deliveryFee - (rawTaxes ?? 0.0);
      subtotal = remaining > 0 ? remaining : rawTotal;
    } else {
      subtotal = 260.0;
    }

    final double taxes;
    if (rawTaxes != null) {
      taxes = rawTaxes;
    } else if (rawTotal != null) {
      final diff = rawTotal - (subtotal + deliveryFee);
      taxes = diff > 0 ? diff : 0.0;
    } else {
      taxes = 0.0;
    }

    final totalAmount = rawTotal ?? (subtotal + deliveryFee + taxes);
    final paymentMethod = _remoteOrder?['paymentMethod']?.toString() ?? 'UPI';
    final riderObj = _remoteOrder?['deliveryPartner'] as Map<String, dynamic>?;
    final riderName = riderObj?['name'] ?? 'Robert Fox';
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
          'Order $orderId',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF1A1C1E)),
            onPressed: () => Navigator.of(context).pushNamed('/help'),
          ),
        ],
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(color: Color(0xFF006B23), minHeight: 2),
              )
            : null,
      ),
      body: Stack(
        children: [
          // ─── Scrollable Body Content ──────────────────────────────────────
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Order Progress Card (Vertical Timeline Stepper)
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Progress',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStepRow(
                        icon: Icons.check_rounded,
                        title: 'Order Placed',
                        subtitle: 'Received & Confirmed',
                        isCompleted: true,
                        isCurrent: !isConfirmed,
                        showLine: true,
                      ),
                      _buildStepRow(
                        icon: Icons.check_rounded,
                        title: 'Packed',
                        subtitle: isPacked ? 'Ready for pickup' : 'Being prepared in dark store',
                        isCompleted: isPacked,
                        isCurrent: isConfirmed && !isPacked,
                        showLine: true,
                      ),
                      _buildStepRow(
                        icon: Icons.directions_bike_rounded,
                        title: 'Out for Delivery',
                        subtitle: isOutForDelivery ? 'On the way • 10 mins' : 'Dispatches soon',
                        isCompleted: isOutForDelivery || isDelivered,
                        isCurrent: isOutForDelivery,
                        showLine: true,
                      ),
                      _buildStepRow(
                        icon: Icons.home_outlined,
                        title: 'Delivered',
                        subtitle: isDelivered ? 'Delivered successfully' : 'Estimated in 10 mins',
                        isCompleted: isDelivered,
                        isCurrent: isDelivered,
                        showLine: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Delivery Address & Driver Card
                Container(
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
                      // Map View Banner Box (tappable to open live tracking)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OrderTrackingScreen(orderId: widget.orderId),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: Stack(
                              children: [
                                Container(
                                  color: const Color(0xFFE5ECE5),
                                  child: CustomPaint(
                                    painter: _MiniMapPainter(),
                                    child: const SizedBox.expand(),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF006B23),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.navigation_rounded, color: Colors.white, size: 12),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Track Live',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            color: Color(0xFF006B23), size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Home • 2.4 km away',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1A1C1E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Delivery Address Info
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Address',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1C1E),
                                  ),
                                ),
                                Text(
                                  'Change',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addressText,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                height: 18 / 13,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),

                            const Divider(
                                color: Color(0xFFEEEEF0), height: 24),

                            // Driver Info Row
                            Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xFF006B23),
                                        width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(9999),
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: const Color(0xFFE8F5E9),
                                        child: const Icon(Icons.person,
                                            color: Color(0xFF006B23)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        riderName,
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Delivery Specialist • ⭐ 4.9',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF6E7A6C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F3F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.call_outlined,
                                      color: Color(0xFF1A1C1E), size: 20),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF006B23),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: Colors.white,
                                      size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Order Items (3) Card
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        remoteItems.isNotEmpty
                            ? 'Order Items (${remoteItems.length})'
                            : 'Order Items (3)',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (remoteItems.isNotEmpty)
                        ...remoteItems.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;
                          final name = (item['productName'] ?? item['name'] ?? 'Product').toString();
                          final unit = (item['unitName'] ?? '1 unit').toString();
                          final qty = (item['quantity'] as num?)?.toInt() ?? 1;
                          final price = (item['price'] as num?)?.toDouble() ?? 50.0;
                          return Column(
                            children: [
                              if (idx > 0)
                                const Divider(color: Color(0xFFEEEEF0), height: 20),
                              _buildOrderItem(
                                name: name,
                                subtitle: '$qty x $unit • ₹${price.toStringAsFixed(2)} each',
                                price: '₹${(price * qty).toStringAsFixed(2)}',
                                imageUrl:
                                    'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80',
                              ),
                            ],
                          );
                        })
                      else ...[
                        _buildOrderItem(
                          name: 'Organic Hass Avocados',
                          subtitle: '2 units • ₹80.00 each',
                          price: '₹160.00',
                          imageUrl:
                              'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200&q=80',
                        ),
                        const Divider(color: Color(0xFFEEEEF0), height: 20),
                        _buildOrderItem(
                          name: 'Fresh Whole Milk',
                          subtitle: '1 Litre',
                          price: '₹65.00',
                          imageUrl:
                              'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&q=80',
                        ),
                        const Divider(color: Color(0xFFEEEEF0), height: 20),
                        _buildOrderItem(
                          name: 'Farm Fresh Tomatoes',
                          subtitle: '500g',
                          price: '₹35.00',
                          imageUrl:
                              'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80',
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Bill Summary Card
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Summary',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildBillRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildBillRow('Delivery Fee', deliveryFee > 0 ? '₹${deliveryFee.toStringAsFixed(2)}' : 'FREE'),
                      const SizedBox(height: 8),
                      _buildBillRow('Taxes & Charges', '₹${taxes.toStringAsFixed(2)}'),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Payment Badge Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet_outlined,
                                color: Color(0xFF006B23), size: 18),
                            const SizedBox(width: 10),
                            Text(
                              'Paid via $paymentMethod',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3F4A3D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 150),
              ],
            ),
          ),

          // ─── 5. Fixed Bottom Action Buttons ────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Primary Reorder Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          try {
                            if (remoteItems.isNotEmpty) {
                              final itemsToReorder = remoteItems.map((item) {
                                return CartItem(
                                  id: (item['variantId'] ?? item['id'] ?? 'reorder_${DateTime.now().millisecondsSinceEpoch}').toString(),
                                  name: (item['productName'] ?? item['name'] ?? 'Item').toString(),
                                  subtitle: (item['unitName'] ?? '1 pack').toString(),
                                  price: (item['price'] as num?)?.toDouble() ?? 50.0,
                                  qty: (item['quantity'] as num?)?.toInt() ?? 1,
                                  image: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
                                );
                              }).toList();
                              context.read<CartProvider>().reorderItems(itemsToReorder);
                            } else {
                              context.read<CartProvider>().reorderItems([
                                CartItem(
                                  id: 'c1',
                                  name: 'Organic Hass Avocados',
                                  subtitle: '2 pcs (approx. 400g)',
                                  price: 80.0,
                                  qty: 1,
                                  image: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200&q=80',
                                ),
                              ]);
                            }
                          } catch (_) {}
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All items reordered and added to cart!'),
                              backgroundColor: Color(0xFF006B23),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pushNamed(context, '/cart');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B23),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.reorder_rounded,
                            color: Colors.white, size: 20),
                        label: Text(
                          'Reorder All Items',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        // Download Invoice Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Downloading Tax Invoice PDF...'),
                                  backgroundColor: Color(0xFF006B23),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF006B23),
                              side: const BorderSide(color: Color(0xFF006B23), width: 1.5),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.download_rounded, color: Color(0xFF006B23), size: 18),
                            label: Text(
                              'Invoice',
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Cancel Order Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Cancel Order?', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
                                  content: Text(
                                    'Are you sure you want to cancel Order $orderId? A full refund of ₹320 will be credited back to your wallet.',
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('No, Keep Order'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Order Cancelled. Refund of ₹320 initiated to wallet.'),
                                            backgroundColor: Color(0xFFD32F2F),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
                                      child: const Text('Yes, Cancel Order', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFD32F2F),
                              side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.cancel_outlined, color: Color(0xFFD32F2F), size: 18),
                            label: Text(
                              'Cancel',
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildStepRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF006B23)
                    : const Color(0xFFEEEEF0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isCompleted ? Colors.white : const Color(0xFF6E7A6C),
                size: 16,
              ),
            ),
            if (showLine)
              Container(
                width: 2.5,
                height: 32,
                color: isCompleted
                    ? const Color(0xFF006B23)
                    : const Color(0xFFEEEEF0),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isCurrent
                      ? const Color(0xFF006B23)
                      : const Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6E7A6C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String name,
    required String subtitle,
    required String price,
    required String imageUrl,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              color: const Color(0xFFF3F3F6),
              child: const Icon(Icons.shopping_basket,
                  size: 24, color: Color(0xFF006B23)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6E7A6C),
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C)),
        ),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1C1E)),
        ),
      ],
    );
  }
}

/// Mini map painter for order details header
class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), streetPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.4, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.8, 0), Offset(size.width * 0.8, size.height), streetPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
