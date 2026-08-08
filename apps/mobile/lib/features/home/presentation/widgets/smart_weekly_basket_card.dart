import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';

class SmartWeeklyBasketCard extends StatelessWidget {
  const SmartWeeklyBasketCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    final List<Map<String, dynamic>> predictedStaples = [
      {
        'id': 'p_milk_1l',
        'name': 'Amul Taaza Milk 1L',
        'price': 56.0,
        'unit': '1L',
        'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        'reason': 'Purchased every 2 days',
      },
      {
        'id': 'p_atta_5kg',
        'name': 'Aashirvaad Chakki Atta 5kg',
        'price': 280.0,
        'unit': '5kg',
        'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        'reason': 'Reorder interval (14 days)',
      },
      {
        'id': 'p_eggs_10',
        'name': 'Farm Fresh Eggs (Pack of 10)',
        'price': 85.0,
        'unit': '10 pcs',
        'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        'reason': 'Weekly staple prediction',
      },
    ];

    final double totalStaplesAmount =
        predictedStaples.fold(0.0, (sum, i) => sum + (i['price'] as double));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Color(0xFF34D399), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Smart Weekly Basket',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'AI predicted staples based on your order patterns',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Items List Preview
          Column(
            children: predictedStaples.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image'],
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            item['reason'],
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF34D399),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${item['price'].toStringAsFixed(0)}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // 1-Tap Add All Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added all ${predictedStaples.length} Smart Weekly items (₹${totalStaplesAmount.toStringAsFixed(0)}) to your basket!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: Text(
                'Add All ${predictedStaples.length} Staples to Basket (₹${totalStaplesAmount.toStringAsFixed(0)})',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
