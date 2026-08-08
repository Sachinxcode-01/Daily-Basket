import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/visual_search_provider.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../widgets/multi_object_selector_card.dart';

class VisualSearchResultsScreen extends StatelessWidget {
  const VisualSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VisualSearchProvider>();
    final cartProvider = context.read<CartProvider>();
    final metadata = provider.extractedMetadata;
    final matches = provider.matchedProducts;

    // Simulated multi-object detected list for multi-product photo handling
    final List<dynamic> detectedItems = [
      {
        'detectedName': 'Amul Taaza Toned Milk 1L',
        'brand': 'Amul',
        'category': 'Dairy',
        'estimatedPrice': 56,
      },
      {
        'detectedName': 'Aashirvaad Shuddh Chakki Atta 5kg',
        'brand': 'Aashirvaad',
        'category': 'Atta & Flours',
        'estimatedPrice': 280,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Results from AI Visual Search',
          style: GoogleFonts.outfit(
            color: const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF006B23)),
            onPressed: () => Navigator.pushReplacementNamed(context, '/camera-search'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Extracted Metadata Header Banner
            if (metadata != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF006B23), Color(0xFF0F766E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF006B23).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Captured Thumbnail Preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        matches.isNotEmpty
                            ? matches.first.imageUrl
                            : 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'AI RECOGNIZED • ${metadata.confidenceScore}% MATCH',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            metadata.brand.isNotEmpty ? metadata.brand : 'Recognized Grocery Item',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'MRP ₹${metadata.mrp} • Net Vol ${metadata.weight}',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Multi-Object Product Selector Card
            MultiObjectSelectorCard(
              detectedItems: detectedItems,
              onAddSelectedToCart: (selected) {
                HapticFeedback.mediumImpact();
                for (var item in selected) {
                  cartProvider.addItem(
                    CartItem(
                      id: 'p_${item['detectedName']}',
                      name: item['detectedName'],
                      subtitle: item['category'] ?? '1 unit',
                      price: (item['estimatedPrice'] as num).toDouble(),
                      qty: 1,
                      image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                    ),
                  );
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added ${selected.length} items to your basket!')),
                );
              },
            ),

            // Recipe Detection & Ingredients Section
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🍳', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Smart Recipe Inference: Paneer Butter Masala',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Identified food dish from photo. 3 ingredients available in your local dark store.',
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFB45309)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        cartProvider.addItem(
                          CartItem(
                            id: 'p_paneer',
                            name: 'Fresh Paneer 200g',
                            subtitle: '200g',
                            price: 110.0,
                            qty: 1,
                            image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                          ),
                        );
                        cartProvider.addItem(
                          CartItem(
                            id: 'p_butter',
                            name: 'Amul Butter 100g',
                            subtitle: '100g',
                            price: 56.0,
                            qty: 1,
                            image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added recipe ingredients to your basket!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF92400E),
                        side: const BorderSide(color: Color(0xFFF59E0B)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                      label: const Text('Add Missing Recipe Ingredients (₹166)'),
                    ),
                  ),
                ],
              ),
            ),

            // Matches Header
            Text(
              'Matching Catalog Products (${matches.length})',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Matches Grid
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = matches[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${product.price} / ${product.unit}',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF006B23),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FavoriteButton(productId: product.id),
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.addItem(
                            CartItem(
                              id: product.id,
                              name: product.name,
                              subtitle: product.unit,
                              price: product.price,
                              qty: 1,
                              image: product.imageUrl,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added ${product.name} to basket!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B23),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
