import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../referral/providers/coupon_provider.dart';
import '../../../wallet/providers/wallet_provider.dart';

/// Your Basket / Cart Screen — Google Stitch Design System Exact Replica
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

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

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  String _selectedSubstitution = 'Call me for replacement';

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

  final double _baseDeliveryFee = 50.0;
  final double _taxes = 30.0;

  void _showCouponSheet(BuildContext context, CouponProvider? couponProvider, double currentItemTotal) {
    if (couponProvider == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9FC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBECAB9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Apply Coupon & Offers',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF1A1C1E)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Promo Input Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Enter Promo Code (e.g. WELCOME100, FRESH20)',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9EA59D)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFBECAB9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFBECAB9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF006B23), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final result = couponProvider.applyCouponByCode(
                        _promoController.text,
                        currentItemTotal,
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          backgroundColor: result.success ? const Color(0xFF006B23) : const Color(0xFFD32F2F),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'APPLY',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Available Coupons',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1E)),
              ),
              const SizedBox(height: 12),

              // List of available coupons
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: couponProvider.availableCoupons.length,
                  itemBuilder: (context, idx) {
                    final coupon = couponProvider.availableCoupons[idx];
                    final isCurrent = couponProvider.appliedCoupon?.code == coupon.code;
                    final isEligible = currentItemTotal >= coupon.minOrderAmount;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent ? const Color(0xFF006B23) : const Color(0xFFBECAB9).withValues(alpha: 0.3),
                          width: isCurrent ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: coupon.discountBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(coupon.icon, color: coupon.discountColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      coupon.code,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1C1E),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: coupon.discountBg,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${coupon.discountDisplay} ${coupon.discountSub}',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: coupon.discountColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  coupon.subtitle,
                                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6E7A6C)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              if (isCurrent) {
                                couponProvider.removeCoupon();
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coupon Removed'),
                                    backgroundColor: Color(0xFF006B23),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                final res = couponProvider.applyCoupon(coupon, currentItemTotal);
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res.message),
                                    backgroundColor: res.success ? const Color(0xFF006B23) : const Color(0xFFD32F2F),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              isCurrent ? 'REMOVE' : (isEligible ? 'APPLY' : 'DETAILS'),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isCurrent ? const Color(0xFFD32F2F) : const Color(0xFF006B23),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CouponProvider? couponProvider;
    WalletProvider? walletProvider;
    LanguageProvider? languageProvider;
    CartProvider? cartProvider;

    try { couponProvider = context.watch<CouponProvider>(); } catch (_) {}
    try { walletProvider = context.watch<WalletProvider>(); } catch (_) {}
    try { languageProvider = context.watch<LanguageProvider>(); } catch (_) {}
    try { cartProvider = context.watch<CartProvider>(); } catch (_) {}

    final List<Map<String, dynamic>> activeItems = cartProvider != null
        ? cartProvider.items.map((i) => <String, dynamic>{
              'id': i.id,
              'name': i.name,
              'subtitle': i.subtitle,
              'price': i.price.round(),
              'qty': i.qty,
              'image': i.image,
            }).toList()
        : _items;

    final double itemTotalDouble = cartProvider != null
        ? cartProvider.itemTotalDouble
        : _itemTotal.toDouble();

    final double discount = couponProvider?.calculateDiscount(itemTotalDouble) ?? 0.0;
    final double deliveryFee = couponProvider?.calculateDeliveryFee(_baseDeliveryFee, itemTotalDouble) ?? _baseDeliveryFee;
    final double toPayBeforeWallet = (itemTotalDouble - discount + deliveryFee + _taxes).clamp(0.0, double.infinity);
    final double walletDeduction = walletProvider?.calculateWalletDeduction(toPayBeforeWallet) ?? 0.0;
    final double toPay = (toPayBeforeWallet - walletDeduction).clamp(0.0, double.infinity);

    final bool isWalletActive = walletProvider?.useWalletForPayment ?? false;
    final double walletBalance = walletProvider?.balance ?? 150.0;

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
          languageProvider?.translate('cart', 'Cart') ?? 'Cart',
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
                Text(
                  languageProvider?.translate('your_items', 'Your Items') ?? 'Your Items',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),

                const SizedBox(height: 10),

                // 3. Your Items Container (White Card with Dividers)
                activeItems.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.shopping_basket_outlined, size: 48, color: Color(0xFF6E7A6C)),
                            const SizedBox(height: 12),
                            Text(
                              languageProvider?.translate('empty_cart', 'Your basket is empty') ?? 'Your basket is empty',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)),
                            ),
                          ],
                        ),
                      )
                    : Container(
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
                          children: List.generate(activeItems.length, (index) {
                            final item = activeItems[index];
                            final isLast = index == activeItems.length - 1;
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
                                            Row(
                                              children: [
                                                Text(
                                                  '₹${item['price']}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF1A1C1E),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (cartProvider != null) {
                                                      cartProvider.saveForLater(item['id']);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Moved to Saved for Later'),
                                                          duration: Duration(seconds: 2),
                                                          behavior: SnackBarBehavior.floating,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    'Save for later',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF006B23),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                              onTap: () {
                                                if (cartProvider != null) {
                                                  cartProvider.updateQuantity(index, -1);
                                                } else {
                                                  _updateQuantity(index, -1);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  isLast && item['qty'] == 1
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
                                              onTap: () {
                                                if (cartProvider != null) {
                                                  cartProvider.updateQuantity(index, 1);
                                                } else {
                                                  _updateQuantity(index, 1);
                                                }
                                              },
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
                                    indent: 80,
                                    endIndent: 16,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),

                if (cartProvider != null && cartProvider.savedForLater.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Saved For Later (${cartProvider.savedForLater.length})',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: cartProvider.savedForLater.map((sItem) {
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  sItem.image,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 48, height: 48, color: const Color(0xFFF3F3F6),
                                    child: const Icon(Icons.shopping_basket, size: 24, color: Color(0xFF006B23)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sItem.name,
                                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)),
                                    ),
                                    Text(
                                      '₹${sItem.price.round()}',
                                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF006B23)),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  if (cartProvider != null) {
                                    cartProvider.moveToCart(sItem.id);
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF006B23)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                child: Text(
                                  'Move to Cart',
                                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF006B23)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Item Substitution Preferences Card
                Container(
                  padding: const EdgeInsets.all(14),
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
                          const Icon(Icons.published_with_changes_rounded, color: Color(0xFF006B23), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'If items are out of stock:',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildSubstitutionChip('Call me for replacement'),
                          const SizedBox(width: 8),
                          _buildSubstitutionChip('Replace with organic'),
                          const SizedBox(width: 8),
                          _buildSubstitutionChip('Refund missing item'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 5. Apply Coupon Card / Active Coupon Tile
                GestureDetector(
                  onTap: () => _showCouponSheet(context, couponProvider, itemTotalDouble),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: couponProvider?.appliedCoupon != null
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFF3F3F6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: couponProvider?.appliedCoupon != null
                            ? const Color(0xFF006B23)
                            : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          couponProvider?.appliedCoupon != null
                              ? Icons.check_circle_rounded
                              : Icons.local_offer_outlined,
                          color: const Color(0xFF006B23),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                couponProvider?.appliedCoupon != null
                                    ? 'Coupon "${couponProvider!.appliedCoupon!.code}" Applied'
                                    : 'Apply Coupon / Promo Code',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1C1E),
                                ),
                              ),
                              if (couponProvider?.appliedCoupon != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  discount > 0
                                      ? 'You saved ₹${discount.toStringAsFixed(2)} with this coupon'
                                      : couponProvider!.appliedCoupon!.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF006B23),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (couponProvider?.appliedCoupon != null)
                          TextButton(
                            onPressed: () {
                              couponProvider?.removeCoupon();
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
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFD32F2F),
                              ),
                            ),
                          )
                        else
                          const Icon(Icons.chevron_right_rounded,
                              color: Color(0xFF6E7A6C), size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Wallet Balance Pay Tile
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isWalletActive ? const Color(0xFFE8F5E9) : const Color(0xFFF3F3F6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isWalletActive ? const Color(0xFF006B23) : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF006B23), size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageProvider?.translate('pay_using_wallet', 'Pay using Daily Basket Wallet') ?? 'Pay using Daily Basket Wallet',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            Text(
                              '${languageProvider?.translate('available_balance', 'Available') ?? 'Available'}: ₹${walletBalance.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6E7A6C)),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: isWalletActive,
                        activeTrackColor: const Color(0xFF006B23),
                        onChanged: (val) => walletProvider?.toggleWalletPayment(val),
                      ),
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
                      _buildBillRow(
                        'Item Total (${cartProvider?.totalCount ?? _totalCount} items)',
                        '₹${itemTotalDouble.toStringAsFixed(0)}',
                      ),
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
                                  deliveryFee == 0 ? 'FREE' : 'Surge',
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
                            deliveryFee == 0 ? '₹0 (FREE)' : '₹${deliveryFee.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: deliveryFee == 0 ? FontWeight.w700 : FontWeight.w400,
                              color: deliveryFee == 0 ? const Color(0xFF006B23) : const Color(0xFF1A1C1E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildBillRow('Taxes & Charges', '₹${_taxes.toStringAsFixed(0)}'),
                      if (discount > 0) ...[
                        const SizedBox(height: 10),
                        _buildBillRow(
                          'Coupon Discount (${couponProvider?.appliedCoupon?.code ?? ""})',
                          '-₹${discount.toStringAsFixed(2)}',
                          isDiscount: true,
                        ),
                      ],
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
                            '₹${toPay.toStringAsFixed(2)}',
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
                      Navigator.of(context).pushNamed('/checkout');
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
                                '₹${toPay.toStringAsFixed(2)}',
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
                                'Proceed to Checkout',
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

  Widget _buildSubstitutionChip(String label) {
    final isSelected = _selectedSubstitution == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSubstitution = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF3F3F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF006B23) : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF006B23) : const Color(0xFF6E7A6C),
            ),
          ),
        ),
      ),
    );
  }

  Widget _missingEssentialPill(String name, String price, VoidCallback onAdd) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBECAB9)),
      ),
      child: Row(
        children: [
          Text('$name ($price)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E))),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Color(0xFF006B23), shape: BoxShape.circle),
              child: const Icon(Icons.add, size: 14, color: Colors.white),
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

