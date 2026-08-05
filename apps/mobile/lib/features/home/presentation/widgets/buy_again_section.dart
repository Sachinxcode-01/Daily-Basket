import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Buy Again — shows items from last order for quick reorder.
/// Uses a static demo dataset until order history API is connected.
/// Reads CartProvider to show live qty stepper.
class BuyAgainSection extends StatelessWidget {
  const BuyAgainSection({super.key});

  // Demo past-order items (replaced with real API data when order history is fetched)
  static const List<Map<String, dynamic>> _pastItems = [
    {
      'id': 'ba_milk',
      'name': 'Amul Full Cream Milk',
      'subtitle': '1L Pouch',
      'price': 68.0,
      'priceStr': '₹68',
      'mrpStr': '₹72',
      'imageUrl': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
    },
    {
      'id': 'ba_eggs',
      'name': 'Farm Fresh Eggs',
      'subtitle': '12 pcs',
      'price': 90.0,
      'priceStr': '₹90',
      'mrpStr': '₹105',
      'imageUrl': 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?w=400',
    },
    {
      'id': 'ba_bread',
      'name': 'Britannia Brown Bread',
      'subtitle': '400g',
      'price': 45.0,
      'priceStr': '₹45',
      'mrpStr': '₹50',
      'imageUrl': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
    },
    {
      'id': 'ba_atta',
      'name': 'Aashirvaad Whole Wheat Atta',
      'subtitle': '5 kg Bag',
      'price': 265.0,
      'priceStr': '₹265',
      'mrpStr': '₹299',
      'imageUrl': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
    },
    {
      'id': 'ba_tomato',
      'name': 'Fresh Tomatoes',
      'subtitle': '500g',
      'price': 28.0,
      'priceStr': '₹28',
      'mrpStr': '₹40',
      'imageUrl': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try { cartProvider = context.watch<CartProvider>(); } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Buy Again',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/orders'),
                child: Text(
                  'View Orders',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF006B23),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 215,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: _pastItems.length,
            itemBuilder: (context, i) {
              final item = _pastItems[i];
              final qty = cartProvider?.getQuantity(item['id'] as String) ?? 0;

              return Container(
                width: 130,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: AppNetworkImage(
                        imageUrl: item['imageUrl'] as String,
                        width: 130,
                        height: 100,
                        fit: BoxFit.cover,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(9, 6, 9, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1C1E),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['priceStr'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF006B23),
                              ),
                            ),
                            const Spacer(),
                            qty == 0
                                ? SizedBox(
                                    width: double.infinity,
                                    height: 26,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        cartProvider?.updateQuantityById(
                                          id: item['id'] as String,
                                          name: item['name'] as String,
                                          subtitle: item['subtitle'] as String,
                                          price: item['price'] as double,
                                          image: item['imageUrl'] as String,
                                          delta: 1,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF006B23),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        'Add Again',
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF006B23),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              cartProvider?.updateQuantityById(
                                            id: item['id'] as String,
                                            name: item['name'] as String,
                                            subtitle: item['subtitle'] as String,
                                            price: item['price'] as double,
                                            image: item['imageUrl'] as String,
                                            delta: -1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6),
                                            child: Icon(Icons.remove,
                                                color: Colors.white, size: 13),
                                          ),
                                        ),
                                        Text(
                                          '$qty',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              cartProvider?.updateQuantityById(
                                            id: item['id'] as String,
                                            name: item['name'] as String,
                                            subtitle: item['subtitle'] as String,
                                            price: item['price'] as double,
                                            image: item['imageUrl'] as String,
                                            delta: 1,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6),
                                            child: Icon(Icons.add,
                                                color: Colors.white, size: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
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
    );
  }
}
