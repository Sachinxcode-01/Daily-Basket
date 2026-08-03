import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Your Basket / Cart Screen — Google Stitch Design System Exact Replica
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 'c1',
      'name': 'Hass Avocados',
      'subtitle': '2 pcs (approx. 400g)',
      'price': 180,
      'qty': 1,
      'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200&q=80',
    },
    {
      'id': 'c2',
      'name': 'Farm Fresh Milk',
      'subtitle': '1 Litre',
      'price': 70,
      'qty': 2,
      'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&q=80',
    },
    {
      'id': 'c3',
      'name': 'Whole Wheat Bread',
      'subtitle': '400g',
      'price': 50,
      'qty': 1,
      'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80',
    },
  ];

  void _updateQuantity(int index, int delta) {
    setState(() {
      final current = _items[index]['qty'] as int;
      final updated = current + delta;
      if (updated <= 0) {
        _items.removeAt(index);
      } else {
        _items[index]['qty'] = updated;
      }
    });
  }

  int get _itemTotal => _items.fold(
      0, (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)));

  int get _totalCount =>
      _items.fold(0, (sum, item) => sum + (item['qty'] as int));

  final int _deliveryFee = 50;
  final int _taxes = 30;

  int get _toPay => _itemTotal + _deliveryFee + _taxes;

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
          'Cart',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
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
                const SizedBox(height: 8),

                // 1. Delivery Address Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                        child: const Icon(
                          Icons.home_outlined,
                          color: Color(0xFF1A1C1E),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery to Home',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '123 Green Valley Apt, Sector 45,...',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Arriving in 15 mins',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF006B23),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF6E7A6C),
                        size: 22,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Section Title
                Text(
                  'Your Items',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),

                const SizedBox(height: 10),

                // 3. Your Items Container (White Card with Dividers)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                    children: List.generate(_items.length, (index) {
                      final item = _items[index];
                      final isLast = index == _items.length - 1;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                // Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item['image'],
                                    width: 54,
                                    height: 54,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 54,
                                      height: 54,
                                      color: const Color(0xFFF3F3F6),
                                      child: const Icon(
                                        Icons.shopping_basket_rounded,
                                        color: Color(0xFF006B23),
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Title & Price
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['subtitle'],
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF6E7A6C),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${item['price']}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Stepper Pill (- 1 +)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F6),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _updateQuantity(index, -1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            index == _items.length - 1 &&
                                                    item['qty'] == 1
                                                ? Icons.delete_outline_rounded
                                                : Icons.remove_rounded,
                                            size: 16,
                                            color: const Color(0xFF6E7A6C),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${item['qty']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => _updateQuantity(index, 1),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add_rounded,
                                            size: 16,
                                            color: Color(0xFF006B23),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            const Divider(
                              color: Color(0xFFEEEEF0),
                              height: 1,
                              indent: 14,
                              endIndent: 14,
                            ),
                        ],
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // 4. "Add More Items" Outlined Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF006B23),
                      side: const BorderSide(
                          color: Color(0xFF006B23), width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        size: 20),
                    label: Text(
                      'Add more items',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 5. Apply Coupon Card
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_outlined,
                          color: Color(0xFF006B23), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Apply Coupon',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: Color(0xFF6E7A6C), size: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 6. Bill Summary Card (White Container)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                      _buildBillRow('Item Total ($_totalCount items)',
                          '₹$_itemTotal'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Delivery Fee',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF6E7A6C),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC0E8C7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Surge',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00531A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹$_deliveryFee',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildBillRow('Taxes & Charges', '₹$_taxes'),
                      const Divider(color: Color(0xFFEEEEF0), height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Pay',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          Text(
                            '₹$_toPay',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),

          // ─── 7. Fixed Bottom Action Bar (Proceed to Payment) ──────────────
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
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to Secure Checkout...'),
                          backgroundColor: Color(0xFF006B23),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL TO PAY',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: Colors.white.withValues(alpha: 0.80),
                                ),
                              ),
                              Text(
                                '₹$_toPay',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Proceed to Payment',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6E7A6C),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}
