import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../referral/providers/coupon_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import 'payment_screen.dart';

/// Checkout Summary / Confirm Order Screen — Google Stitch Design System Exact Replica
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isBasketExpanded = true;
  String _selectedSlot = 'Instant (10-15 mins)';
  String _selectedInstruction = 'Ring Bell';
  bool _isGiftOrder = false;
  final TextEditingController _giftNoteCtrl = TextEditingController();

  final List<String> _deliverySlots = [
    'Instant (10-15 mins)',
    'Today Evening (6 PM - 8 PM)',
    'Tomorrow Morning (7 AM - 9 AM)',
    'Tomorrow Evening (6 PM - 8 PM)',
  ];

  final List<String> _instructions = [
    'Ring Bell',
    'Leave at Door',
    'Don\'t Ring Bell',
    'Call on Arrival',
    'Leave with Guard',
  ];

  @override
  void dispose() {
    _giftNoteCtrl.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _basketItems = [
    {
      'id': 'b1',
      'name': 'Organic Whole Milk',
      'subtitle': '1 Litre Bottle',
      'price': 3.50,
      'qty': 1,
      'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&q=80',
    },
    {
      'id': 'b2',
      'name': 'Artisan Sourdough',
      'subtitle': '500g Loaf',
      'price': 5.20,
      'qty': 1,
      'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80',
    },
    {
      'id': 'b3',
      'name': 'Premium Bananas',
      'subtitle': 'Bunch of 4-5',
      'price': 2.80,
      'qty': 1,
      'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=200&q=80',
    },
  ];

  void _updateQty(int index, int delta) {
    setState(() {
      final current = _basketItems[index]['qty'] as int;
      final updated = current + delta;
      if (updated <= 0) {
        _basketItems.removeAt(index);
      } else {
        _basketItems[index]['qty'] = updated;
      }
    });
  }

  double get _itemTotal => _basketItems.fold(
      0.0, (sum, item) => sum + ((item['price'] as double) * (item['qty'] as int)));

  final double _baseDeliveryFee = 1.99;
  final double _taxes = 0.85;

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try { cartProvider = context.watch<CartProvider>(); } catch (_) {}
    final couponProvider = context.watch<CouponProvider>();

    final double effectiveItemTotal = (cartProvider != null && !cartProvider.isEmpty)
        ? cartProvider.itemTotalDouble
        : _itemTotal;

    final double discount = couponProvider.calculateDiscount(effectiveItemTotal);
    final double deliveryFee = couponProvider.calculateDeliveryFee(_baseDeliveryFee, effectiveItemTotal);
    final double grandTotal = (effectiveItemTotal - discount + deliveryFee + _taxes).clamp(0.0, double.infinity);

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
          'Checkout Summary',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF006B23)),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ─── Scrollable Body ───────────────────────────────────────────────
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Estimated Delivery & Address Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
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
                      // Top Half: Estimated Delivery
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bolt_rounded, color: Color(0xFF006B23), size: 24),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ESTIMATED DELIVERY',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: const Color(0xFF6E7A6C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Arriving in 12 mins',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 16, endIndent: 16),

                      // Bottom Half: Address Line
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Color(0xFF1A1C1E), size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Office - Green Tower',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '4th Floor, Suite 402, High Street North, City Central',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF6E7A6C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => Navigator.of(context).pushNamed('/saved-addresses'),
                              child: Text(
                                'CHANGE',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF006B23),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Schedule Delivery & Slot Selector Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Time Slot',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1E)),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _deliverySlots.map((slot) {
                            final isSel = _selectedSlot == slot;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(slot),
                                selected: isSel,
                                selectedColor: const Color(0xFF006B23),
                                backgroundColor: const Color(0xFFF3F3F6),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? Colors.white : const Color(0xFF1A1C1E),
                                ),
                                onSelected: (_) => setState(() => _selectedSlot = slot),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Delivery Instructions',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1E)),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _instructions.map((inst) {
                          final isSel = _selectedInstruction == inst;
                          return ChoiceChip(
                            label: Text(inst),
                            selected: isSel,
                            selectedColor: const Color(0xFFE8F5E9),
                            backgroundColor: const Color(0xFFF3F3F6),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: const Color(0xFF006B23),
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: isSel ? const Color(0xFF006B23) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            onSelected: (_) => setState(() => _selectedInstruction = inst),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Gift Order Option Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.card_giftcard_rounded, color: Color(0xFF006B23), size: 22),
                              const SizedBox(width: 10),
                              Text(
                                'Make this a Gift Order 🎁',
                                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1E)),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isGiftOrder,
                            activeThumbColor: const Color(0xFF006B23),
                            onChanged: (v) => setState(() => _isGiftOrder = v),
                          ),
                        ],
                      ),
                      if (_isGiftOrder) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: _giftNoteCtrl,
                          decoration: InputDecoration(
                            hintText: 'Add a personalized gift message...',
                            hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9EA59D)),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F6),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Your Basket (3) Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
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
                      InkWell(
                        onTap: () => setState(() => _isBasketExpanded = !_isBasketExpanded),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Basket (${_basketItems.length})',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1C1E),
                                ),
                              ),
                              Icon(
                                _isBasketExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isBasketExpanded) ...[
                        const Divider(color: Color(0xFFEEEEF0), height: 1),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _basketItems.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Color(0xFFEEEEF0), height: 1, indent: 16, endIndent: 16),
                          itemBuilder: (context, index) {
                            final item = _basketItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item['image'],
                                      width: 52,
                                      height: 52,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 52,
                                        height: 52,
                                        color: const Color(0xFFF3F3F6),
                                        child: const Icon(Icons.shopping_basket, color: Color(0xFF006B23)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
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
                                          '\$${(item['price'] as double).toStringAsFixed(2)}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1A1C1E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2EBE2),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _updateQty(index, -1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.remove, size: 14, color: Color(0xFF006B23)),
                                          ),
                                        ),
                                        Text(
                                          '${item['qty']}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1A1C1E),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _updateQty(index, 1),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.add, size: 14, color: Color(0xFF006B23)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Bill Summary Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
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
                      _buildBillRow('Item Total', '\$${_itemTotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Delivery Fee',
                                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C)),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF6E7A6C)),
                            ],
                          ),
                          Text(
                            deliveryFee == 0 ? '\$0.00 (FREE)' : '\$${deliveryFee.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildBillRow('Taxes & Charges', '\$${_taxes.toStringAsFixed(2)}'),
                      if (discount > 0) ...[
                        const SizedBox(height: 10),
                        _buildBillRow(
                          'Coupon Discount (${couponProvider.appliedCoupon!.code})',
                          '-\$${discount.toStringAsFixed(2)}',
                          isDiscount: true,
                        ),
                      ],
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
                            '\$${grandTotal.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Apply Promo Code Box / Active Coupon Tile
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/coupons'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: couponProvider.appliedCoupon != null
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFF3FBF4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: couponProvider.appliedCoupon != null
                                  ? const Color(0xFF006B23)
                                  : const Color(0xFFC0E8C7),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                couponProvider.appliedCoupon != null
                                    ? Icons.check_circle_rounded
                                    : Icons.local_offer_outlined,
                                color: const Color(0xFF006B23),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      couponProvider.appliedCoupon != null
                                          ? 'Coupon "${couponProvider.appliedCoupon!.code}" Active'
                                          : 'Apply Promo Code / View Coupons',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF006B23),
                                      ),
                                    ),
                                    if (couponProvider.appliedCoupon != null && discount > 0)
                                      Text(
                                        'Saving \$${discount.toStringAsFixed(2)} on this order',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF006B23),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (couponProvider.appliedCoupon != null)
                                GestureDetector(
                                  onTap: () {
                                    couponProvider.removeCoupon();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Coupon Removed'),
                                        backgroundColor: Color(0xFF006B23),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'REMOVE',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFD32F2F),
                                    ),
                                  ),
                                )
                              else
                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF006B23), size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 4. Cancellation Policy Note
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, color: Color(0xFF1A1C1E), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Orders cannot be cancelled once they are out for delivery. View policy.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 16 / 12,
                            color: const Color(0xFF6E7A6C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),

          // ─── 5. Fixed Bottom Action Bar (Select Payment Method) ────────────
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
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PaymentScreen()),
                      );
                    },
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
                        Text(
                          'Select Payment Method',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
                      ],
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

  Widget _buildBillRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w400,
            color: isDiscount ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isDiscount ? FontWeight.w700 : FontWeight.w400,
            color: isDiscount ? const Color(0xFF006B23) : const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}
