import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/data/products_catalog_data.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import 'reviews_recommendations_screen.dart';

/// Product Details Screen — Google Stitch Source of Truth Specification
/// Project: Daily Basket Quick-Commerce Suite
class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String categoryTag;
  final String productName;
  final String? brand;
  final String price;
  final String mrp;
  final String discountPercentage;
  final String unitDetails;
  final String deliveryTime;
  final String imageUrl;
  final String? description;

  const ProductDetailsScreen({
    super.key,
    this.productId = 'prod_avocado',
    this.categoryTag = 'ORGANIC PRODUCE',
    this.productName = 'Organic Hass Avocados',
    this.brand,
    this.price = '₹180',
    this.mrp = '₹225',
    this.discountPercentage = '-20%',
    this.unitDetails = '500g ~3-4 pieces',
    this.deliveryTime = '15-30 mins',
    this.imageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAUZTLTSv5m1XvtD0eVooGUshRAE_TEf1VJ6rDo2p2NK8V-OtAgWRr9FnG7_wymxfNYoJbO-z3fuiHP_nel0NrAMmwbjTaJpS2Qn6gtKhCoGN6ltUY0Ye1kqsw-Lgi3oSwN5RBZcGCyK2PH3mZqTsqvfYztVjk3FZnajEMLUCbI6q8oB1hqEySrz4h9bFTXR1c7DcEprHGwUvQVM7TEPLq83eHICr5VanKASkHt7mYjWh7jE8sEGGd1',
    this.description,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  late String _selectedWeight;
  bool _notifyMeRegistered = false;
  bool _comboAdded = false;
  String? _substituteAddedId;

  bool get _isProductInStock {
    final catProd = _catalogProduct;
    if (catProd != null && catProd.containsKey('inStock')) {
      return catProd['inStock'] == true;
    }
    return true;
  }

  List<Map<String, dynamic>> get _comboCompanions {
    final all = kAllCatalogProducts['all'] ?? [];
    final currentCat = (_catalogProduct?['category'] ?? _catalogProduct?['sub'] ?? widget.categoryTag).toString().toLowerCase();

    final matches = all.where((p) {
      if (p['id'] == widget.productId) return false;
      final cat = (p['category'] ?? p['sub'] ?? '').toString().toLowerCase();
      if (currentCat.contains('milk')) {
        return cat.contains('bread') || cat.contains('cereal');
      }
      if (currentCat.contains('bread')) {
        return cat.contains('milk') || cat.contains('butter');
      }
      return cat != currentCat;
    }).take(2).toList();

    return matches.isNotEmpty ? matches : all.where((p) => p['id'] != widget.productId).take(2).toList();
  }

  List<Map<String, dynamic>> get _smartSubstitutes {
    final all = kAllCatalogProducts['all'] ?? [];
    final currentCat = (_catalogProduct?['category'] ?? _catalogProduct?['sub'] ?? widget.categoryTag).toString().toLowerCase();

    final matches = all.where((p) {
      if (p['id'] == widget.productId) return false;
      final cat = (p['category'] ?? p['sub'] ?? '').toString().toLowerCase();
      return cat == currentCat || p['image'].toString().contains('fresh-vegetables');
    }).take(3).toList();

    return matches.isNotEmpty ? matches : all.where((p) => p['id'] != widget.productId).take(3).toList();
  }

  Map<String, dynamic>? get _catalogProduct {
    final all = kAllCatalogProducts['all'] ?? [];
    for (final p in all) {
      if (p['id'] == widget.productId || (p['name'] == widget.productName && p['image'] == widget.imageUrl)) {
        return p;
      }
    }
    return null;
  }

  String get _effectiveBrand =>
      widget.brand ?? (_catalogProduct?['brand'] as String?) ?? 'Daily Basket Select';

  String get _effectiveCategory =>
      (_catalogProduct?['category'] as String?) ??
      (_catalogProduct?['sub'] as String?) ??
      widget.categoryTag;

  String get _effectiveUnit {
    if (widget.unitDetails.isNotEmpty && widget.unitDetails != '500g ~3-4 pieces') {
      return widget.unitDetails;
    }
    final raw = (_catalogProduct?['unit'] ?? _catalogProduct?['subtitle'] ?? '1 Pack').toString();
    return raw;
  }

  String get _effectiveDescription {
    if (widget.description != null && widget.description!.isNotEmpty) {
      return widget.description!;
    }
    final sub = _catalogProduct?['sub'] ?? _effectiveCategory;
    return "${widget.productName} ($_effectiveUnit). Premium quality $sub sourced fresh and quality tested by $_effectiveBrand. Delivered in 10-15 minutes.";
  }

  List<String> get _galleryImages {
    final primary = widget.imageUrl.isNotEmpty
        ? widget.imageUrl
        : 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png';
    return [primary];
  }

  List<String> get _weightOptions {
    final unit = _effectiveUnit;
    if (unit.contains('Pack') || unit.contains('g') || unit.contains('ml') || unit.contains('L')) {
      return [unit, 'Value Saver (2x)'];
    }
    return [unit];
  }

  List<Map<String, String>> get _similarProducts {
    final all = kAllCatalogProducts['all'] ?? [];
    final currentCat = _catalogProduct?['category'] ?? _catalogProduct?['sub'];
    final currentFolder = widget.imageUrl.contains('products/')
        ? widget.imageUrl.split('products/').last.split('/').first
        : '';

    final matches = all.where((p) {
      if (p['id'] == widget.productId) return false;
      if (currentFolder.isNotEmpty && p['image'].toString().contains('products/$currentFolder/')) {
        return true;
      }
      if (currentCat != null && (p['category'] == currentCat || p['sub'] == currentCat)) {
        return true;
      }
      return false;
    }).take(4).toList();

    final sourceList = matches.isNotEmpty ? matches : all.take(4).toList();
    return sourceList.map((p) => {
      'id': p['id'].toString(),
      'name': p['name'].toString(),
      'weight': (p['unit'] ?? p['subtitle'] ?? '1 Pack').toString(),
      'price': '₹${(p['price'] as num).round()}',
      'mrp': '₹${((p['mrp'] as num?) ?? (p['price'] as num) * 1.25).round()}',
      'image': p['image'].toString(),
      'brand': (p['brand'] ?? 'Daily Basket').toString(),
      'category': (p['category'] ?? '').toString(),
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedWeight = _effectiveUnit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<RecentlyViewedProvider>().addRecentlyViewed({
          'id': widget.productId,
          'name': widget.productName,
          'brand': _effectiveBrand,
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
    final cleanPriceStr = widget.price.replaceAll(RegExp(r'[^0-9.]'), '');
    final unitPrice = double.tryParse(cleanPriceStr) ?? 24.0;

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
                        child: _galleryImages[_selectedImageIndex].startsWith('assets/')
                            ? Image.asset(
                                _galleryImages[_selectedImageIndex],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                _galleryImages[_selectedImageIndex],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => const Center(
                                  child: Icon(Icons.shopping_basket_rounded, size: 64, color: AppColors.primary),
                                ),
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
                  _effectiveBrand,
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
                        child: AppPressable(
                          onTap: () => setState(() => _selectedWeight = opt),
                          scaleFactor: 0.96,
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
                                'Get instant recipe ideas, pairing suggestions, or preparation tips for ${widget.productName}.',
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

                // Out of stock & Smart Substitutes (Feature 4)
                if (!_isProductInStock) ...[
                  _buildSmartSubstitutes(cartProvider),
                  const SizedBox(height: 24),
                ],

                // Frequently Bought Together & Smart Bundles (Feature 2)
                if (_comboCompanions.isNotEmpty) ...[
                  _buildFrequentlyBoughtTogether(cartProvider, unitPrice),
                  const SizedBox(height: 24),
                ],

                // 7. Specifications Section
                Text(
                  'Product Details',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  _effectiveDescription,
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
                      _specRow('Brand', _effectiveBrand),
                      _specRow('Pack Unit', _effectiveUnit),
                      _specRow('Category', _effectiveCategory),
                      _specRow('Country of Origin', 'India 🇮🇳'),
                      _specRow('Storage Instructions', 'Store in a cool & dry place'),
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
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                productId: item['id']!,
                                productName: item['name']!,
                                price: item['price']!,
                                mrp: item['mrp']!,
                                unitDetails: item['weight']!,
                                imageUrl: item['image']!,
                                brand: item['brand'],
                                categoryTag: item['category'] ?? '',
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
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
                                child: AppNetworkImage(
                                  imageUrl: item['image']!,
                                  height: 90,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
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
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFBECAB9).withValues(alpha: 0.30),
                        width: 0.5,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
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
                      if (!_isProductInStock)
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.amber.shade300),
                                  ),
                                  child: Text(
                                    'Sold Out in Store',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade900),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => _notifyMeRegistered = !_notifyMeRegistered);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _notifyMeRegistered ? '✓ Alert registered! We will notify you when restocked.' : 'Alert cancelled.',
                                        style: GoogleFonts.inter(color: Colors.white),
                                      ),
                                      backgroundColor: AppColors.primary,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: Icon(_notifyMeRegistered ? Icons.notifications_active_rounded : Icons.notifications_none_rounded, size: 18),
                                label: Text(_notifyMeRegistered ? 'Alert Set' : 'Notify Me'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        const Spacer(),
                        if (currentQty == 0)
                          AppPressable(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  cartProvider?.updateQuantityById(
                                    id: widget.productId,
                                    name: widget.productName,
                                    subtitle: _selectedWeight,
                                    price: unitPrice,
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
                                AppPressable(
                                  onTap: () {
                                    cartProvider?.updateQuantityById(
                                      id: widget.productId,
                                      name: widget.productName,
                                      subtitle: _selectedWeight,
                                      price: unitPrice,
                                      image: widget.imageUrl,
                                      delta: -1,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    child: Icon(Icons.remove_rounded, color: Colors.white, size: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                    child: Text(
                                      '$currentQty',
                                      key: ValueKey<int>(currentQty),
                                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                                AppPressable(
                                  onTap: () {
                                    cartProvider?.updateQuantityById(
                                      id: widget.productId,
                                      name: widget.productName,
                                      subtitle: _selectedWeight,
                                      price: unitPrice,
                                      image: widget.imageUrl,
                                      delta: 1,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    child: Icon(Icons.add_rounded, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Feature 4: Smart Out-of-Stock Substitutes ─────────────────────────────
  Widget _buildSmartSubstitutes(CartProvider? cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.amber.shade200, shape: BoxShape.circle),
                child: Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currently Sold Out',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                    ),
                    Text(
                      'Restock in progress. Try these direct 10-min delivery alternatives:',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.amber.shade800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._smartSubstitutes.map((sub) {
            final subId = sub['id'].toString();
            final subName = sub['name'].toString();
            final subPrice = (sub['price'] as num?)?.toDouble() ?? 30.0;
            final subImg = sub['image'].toString();
            final subUnit = (sub['unit'] ?? sub['subtitle'] ?? '1 Pack').toString();
            final isAdded = _substituteAddedId == subId;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppNetworkImage(
                      imageUrl: subImg,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(4)),
                              child: Text('95% Match', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(subName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(subUnit, style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${subPrice.round()}', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {
                            cartProvider?.updateQuantityById(
                              id: subId,
                              name: subName,
                              subtitle: subUnit,
                              price: subPrice,
                              image: subImg,
                              delta: 1,
                            );
                            setState(() => _substituteAddedId = subId);
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) setState(() => _substituteAddedId = null);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(isAdded ? '✓ Added' : '+ Add', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Feature 2: Frequently Bought Together ─────────────────────────────────
  Widget _buildFrequentlyBoughtTogether(CartProvider? cartProvider, double unitPrice) {
    final companions = _comboCompanions;
    if (companions.isEmpty) return const SizedBox.shrink();

    double comboOriginalTotal = unitPrice;
    for (final c in companions) {
      comboOriginalTotal += (c['price'] as num?)?.toDouble() ?? 30.0;
    }
    const discountPercent = 12;
    final comboDiscounted = (comboOriginalTotal * (1 - discountPercent / 100)).roundToDouble();
    final savings = comboOriginalTotal - comboDiscounted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.layers_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequently Bought Together',
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    Text(
                      'Morning essentials bundle with 12% combo discount',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: Text('SAVE 12%', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Product thumbnails row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBundleThumb(widget.imageUrl, widget.productName, widget.price),
                ...companions.map((c) => Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                    _buildBundleThumb(
                      c['image'].toString(),
                      c['name'].toString(),
                      '₹${(c['price'] as num).round()}',
                    ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('₹${comboDiscounted.round()}', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                      const SizedBox(width: 6),
                      Text('₹${comboOriginalTotal.round()}', style: GoogleFonts.inter(fontSize: 12, decoration: TextDecoration.lineThrough, color: AppColors.outline)),
                    ],
                  ),
                  Text('Save ₹${savings.round()} instantly', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add main product
                  cartProvider?.updateQuantityById(
                    id: widget.productId,
                    name: widget.productName,
                    subtitle: _selectedWeight,
                    price: unitPrice,
                    image: widget.imageUrl,
                    delta: 1,
                  );
                  // Add companions
                  for (final c in companions) {
                    cartProvider?.updateQuantityById(
                      id: c['id'].toString(),
                      name: c['name'].toString(),
                      subtitle: (c['unit'] ?? c['subtitle'] ?? '1 Pack').toString(),
                      price: (c['price'] as num?)?.toDouble() ?? 30.0,
                      image: c['image'].toString(),
                      delta: 1,
                    );
                  }
                  setState(() => _comboAdded = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => _comboAdded = false);
                  });
                },
                icon: Icon(_comboAdded ? Icons.check_rounded : Icons.shopping_basket_rounded, size: 16),
                label: Text(_comboAdded ? 'Combo Added!' : 'Add Combo (${companions.length + 1})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBundleThumb(String img, String name, String price) {
    return Container(
      width: 76,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AppNetworkImage(imageUrl: img, width: 44, height: 44, fit: BoxFit.contain),
          ),
          const SizedBox(height: 4),
          Text(name, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(price, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
