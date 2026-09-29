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
      'id': 'prod_milk_001',
      'name': 'Amul Buffalo Milk A2 Pouch',
      'subtitle': '1 L Pouch',
      'brand': 'Amul',
      'price': 68.0,
      'priceStr': '₹68',
      'mrpStr': '₹75',
      'category': 'DAIRY & MILK',
      'imageUrl': 'assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
    },
    {
      'id': 'prod_veg_001',
      'name': 'Fresh Country Tomatoes (Tamatar)',
      'subtitle': '500 g',
      'brand': 'Farm Fresh',
      'price': 24.0,
      'priceStr': '₹24',
      'mrpStr': '₹35',
      'category': 'FRESH VEGETABLES',
      'imageUrl': 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    },
    {
      'id': 'prod_bread_001',
      'name': 'Britannia 100% Whole Wheat Bread',
      'subtitle': '400 g Pack',
      'brand': 'Britannia',
      'price': 45.0,
      'priceStr': '₹45',
      'mrpStr': '₹50',
      'category': 'BREAD & BAKERY',
      'imageUrl': 'assets/products/bread-pav/007ea008-b857-4dd5-9005-fb6c4d98601b.png',
    },
    {
      'id': 'prod_curd_001',
      'name': 'Amul Masti Set Curd',
      'subtitle': '400 g Tub',
      'brand': 'Amul',
      'price': 35.0,
      'priceStr': '₹35',
      'mrpStr': '₹40',
      'category': 'CURD & YOGURT',
      'imageUrl': 'assets/products/curd-yogurt/01278ea4-9aef-4263-8ea8-6a3eab2bd076.png',
    },
    {
      'id': 'prod_poha_001',
      'name': 'Rajdhani Thick Poha',
      'subtitle': '500 g Pack',
      'brand': 'Rajdhani',
      'price': 42.0,
      'priceStr': '₹42',
      'mrpStr': '₹52',
      'category': 'POHA & GRAINS',
      'imageUrl': 'assets/products/poha-daliya-grains/1092_1643384330629.png',
    },
    {
      'id': 'prod_vermi_001',
      'name': 'MTR Roasted Vermicelli',
      'subtitle': '400 g Pack',
      'brand': 'MTR',
      'price': 42.0,
      'priceStr': '₹42',
      'mrpStr': '₹50',
      'category': 'VERMICELLI',
      'imageUrl': 'assets/products/vermicelli/3da21b8f-16e5-4727-9899-c5ef3e1db668.png',
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

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product-details',
                    arguments: {
                      'productId': item['id'],
                      'productName': item['name'],
                      'brand': item['brand'] ?? 'Daily Basket',
                      'categoryTag': item['category'] ?? 'GROCERY',
                      'price': item['priceStr'],
                      'mrp': item['mrpStr'],
                      'unitDetails': item['subtitle'],
                      'imageUrl': item['imageUrl'],
                      'deliveryTime': '10 mins',
                    },
                  );
                },
                child: Container(
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
                        fit: BoxFit.contain,
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
              ),
            );
          },
          ),
        ),
      ],
    );
  }
}
