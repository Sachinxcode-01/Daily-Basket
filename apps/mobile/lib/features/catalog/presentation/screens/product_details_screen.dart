import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';

/// Product Details Screen — Google Stitch Design System Exact Replica + Rich Product Info
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
  bool _priceDropAlert = false;
  int _helpfulVotes = 42;
  bool _votedHelpful = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<RecentlyViewedProvider>().addRecentlyViewed({
          'id': widget.productId,
          'name': widget.productName,
          'brand': 'Organic Produce',
          'unit': widget.unitDetails,
          'price': widget.price,
          'mrp': widget.mrp,
          'imageUrl': widget.imageUrl,
        });
      } catch (_) {}
    });
  }

  void _updateQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try {
      cartProvider = context.watch<CartProvider>();
    } catch (_) {}

    final numericPrice = double.tryParse(widget.price.replaceAll('₹', '')) ?? 120.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
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
                        color: Color(0xFF1E293B),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF1E293B),
                            child: const Center(
                              child: Icon(Icons.eco_rounded, size: 80, color: Color(0xFF2DD4BF)),
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
                                  color: const Color(0xFF1E293B).withValues(alpha: 0.90),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF334155)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x40000000),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2DD4BF), size: 22),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B).withValues(alpha: 0.90),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF334155)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x40000000),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: FavoriteButton(
                                      productId: widget.productId,
                                      productDetails: {
                                        'id': widget.productId,
                                        'name': widget.productName,
                                        'brand': 'Organic India',
                                        'weight': widget.unitDetails,
                                        'price': numericPrice,
                                        'mrp': double.tryParse(widget.mrp.replaceAll('₹', '')) ?? 150.0,
                                        'category': widget.categoryTag,
                                        'imageUrl': widget.imageUrl,
                                      },
                                      padding: EdgeInsets.zero,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Product link copied to clipboard! Share with friends.'),
                                        backgroundColor: Color(0xFF0F766E),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B).withValues(alpha: 0.90),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF334155)),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x40000000),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.share_outlined, color: Color(0xFF2DD4BF), size: 22),
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
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF334155)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x20000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
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
                                color: const Color(0xFF2DD4BF),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.productName,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                                    color: const Color(0xFF2DD4BF),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.mrp,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xFF94A3B8),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: const Color(0xFF94A3B8),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                                    ),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 14),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.discountPercentage,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
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
                                color: const Color(0xFF94A3B8),
                              ),
                            ),

                            const SizedBox(height: 14),
                            // Price Drop Alert Toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.notifications_active_outlined, size: 18, color: Color(0xFF2DD4BF)),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Notify on Price Drop',
                                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _priceDropAlert,
                                  activeThumbColor: const Color(0xFF2DD4BF),
                                  activeTrackColor: const Color(0xFF0F766E),
                                  inactiveThumbColor: const Color(0xFF64748B),
                                  inactiveTrackColor: const Color(0xFF334155),
                                  onChanged: (val) {
                                    setState(() => _priceDropAlert = val);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(val ? 'Price drop alert set!' : 'Price drop alert removed.'),
                                        backgroundColor: const Color(0xFF0F766E),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. Lightning Fast Delivery Guarantee Banner Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F766E),
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
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                                      children: [
                                        const TextSpan(text: 'Arriving in '),
                                        TextSpan(
                                          text: widget.deliveryTime,
                                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2DD4BF)),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Creamy, rich, and perfectly ripened. These organic Hass avocados are hand-picked from sustainable farms. Known for their bumpy skin and buttery texture, they are ideal for guacamole, toast, or slicing over a fresh salad. Rich in healthy fats and vitamins.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 22 / 14,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 5. Product Information & Attributes Grid
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Information',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Shelf Life', '3 to 5 days'),
                            const Divider(color: Color(0xFF334155), height: 16),
                            _buildInfoRow('Country of Origin', 'India'),
                            const Divider(color: Color(0xFF334155), height: 16),
                            _buildInfoRow('Storage Instructions', 'Store at room temperature until ripe'),
                            const Divider(color: Color(0xFF334155), height: 16),
                            _buildInfoRow('Return Policy', 'Eligible for 24-hr replacement'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 6. Nutritional Value Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF334155)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x20000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.eco_outlined, color: Color(0xFF2DD4BF), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Nutritional Value (Per 100g)',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildNutritionRow('Calories', '160 kcal'),
                            const Divider(color: Color(0xFF334155), height: 16),
                            _buildNutritionRow('Total Fat', '15g'),
                            const Divider(color: Color(0xFF334155), height: 16),
                            _buildNutritionRow('Potassium', '485mg'),
                            const Divider(color: Color(0xFF334155), height: 16),
                            _buildNutritionRow('Protein', '2g'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 7. Customer Ratings & Reviews
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ratings & Reviews',
                                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F766E),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.8',
                                        style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('128 verified ratings', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
                            const Divider(color: Color(0xFF334155), height: 20),

                            // Sample Review Card
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Color(0xFF0F766E),
                                  child: Icon(Icons.person, size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Priya S.', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.4)),
                                          ),
                                          child: Text('Verified Buyer', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF2DD4BF), fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    Text('2 days ago', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Super fresh avocados! They were perfectly ripe in two days just like promised.',
                              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _votedHelpful = !_votedHelpful;
                                  _helpfulVotes += _votedHelpful ? 1 : -1;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(_votedHelpful ? Icons.thumb_up : Icons.thumb_up_outlined, size: 14, color: const Color(0xFF2DD4BF)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Helpful ($_helpfulVotes)',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF2DD4BF)),
                                  ),
                                ],
                              ),
                            ),
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

          // ─── 8. Fixed Bottom Action Bar ────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                border: Border(
                  top: BorderSide(color: Color(0xFF334155), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
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
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateQuantity(-1),
                            icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                            constraints: const BoxConstraints(minWidth: 32),
                            padding: EdgeInsets.zero,
                          ),
                          Text(
                            '$_quantity',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _updateQuantity(1),
                            icon: const Icon(Icons.add, color: Color(0xFF2DD4BF), size: 18),
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
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4014B8A6),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (cartProvider != null) {
                                cartProvider.updateQuantityById(
                                  id: widget.productId,
                                  name: widget.productName,
                                  subtitle: widget.unitDetails,
                                  price: numericPrice,
                                  image: widget.imageUrl,
                                  delta: _quantity,
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added $_quantity x ${widget.productName} to cart!'),
                                  backgroundColor: const Color(0xFF0F766E),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Add to Cart • ₹${(numericPrice * _quantity).round()}',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8))),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8))),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
