import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import 'reviews_recommendations_screen.dart';

/// Product Details Screen — Google Stitch Source of Truth Specification
/// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)
/// Screen: Product Details - Organic Avocados (ID: fed4975734304fada8e33c3c4c02a910)
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
    this.price = '\$5.99',
    this.mrp = '\$7.50',
    this.discountPercentage = '-20%',
    this.unitDetails = '500g ~3-4 pieces',
    this.deliveryTime = '15-30 mins',
    this.imageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAUZTLTSv5m1XvtD0eVooGUshRAE_TEf1VJ6rDo2p2NK8V-OtAgWRr9FnG7_wymxfNYoJbO-z3fuiHP_nel0NrAMmwbjTaJpS2Qn6gtKhCoGN6ltUY0Ye1kqsw-Lgi3oSwN5RBZcGCyK2PH3mZqTsqvfYztVjk3FZnajEMLUCbI6q8oB1hqEySrz4h9bFTXR1c7DcEprHGwUvQVM7TEPLq83eHICr5VanKASkHt7mYjWh7jE8sEGGd1',
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  String _selectedWeight = '500g ~3-4 pieces';

  List<String> get _galleryImages {
    final primary = widget.imageUrl.isNotEmpty
        ? widget.imageUrl
        : 'https://lh3.googleusercontent.com/aida-public/AB6AXuAUZTLTSv5m1XvtD0eVooGUshRAE_TEf1VJ6rDo2p2NK8V-OtAgWRr9FnG7_wymxfNYoJbO-z3fuiHP_nel0NrAMmwbjTaJpS2Qn6gtKhCoGN6ltUY0Ye1kqsw-Lgi3oSwN5RBZcGCyK2PH3mZqTsqvfYztVjk3FZnajEMLUCbI6q8oB1hqEySrz4h9bFTXR1c7DcEprHGwUvQVM7TEPLq83eHICr5VanKASkHt7mYjWh7jE8sEGGd1';
    return [
      primary,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBbsg5VxbvT11uRXXDRayoEzYGroBN6JL_q3OdBRxTV_NhUsAgXOLVnLt2AP4FjQ1VeLJ9Nu66ZOkgTwSPghddjYzSFJFH-nX61SZBAAjCBTQkjHnkshnkB9KTRoZj4KrKjCVLIhIkvkcNqEk4h79BfvPd-dbBBLoCQ-CEHU411SdMlg7TerXu1-n2q_kyKG2QiY7Cx6HvI4O9yNH2j5DTrGLp3HLDv5C71JMkQhsDUBUD-USNQ7Z-F',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBxT-WRocvozm2WhECnL8JMwxCqiEnuJ7cKtNoLv-llUuIz1dEY2oBp5MdWHKwKfTDfhmhcZUDYamNJeXMOiQDXQErt0WRFRSJzAY4cxjLnMqG5f-EZz7kvpru8TOviGd0RTYku3CEMtUC_JLe6zQqHimHXCBkpnyde4yFl2cThVNJlqY4w66MTA4r1xi322PjWVu4NCiQxhPP4RjdOUhB39s8SgVQHbIIYzVhJX5H3YENCU6jqp-7U',
    ];
  }

  final List<String> _weightOptions = [
    '500g ~3-4 pieces',
    '1kg ~6-8 pieces',
  ];

  final List<Map<String, String>> _similarProducts = [
    {
      'id': 'sim_1',
      'name': 'Fresh Hybrid Tomatoes',
      'weight': '500g Pack',
      'price': '\$2.40',
      'mrp': '\$2.80',
      'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
    },
    {
      'id': 'sim_2',
      'name': 'New Crop Potatoes',
      'weight': '1kg Pack',
      'price': '\$3.20',
      'mrp': '\$3.50',
      'image': 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&q=80',
    },
    {
      'id': 'sim_3',
      'name': 'Fresh Red Onions',
      'weight': '1kg Pack',
      'price': '\$3.80',
      'mrp': '\$4.20',
      'image': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<RecentlyViewedProvider>().addRecentlyViewed({
          'id': widget.productId,
          'name': widget.productName,
          'brand': 'Fresh Farm Co.',
          'unit': _selectedWeight,
          'price': widget.price,
          'mrp': widget.mrp,
          'imageUrl': widget.imageUrl,
        });
      } catch (_) {}
    });
  }

  void _showAiChefModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ask AI Chef',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'Get instant recipes & nutrition hacks for ${widget.productName}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _aiSuggestionTile(
                icon: Icons.restaurant_menu_rounded,
                title: 'Classic Guacamole Recipe',
                subtitle: 'Mash 2 avocados with lime juice, cilantro, red onion, & sea salt.',
              ),
              const SizedBox(height: 12),
              _aiSuggestionTile(
                icon: Icons.health_and_safety_rounded,
                title: 'Ripening Hack',
                subtitle: 'Store in a brown paper bag with a banana for 24 hours to accelerate ripening.',
              ),
              const SizedBox(height: 12),
              _aiSuggestionTile(
                icon: Icons.fitness_center_rounded,
                title: 'Keto Nutritional Pairing',
                subtitle: 'Pair with poached eggs & whole grain sourdough for high-protein breakfast.',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Close Assistant', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _aiSuggestionTile({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    try {
      cartProvider = context.watch<CartProvider>();
    } catch (_) {}

    final currentQty = cartProvider?.getQuantity(widget.productId) ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          widget.productName,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          FavoriteButton(
            productId: widget.productId,
            productDetails: {
              'id': widget.productId,
              'name': widget.productName,
              'brand': 'Fresh Farm Co.',
              'unit': _selectedWeight,
              'price': widget.price,
              'mrp': widget.mrp,
              'imageUrl': widget.imageUrl,
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image Gallery Carousel with Stitch Overlays
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          _galleryImages[_selectedImageIndex],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.eco_rounded, color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Certified Organic',
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _galleryImages.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final isSel = idx == _selectedImageIndex;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedImageIndex = idx),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: isSel ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Product Brand & Name
                Text(
                  'Fresh Farm Co.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.productName,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                // 3. Rating Row
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const Icon(Icons.star_half_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '(128 Reviews)',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 4. Pricing & ETA Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.price,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.mrp,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.discountPercentage,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF93000A)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant),
                    children: [
                      const TextSpan(text: 'Delivery in '),
                      TextSpan(
                        text: widget.deliveryTime,
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 5. Select Weight Pack Size
                Text(
                  'Select Weight',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                Row(
                  children: _weightOptions.map((opt) {
                    final isSel = opt == _selectedWeight;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _selectedWeight = opt),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSel ? AppColors.primary : const Color(0xFFE2E8F0),
                                width: isSel ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  opt.split(' ')[0],
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSel ? AppColors.primary : AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  opt.contains('~') ? opt.substring(opt.indexOf('~')) : '',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 6. Ask AI Chef Card
                InkWell(
                  onTap: () => _showAiChefModal(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE5DD).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDCE5DD)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ask AI Chef',
                                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                              ),
                              Text(
                                'Get instant recipe ideas, pairing suggestions, or nutritional breakdowns for these avocados.',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 7. Specifications Section
                Text(
                  'Product Details',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our premium Hass avocados are organically grown, hand-picked, and delivered at the perfect stage of ripeness. Known for their creamy texture and rich, nutty flavor, they are perfect for salads, toast, or your favorite guacamole recipe.',
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _specRow('Brand', 'Fresh Farm Co. Organic'),
                      _specRow('Country of Origin', 'India 🇮🇳'),
                      _specRow('FSSAI Lic. No.', '11223344556677'),
                      _specRow('Storage Instructions', 'Store at room temp until ripe'),
                      _specRow('Return Policy', '100% Doorstep Return eligible'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 8. Nutrition Facts Table
                Text(
                  'Nutritional Info (per 100g)',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _nutritionPill('160 kcal', 'ENERGY'),
                      _nutritionPill('2.0 g', 'PROTEIN'),
                      _nutritionPill('14.7 g', 'FAT'),
                      _nutritionPill('8.5 g', 'CARBS'),
                      _nutritionPill('6.7 g', 'FIBER'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 9. Reviews Card
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReviewsRecommendationsScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '4.8 Star Rating (128 Verified Reviews)',
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                            ),
                            Text(
                              'Tap to view customer photo gallery & buyer feedback',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 10. Similar Products
                Text(
                  'Similar Fresh Recommendations',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _similarProducts.length,
                    itemBuilder: (ctx, idx) {
                      final item = _similarProducts[idx];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item['image']!,
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['name']!,
                              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item['price']!,
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
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

          // Sticky Bottom Add to Cart Bar
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.price,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        _selectedWeight,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (currentQty == 0)
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          cartProvider?.updateQuantityById(
                            id: widget.productId,
                            name: widget.productName,
                            subtitle: _selectedWeight,
                            price: 5.99,
                            image: widget.imageUrl,
                            delta: 1,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Add to Cart - ${widget.price}',
                          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_rounded, color: Colors.white),
                            onPressed: () {
                              cartProvider?.updateQuantityById(
                                id: widget.productId,
                                name: widget.productName,
                                subtitle: _selectedWeight,
                                price: 5.99,
                                image: widget.imageUrl,
                                delta: -1,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '$currentQty',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_rounded, color: Colors.white),
                            onPressed: () {
                              cartProvider?.updateQuantityById(
                                id: widget.productId,
                                name: widget.productName,
                                subtitle: _selectedWeight,
                                price: 5.99,
                                image: widget.imageUrl,
                                delta: 1,
                              );
                            },
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
  }

  Widget _specRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutritionPill(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}
