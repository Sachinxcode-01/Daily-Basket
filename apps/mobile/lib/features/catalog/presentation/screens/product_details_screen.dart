import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import 'reviews_recommendations_screen.dart';

/// Product Details Screen — Google Stitch Source of Truth Specification (ID: fed4975734304fada8e33c3c4c02a910)
/// Features Multi-Image Gallery, FSSAI compliance, Nutrition Specs, Smart Stock Indicator, and Ask AI Chef.
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
    this.unitDetails = '500g ~3-4 pieces',
    this.deliveryTime = '15-30 mins',
    this.imageUrl = 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80',
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
        : 'http://localhost:4000/assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png';
    return [
      primary,
      'http://localhost:4000/assets/products/fresh-vegetables/00f0d26a-7b61-4e84-8903-abed0e2c4f69.png',
      'http://localhost:4000/assets/products/fresh-vegetables/02df8262-1ccc-4078-a215-991a85ded7b0.png',
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
      'price': '₹24',
      'mrp': '₹28',
      'image': 'http://localhost:4000/assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    },
    {
      'id': 'sim_2',
      'name': 'New Crop Potatoes',
      'weight': '1kg Pack',
      'price': '₹32',
      'mrp': '₹35',
      'image': 'http://localhost:4000/assets/products/fresh-vegetables/00f0d26a-7b61-4e84-8903-abed0e2c4f69.png',
    },
    {
      'id': 'sim_3',
      'name': 'Fresh Nashik Red Onions',
      'weight': '1kg Pack',
      'price': '₹38',
      'mrp': '₹42',
      'image': 'http://localhost:4000/assets/products/fresh-vegetables/02df8262-1ccc-4078-a215-991a85ded7b0.png',
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
                          'Instant recipes & nutrition hacks for ${widget.productName}',
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
                // 1. HD Zoomable Gallery Carousel
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ORGANIC',
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'BEST SELLER',
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFD97706)),
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

                // 2. Product Name, Brand & ETA Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_rounded, color: AppColors.primary, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fresh Farm Co. • Certified Organic',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            widget.deliveryTime,
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  widget.productName,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                // 3. Pricing & Discount Row
                Row(
                  children: [
                    Text(
                      widget.price,
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.mrp,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.discountPercentage,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Smart Stock Warning Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Smart Stock: Only 4 items left in Indiranagar Darkstore!',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFB45309)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 4. Weight Option Selector
                Text(
                  'Select Pack Size',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _weightOptions.map((opt) {
                    final isSel = opt == _selectedWeight;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(opt),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setState(() => _selectedWeight = opt);
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : AppColors.onSurface,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: isSel ? AppColors.primary : const Color(0xFFCBD5E1)),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 5. Ask AI Chef CTA Card
                InkWell(
                  onTap: () => _showAiChefModal(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.12),
                          AppColors.primary.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
                                'Ask AI Chef Assistant',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              Text(
                                'Get instant guacamole recipes, ripening tips, & nutrition pairing.',
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

                // 6. Comprehensive Product Specifications & Compliance
                Text(
                  'Product Specifications & Compliance',
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
                  child: Column(
                    children: [
                      _specRow('Brand', 'Fresh Farm Co. Organic'),
                      _specRow('Country of Origin', 'India 🇮🇳'),
                      _specRow('FSSAI Lic. No.', '11223344556677'),
                      _specRow('Ingredients', '100% Raw Certified Organic Hass Avocados'),
                      _specRow('Storage Instructions', 'Store at room temp until ripe, then refrigerate'),
                      _specRow('Shelf Life', 'Best consumed within 5 days of delivery'),
                      _specRow('Return Policy', '100% Doorstep Return eligible within 24 hours'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 7. Nutrition Facts Table
                Text(
                  'Nutrition Facts (Per 100g)',
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

                // 8. Reviews & Recommendations Teaser Card
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
                              '4.8 Star Rating (1,248 Verified Reviews)',
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

                // 9. Similar Products Carousel
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

          // 10. Sticky Bottom Add-to-Cart Action Bar
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
                            price: 120.0,
                            image: widget.imageUrl,
                            delta: 1,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'ADD TO BASKET',
                          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
                                price: 120.0,
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
                                price: 120.0,
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
