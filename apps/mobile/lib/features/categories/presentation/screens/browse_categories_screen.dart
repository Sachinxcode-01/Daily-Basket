import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import 'category_products_screen.dart';

/// Browse Categories Screen — Exact Google Stitch Specification
/// 18 Primary Indian Quick-Commerce Categories
class BrowseCategoriesScreen extends StatelessWidget {
  const BrowseCategoriesScreen({super.key});

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'eco': return Icons.eco_rounded;
      case 'egg_alt': return Icons.egg_alt_rounded;
      case 'fastfood': return Icons.fastfood_rounded;
      case 'shopping_bag': return Icons.shopping_bag_rounded;
      case 'opacity': return Icons.opacity_rounded;
      case 'temple_hindu': return Icons.temple_hindu_rounded;
      case 'cleaning_services': return Icons.cleaning_services_rounded;
      case 'home_work': return Icons.home_work_rounded;
      case 'face': return Icons.face_rounded;
      case 'child_care': return Icons.child_care_rounded;
      case 'pets': return Icons.pets_rounded;
      case 'local_drink': return Icons.local_drink_rounded;
      case 'coffee': return Icons.coffee_rounded;
      case 'bakery_dining': return Icons.bakery_dining_rounded;
      case 'icecream': return Icons.icecream_rounded;
      case 'spa': return Icons.spa_rounded;
      case 'ac_unit': return Icons.ac_unit_rounded;
      case 'restaurant': return Icons.restaurant_rounded;
      default: return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final categories = categoriesProvider.categories;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF2DD4BF),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'All Categories (${categories.length})',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Banner Strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Color(0x4014B8A6), blurRadius: 12, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Basket Quick-Commerce Taxonomy',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '10-Minute Express Delivery across 18 specialized departments',
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Categories Grid
              AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final icon = _getCategoryIcon(cat.iconName);

                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryProductsScreen(categorySlug: cat.slug),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: cat.isFeatured
                                      ? const Color(0xFF2DD4BF).withValues(alpha: 0.6)
                                      : const Color(0xFF334155),
                                  width: cat.isFeatured ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Banner Image with Badge
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                        child: AppNetworkImage(
                                          imageUrl: cat.imageUrl,
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFF2DD4BF)),
                                          ),
                                          child: Icon(icon, color: const Color(0xFF2DD4BF), size: 16),
                                        ),
                                      ),
                                      if (cat.isFeatured)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEC4899),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'POPULAR',
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat.name,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${cat.subcategories.length} subcategories',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: const Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
