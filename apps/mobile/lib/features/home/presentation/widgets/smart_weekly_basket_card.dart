import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../catalog/presentation/screens/product_details_screen.dart';

class SmartWeeklyBasketCard extends StatelessWidget {
  const SmartWeeklyBasketCard({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try {
      cartProvider = context.watch<CartProvider>();
    } catch (_) {
      try {
        cartProvider = context.read<CartProvider>();
      } catch (_) {}
    }

    final List<Map<String, dynamic>> predictedStaples = [
      {
        'id': 'p_milk_1l',
        'name': 'Amul Taaza Milk 1L',
        'price': 56.0,
        'unit': '1L',
        'image': 'assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png',
        'reason': 'Purchased every 2 days',
      },
      {
        'id': 'p_atta_5kg',
        'name': 'Aashirvaad Chakki Atta 5kg',
        'price': 280.0,
        'unit': '5kg',
        'image': 'assets/products/poha-daliya-grains/1092_1643384330629.png',
        'reason': 'Reorder interval (14 days)',
      },
      {
        'id': 'p_eggs_10',
        'name': 'Farm Fresh Eggs (Pack of 10)',
        'price': 85.0,
        'unit': '10 pcs',
        'image': 'assets/products/bread-pav/1200_1657599895699.png',
        'reason': 'Weekly staple prediction',
      },
    ];

    final double totalStaplesAmount =
        predictedStaples.fold(0.0, (sum, i) => sum + (i['price'] as double));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // surface-container-lowest: #ffffff per design.md
        borderRadius: BorderRadius.circular(16), // rounded-2xl bento card per design.md
        border: Border.all(
          color: const Color(0xFF2D9D43).withValues(alpha: 0.35), // primary outline per design.md
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D9D43).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D9D43).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF2D9D43), // primary: #2d9d43 per design.md
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Smart Weekly Basket',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191C1E), // on-surface: #191c1e per design.md
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'AI predicted staples based on your order patterns',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B), // on-surface-subtle: #64748b per design.md
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Items List Preview
          Column(
            children: predictedStaples.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                        productId: item['id'],
                        productName: item['name'],
                        unitDetails: item['unit'],
                        price: '₹${item['price'].toStringAsFixed(0)}',
                        imageUrl: item['image'],
                        categoryTag: 'STAPLES',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FC), // surface: #f9f9fc per design.md
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFBECAB9).withValues(alpha: 0.35), // outline-variant/30
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: const Color(0xFFF3F3F6), // surface-container-low
                          padding: const EdgeInsets.all(3),
                          child: AppNetworkImage(
                            imageUrl: item['image'],
                            width: 34,
                            height: 34,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF191C1E), // on-surface
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D9D43).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item['reason'],
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D9D43), // primary: #2d9d43
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${item['price'].toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF191C1E), // on-surface
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // 1-Tap Add All Button
          SizedBox(
            width: double.infinity,
            height: 48, // 48px touch target per design.md Section 4 & 5.4
            child: ElevatedButton.icon(
              onPressed: () {
                if (cartProvider != null) {
                  for (var item in predictedStaples) {
                    cartProvider.addItem(
                      CartItem(
                        id: item['id'],
                        name: item['name'],
                        subtitle: item['unit'],
                        price: item['price'],
                        qty: 1,
                        image: item['image'],
                      ),
                    );
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added all ${predictedStaples.length} Smart Weekly items (₹${totalStaplesAmount.toStringAsFixed(0)}) to your basket!',
                    ),
                    backgroundColor: const Color(0xFF2D9D43),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D9D43), // primary: #2d9d43 per design.md Section 2 & 5.4
                foregroundColor: Colors.white, // on-primary: #ffffff per design.md
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.white),
              label: Text(
                'Add All ${predictedStaples.length} Staples to Basket (₹${totalStaplesAmount.toStringAsFixed(0)})',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
