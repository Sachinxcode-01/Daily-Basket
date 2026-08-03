import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_details_screen.dart';
import '../../../tracking/presentation/screens/tracking_screen.dart';

/// Order History Screen — Google Stitch Design System Exact Replica
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Ongoing', 'Past'];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#DB-8829410',
      'status': 'Delivered',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'date': 'Oct 24, 2023 • 10:30 AM',
      'title': 'Artisan Sourdough ...',
      'price': '\$42.50',
      'extraCount': 2,
      'isOngoing': false,
      'isCancelled': false,
      'thumbnails': [
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80',
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80',
      ],
    },
    {
      'id': '#DB-8910245',
      'status': 'Processing',
      'statusColor': const Color(0xFFE65100),
      'statusBg': const Color(0xFFFFF3E0),
      'date': 'Today • 02:15 PM',
      'title': 'Organic Milk,...',
      'price': '\$18.90',
      'extraCount': 0,
      'isOngoing': true,
      'isCancelled': false,
      'thumbnails': [
        'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&q=80',
        'https://images.unsplash.com/photo-1550547660-d9450f859349?w=200&q=80',
      ],
    },
    {
      'id': '#DB-8812300',
      'status': 'Cancelled',
      'statusColor': const Color(0xFFBA1A1A),
      'statusBg': const Color(0xFFFFDAD6),
      'date': 'Oct 20, 2023 • 09:45 AM',
      'title': 'Dark Chocolate 70% Cocoa',
      'price': '\$5.50',
      'extraCount': 0,
      'isOngoing': false,
      'isCancelled': true,
      'thumbnails': [
        'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=200&q=80',
      ],
    },
    {
      'id': '#DB-8799201',
      'status': 'Delivered',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'date': 'Oct 15, 2023 • 05:20 PM',
      'title': 'Fresh Avocados + 6...',
      'price': '\$67.25',
      'extraCount': 5,
      'isOngoing': false,
      'isCancelled': false,
      'thumbnails': [
        'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200&q=80',
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80',
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilterIndex == 1) {
      return _orders.where((o) => o['isOngoing'] == true).toList();
    } else if (_selectedFilterIndex == 2) {
      return _orders.where((o) => o['isOngoing'] == false).toList();
    }
    return _orders;
  }

  void _goToDetails(String orderId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderId)),
    );
  }

  void _goToTracking() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
    );
  }

  void _reorder(String orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reordered items from $orderId! Added to cart.'),
        backgroundColor: const Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Orders',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF1A1C1E)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // ─── 1. Filter Chips Tab Bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF006B23) : const Color(0xFFE5ECE5),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        _filters[index],
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF3F4A3D),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // ─── 2. Orders List ───────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                final isOngoing = order['isOngoing'] as bool;
                final isCancelled = order['isCancelled'] as bool;
                final thumbnails = order['thumbnails'] as List<String>;
                final extraCount = order['extraCount'] as int;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOngoing
                          ? const Color(0xFF006B23)
                          : const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      width: isOngoing ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Left Green Bar for Ongoing Orders
                        if (isOngoing)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 4,
                              color: const Color(0xFF006B23),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order ID & Status Badge Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order['id'] as String,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6E7A6C),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: order['statusBg'] as Color,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      order['status'] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: order['statusColor'] as Color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Text(
                                order['date'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF6E7A6C),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Items Preview Row & Title / Price
                              Row(
                                children: [
                                  // Thumbnails Group
                                  Row(
                                    children: [
                                      ...thumbnails.map((url) => Container(
                                            margin: const EdgeInsets.only(right: 6),
                                            width: 44,
                                            height: 44,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Container(
                                                  color: const Color(0xFFF3F3F6),
                                                  child: const Icon(Icons.shopping_basket, size: 20, color: Color(0xFF006B23)),
                                                ),
                                              ),
                                            ),
                                          )),
                                      if (extraCount > 0)
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEEEF0),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+$extraCount',
                                              style: GoogleFonts.outfit(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF6E7A6C),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),

                                  // Title & Price
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order['title'] as String,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1A1C1E),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          order['price'] as String,
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF006B23),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Action Buttons
                              if (isOngoing)
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton.icon(
                                    onPressed: _goToTracking,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE2EBE2),
                                      foregroundColor: const Color(0xFF00531A),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Icons.local_shipping_outlined, size: 18),
                                    label: Text(
                                      'Track Order',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              else if (isCancelled)
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: OutlinedButton(
                                    onPressed: () => _goToDetails(order['id'] as String),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF1A1C1E),
                                      side: const BorderSide(color: Color(0xFFBECAB9)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Details',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 44,
                                        child: OutlinedButton(
                                          onPressed: () => _goToDetails(order['id'] as String),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xFF1A1C1E),
                                            side: const BorderSide(color: Color(0xFFBECAB9)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Details',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: SizedBox(
                                        height: 44,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _reorder(order['id'] as String),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF006B23),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(Icons.reorder_rounded, size: 18),
                                          label: Text(
                                            'Reorder',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
