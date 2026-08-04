import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Product Details Screen — Google Stitch Design System Exact Replica
class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String categoryTag;
  final String productName;
  final String price;
  final String mrp;
  final String discountPercentage;
  final String unitDetails;
  final String deliveryTime;
  final String imageUrl;

  const ProductDetailsScreen({
    super.key,
    this.productId = 'prod_avocado',
    this.categoryTag = 'ORGANIC PRODUCE',
    this.productName = 'Organic Hass Avocados',
    this.price = '₹120',
    this.mrp = '₹150',
    this.discountPercentage = '20% OFF',
    this.unitDetails = '2 units (Approx. 400g)',
    this.deliveryTime = '8 mins',
    this.imageUrl = 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80',
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isWishlisted = false;

  void _updateQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: Stack(
        children: [
          // ─── Scrollable Page Content ──────────────────────────────────────
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Container
                Stack(
                  children: [
                    Container(
                      height: 340,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEFEF),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFE8F5E9),
                            child: const Center(
                              child: Icon(Icons.eco_rounded, size: 80, color: Color(0xFF006B23)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top Action Floating Buttons (Back, Favorite, Share)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.90),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E), size: 22),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.90),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: _isWishlisted ? const Color(0xFFBA1A1A) : const Color(0xFF1A1C1E),
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Product link copied to clipboard!')),
                                    );
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.90),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.share_outlined, color: Color(0xFF1A1C1E), size: 22),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Product Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.categoryTag,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: const Color(0xFF006B23),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.productName,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  widget.price,
                                  style: GoogleFonts.outfit(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A1C1E),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.mrp,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF6E7A6C),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.local_fire_department_rounded, color: Color(0xFFBA1A1A), size: 14),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.discountPercentage,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFBA1A1A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.unitDetails,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. Lightning Fast Delivery Guarantee Banner Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFF006B23),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lightning Fast Delivery',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF3F4A3D)),
                                      children: [
                                        const TextSpan(text: 'Arriving in '),
                                        TextSpan(
                                          text: widget.deliveryTime,
                                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF006B23)),
                                        ),
                                        const TextSpan(text: ' to your location.'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 4. Description Section
                      Text(
                        'Description',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creamy, rich, and perfectly ripened. These organic Hass avocados are hand-picked from sustainable farms. Known for their bumpy skin and buttery texture, they are ideal for guacamole, toast, or slicing over a fresh salad. Rich in healthy fats and vitamins.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 22 / 14,
                          color: const Color(0xFF3F4A3D),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 5. Nutritional Value Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.eco_outlined, color: Color(0xFF006B23), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Nutritional Value',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1C1E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildNutritionRow('Calories', '160 kcal'),
                            const Divider(color: Color(0xFFEEEFEF), height: 16),
                            _buildNutritionRow('Total Fat', '15g'),
                            const Divider(color: Color(0xFFEEEFEF), height: 16),
                            _buildNutritionRow('Potassium', '485mg'),
                            const Divider(color: Color(0xFFEEEFEF), height: 16),
                            _buildNutritionRow('Protein', '2g'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── 6. Fixed Bottom Action Bar ────────────────────────────────────
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
                child: Row(
                  children: [
                    // Quantity Selector Pill
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateQuantity(-1),
                            icon: const Icon(Icons.remove, color: Color(0xFF1A1C1E), size: 18),
                            constraints: const BoxConstraints(minWidth: 32),
                            padding: EdgeInsets.zero,
                          ),
                          Text(
                            '$_quantity',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _updateQuantity(1),
                            icon: const Icon(Icons.add, color: Color(0xFF006B23), size: 18),
                            constraints: const BoxConstraints(minWidth: 32),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Add to Cart Button
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added $_quantity x ${widget.productName} to cart!'),
                                backgroundColor: const Color(0xFF006B23),
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
                          child: Text(
                            'Add to Cart • ${widget.price}',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
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
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}
