import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_network_image.dart';
import 'category_products_screen.dart';
import 'fresh_produce_listing_screen.dart';

/// Browse Categories Screen — Google Stitch Exact Design
/// Stitch Screen ID: d4a9073676484431a88cd27d2cc1e87a
/// Project: Daily Basket Quick-Commerce Suite
class BrowseCategoriesScreen extends StatefulWidget {
  final bool isEmbedded;
  const BrowseCategoriesScreen({super.key, this.isEmbedded = false});

  @override
  State<BrowseCategoriesScreen> createState() => _BrowseCategoriesScreenState();
}

class _BrowseCategoriesScreenState extends State<BrowseCategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _featuredCategories = [
    {
      'title': 'All Products',
      'subtitle': 'Full catalog of 607 grocery essentials',
      'slug': 'all',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=700&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Fresh Vegetables',
      'subtitle': '154 farm fresh veggies & greens',
      'slug': 'fresh-vegetables',
      'imageUrl':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=700&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Bread, Pav & Bakery',
      'subtitle': '248 fresh baked items & morning pav',
      'slug': 'bread-pav',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=700&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Fresh Dairy & Milk',
      'subtitle': '41 pure farm milk & dairy essentials',
      'slug': 'milk',
      'imageUrl':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=700&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Curd & Yogurt',
      'subtitle': '78 fresh probiotic dahi & yogurts',
      'slug': 'curd-yogurt',
      'imageUrl':
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=700&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Flakes & Cereals',
      'subtitle': '53 healthy morning breakfast bowls',
      'slug': 'flakes-kids-cereals',
      'imageUrl':
          'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=700&auto=format&fit=crop&q=80',
    },
  ];

  final List<Map<String, dynamic>> _allCategories = [
    {
      'title': 'All Products',
      'itemCount': '607 items',
      'slug': 'all',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Bread, Pav & Bakery',
      'itemCount': '248 items',
      'slug': 'bread-pav',
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Fresh Vegetables',
      'itemCount': '154 items',
      'slug': 'fresh-vegetables',
      'imageUrl':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Curd & Yogurt',
      'itemCount': '78 items',
      'slug': 'curd-yogurt',
      'imageUrl':
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Flakes & Cereals',
      'itemCount': '53 items',
      'slug': 'flakes-kids-cereals',
      'imageUrl':
          'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Fresh Milk',
      'itemCount': '41 items',
      'slug': 'milk',
      'imageUrl':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Poha, Daliya & Grains',
      'itemCount': '17 items',
      'slug': 'poha-daliya-grains',
      'imageUrl':
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80',
    },
    {
      'title': 'Vermicelli & Sevai',
      'itemCount': '16 items',
      'slug': 'vermicelli',
      'imageUrl':
          'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCategory(String slug, String title) {
    if (slug == 'fruits-vegetables' || slug == 'fresh-fruits-vegetables') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FreshProduceListingScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(categorySlug: slug),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on, color: AppColors.primary),
                    onPressed: () => Navigator.pushNamed(context, '/select-location'),
                  ),
                  Text(
                    widget.isEmbedded ? 'Categories' : 'Daily Basket',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: AppColors.primary),
                    onPressed: () => Navigator.pushNamed(context, '/search'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Search Bar ──────────────────────────────────────────────
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/search'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.outline, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Search groceries...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ─── Featured Categories (Horizontal Scroll) ─────────────────
                Text(
                  'Featured Categories',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _featuredCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final item = _featuredCategories[index];
                      return InkWell(
                        onTap: () => _navigateToCategory(item['slug']!, item['title']!),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 260,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AppNetworkImage(
                                  imageUrl: item['imageUrl']!,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(16),
                                  fallbackBgColor: AppColors.surfaceContainerHigh,
                                  fallbackIcon: Icons.storefront_rounded,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.75),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 14,
                                left: 14,
                                right: 14,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['subtitle']!,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // ─── All Categories Grid ──────────────────────────────────────
                Text(
                  'All Categories',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 14),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: _allCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _allCategories[index];
                    return InkWell(
                      onTap: () => _navigateToCategory(cat['slug']!, cat['title']!),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: AppNetworkImage(
                                  imageUrl: cat['imageUrl']!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(8),
                                  fallbackBgColor: AppColors.surfaceContainerHigh,
                                  fallbackIcon: Icons.shopping_basket_rounded,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cat['title']!,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cat['itemCount']!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
