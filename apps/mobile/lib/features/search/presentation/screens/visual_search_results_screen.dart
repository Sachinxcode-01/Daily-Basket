import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/visual_search_provider.dart';
import '../../../../shared/widgets/favorite_button.dart';

class VisualSearchResultsScreen extends StatelessWidget {
  const VisualSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VisualSearchProvider>();
    final cartProvider = context.read<CartProvider>();
    final metadata = provider.extractedMetadata;
    final matches = provider.matchedProducts;

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
          'Results from Camera Search',
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
                            metadata.productName,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Brand: ${metadata.brand} • ${metadata.weight}',
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Matches Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Matching Products in Catalog',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${matches.length} found',
                  style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ranked Matches List
            if (matches.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final p = matches[index];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image & Badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                p.imageUrl,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006B23),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${p.confidencePercentage.toStringAsFixed(0)}% MATCH',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.name,
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF0F172A),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FavoriteButton(
                                    productId: p.id,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${p.brand} • ${p.unit}',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Price & Add to Cart
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '₹${p.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.outfit(
                                          color: const Color(0xFF006B23),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '₹${p.mrp.toStringAsFixed(0)}',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF94A3B8),
                                          fontSize: 12,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Add to Cart Button
                                  ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      cartProvider.updateQuantityById(
                                        id: p.id,
                                        name: p.name,
                                        subtitle: p.unit,
                                        price: p.price,
                                        image: p.imageUrl,
                                        delta: 1,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Added ${p.name} to cart!'),
                                          backgroundColor: const Color(0xFF006B23),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF006B23),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'ADD',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
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
                  );
                },
              )
            else ...[
              // No Exact Match Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, color: Color(0xFF94A3B8), size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'No exact match found in current inventory.',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Check similar products or same brand alternatives below.',
                      style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Similar Products Recommendations
            if (provider.similarProducts.isNotEmpty) ...[
              Text(
                'Similar Products You Might Like',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0F172A),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.similarProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final item = provider.similarProducts[i];
                    return Container(
                      width: 140,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(item.imageUrl, height: 90, width: 120, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.name,
                            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(item.unit, style: GoogleFonts.inter(fontSize: 11, color: Colors.black54)),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${item.price.toStringAsFixed(0)}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF006B23))),
                              const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF006B23), size: 20),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
