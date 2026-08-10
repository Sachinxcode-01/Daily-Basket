// Google Stitch Screen ID: 6b2f3bdb3dca4c43954638dd8af95506
// Title: Secure Enterprise Checkout Flow - Checkout Experience
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/checkout_provider.dart';
import '../../../referral/providers/coupon_provider.dart';
import 'payment_screen.dart';

/// Checkout Summary / Confirm Order Screen — Google Stitch Design System Source of Truth
/// Wired to real CartProvider & CheckoutProvider for dynamic backend-driven calculation.
class CheckoutScreen extends StatefulWidget {
  static const String stitchId = '6b2f3bdb3dca4c43954638dd8af95506';

  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isBasketExpanded = true;
  String _selectedSlot = 'Instant (10-15 mins)';
  final TextEditingController _couponCtrl = TextEditingController();

  final List<String> _deliverySlots = [
    'Instant (10-15 mins)',
    'Today Evening (6 PM - 8 PM)',
    'Tomorrow Morning (7 AM - 9 AM)',
    'Tomorrow Evening (6 PM - 8 PM)',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recalculate();
    });
  }

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  void _recalculate() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

    List<CartItem> items = cartProvider.items;
    if (items.isEmpty) {
      items = [
        CartItem(id: 'b1', name: 'Organic Whole Milk', subtitle: '1 Litre Bottle', price: 3.50, qty: 1, image: ''),
        CartItem(id: 'b2', name: 'Artisan Sourdough', subtitle: '500g Loaf', price: 5.20, qty: 1, image: ''),
        CartItem(id: 'b3', name: 'Premium Bananas', subtitle: 'Bunch of 4-5', price: 2.80, qty: 1, image: ''),
      ];
    }

    checkoutProvider.recalculatePricing(cartItems: items);
  }

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try {
      cartProvider = context.watch<CartProvider>();
    } catch (_) {}

    final checkoutProvider = context.watch<CheckoutProvider>();
    final couponProvider = context.watch<CouponProvider>();

    List<CartItem> items = (cartProvider != null && !cartProvider.isEmpty)
        ? cartProvider.items
        : [
            CartItem(id: 'b1', name: 'Organic Whole Milk', subtitle: '1 Litre Bottle', price: 3.50, qty: 1, image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&q=80'),
            CartItem(id: 'b2', name: 'Artisan Sourdough', subtitle: '500g Loaf', price: 5.20, qty: 1, image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80'),
            CartItem(id: 'b3', name: 'Premium Bananas', subtitle: 'Bunch of 4-5', price: 2.80, qty: 1, image: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=200&q=80'),
          ];

    final pricing = checkoutProvider.pricing;

    final double subtotal = pricing?.subtotal ?? items.fold(0.0, (sum, i) => sum + (i.price * i.qty));
    final double couponDiscount = pricing?.couponDiscount ?? couponProvider.calculateDiscount(subtotal);
    final double deliveryFee = pricing?.deliveryFee ?? (subtotal >= 199 ? 0.0 : 25.0);
    final double platformFee = pricing?.platformFee ?? (subtotal > 0 ? 3.0 : 0.0);
    final double packagingFee = pricing?.packagingFee ?? (subtotal > 0 ? 5.0 : 0.0);
    final double totalGst = pricing?.totalGst ?? (subtotal * 0.05);
    final double walletDeducted = pricing?.walletDeducted ?? (checkoutProvider.useWallet ? 150.0 : 0.0);
    final double grandTotal = pricing?.grandTotal ?? (subtotal + deliveryFee + platformFee + packagingFee + totalGst - couponDiscount);
    final double finalPayable = pricing?.finalPayable ?? (grandTotal - walletDeducted).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Checkout Summary',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket_outlined, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Delivery Slot & Address Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery Slot',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedSlot,
                                    isExpanded: true,
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _selectedSlot = val);
                                        checkoutProvider.setDeliverySlot(val);
                                        _recalculate();
                                      }
                                    },
                                    items: _deliverySlots.map((s) {
                                      return DropdownMenuItem(value: s, child: Text(s));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: Color(0xFFE2E8F0)),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivering to Home',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  'Flat 402, Sunshine Heights, Indiranagar, Bengaluru',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Change',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Basket Items Collapsible Summary Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _isBasketExpanded = !_isBasketExpanded),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Order Items (${items.length})',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                _isBasketExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isBasketExpanded) ...[
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          itemBuilder: (ctx, idx) {
                            final item = items[idx];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                        Text(
                                          '₹${item.price.toStringAsFixed(2)} x ${item.qty}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${(item.price * item.qty).toStringAsFixed(2)}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Coupons & Wallet Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Coupons & Offers',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponCtrl,
                              decoration: InputDecoration(
                                hintText: 'Enter Coupon (e.g. DAILY50)',
                                hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final code = _couponCtrl.text.trim();
                              if (code.isNotEmpty) {
                                checkoutProvider.setCoupon(code);
                                _recalculate();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('APPLY', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ],
                      ),
                      if (checkoutProvider.appliedCouponCode != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Coupon "${checkoutProvider.appliedCouponCode}" Applied!',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                checkoutProvider.setCoupon(null);
                                _couponCtrl.clear();
                                _recalculate();
                              },
                              child: Text('Remove', style: GoogleFonts.inter(fontSize: 12, color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                      const Divider(height: 24, color: Color(0xFFE2E8F0)),
                      SwitchListTile(
                        value: checkoutProvider.useWallet,
                        onChanged: (val) {
                          checkoutProvider.toggleWallet(val);
                          _recalculate();
                        },
                        title: Text(
                          'Use Daily Basket Wallet',
                          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                        subtitle: Text(
                          'Available Balance: ₹150.00',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                        ),
                        activeTrackColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Detailed Bill Breakdown Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Details & Breakdown',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _billRow('Items Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                      if (couponDiscount > 0)
                        _billRow('Coupon Savings', '-₹${couponDiscount.toStringAsFixed(2)}', isDiscount: true),
                      _billRow('Delivery Partner Fee', deliveryFee == 0 ? 'FREE' : '₹${deliveryFee.toStringAsFixed(2)}', isFree: deliveryFee == 0),
                      _billRow('Platform Fee', '₹${platformFee.toStringAsFixed(2)}'),
                      _billRow('Packaging & Quality Fee', '₹${packagingFee.toStringAsFixed(2)}'),
                      _billRow('Taxes & GST (5%)', '₹${totalGst.toStringAsFixed(2)}'),
                      const Divider(height: 20, color: Color(0xFFE2E8F0)),
                      _billRow('Grand Total', '₹${grandTotal.toStringAsFixed(2)}', isBold: true),
                      if (walletDeducted > 0)
                        _billRow('Wallet Payment', '-₹${walletDeducted.toStringAsFixed(2)}', isDiscount: true),
                      const Divider(height: 20, color: Color(0xFFE2E8F0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Final Payable Amount',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '₹${finalPayable.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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

          // 5. Fixed Bottom Checkout Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              '₹${finalPayable.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                checkoutProvider.selectedPaymentMethod,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'TOTAL PAYABLE',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              totalAmount: finalPayable,
                              itemQuantity: items.length,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'PROCEED TO PAY',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _billRow(String label, String value, {bool isDiscount = false, bool isFree = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? AppColors.onSurface : AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? AppColors.primary
                  : (isFree ? AppColors.primary : AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
