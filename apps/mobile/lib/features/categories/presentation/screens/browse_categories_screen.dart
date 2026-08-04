import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Browse Categories Screen — Exact Google Stitch Specification
/// Matches:
/// - Top App Bar: "Browse Categories"
/// - Farm Fresh Guarantee promo banner strip
/// - Grid of visual category cards (Fruits & Veggies, Dairy & Eggs, Cold Drinks, etc.)
class BrowseCategoriesScreen extends StatelessWidget {
  const BrowseCategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'id': 'cat-1',
      'name': 'Fruits & Vegetables',
      'itemCount': '120+ items',
      'bgColor': Color(0xFFE8F5E9),
      'image':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80',
    },
    {
      'id': 'cat-2',
      'name': 'Dairy, Bread & Eggs',
      'itemCount': '85+ items',
      'bgColor': Color(0xFFFFF8E1),
      'image':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
    },
    {
      'id': 'cat-3',
      'name': 'Cold Drinks & Juices',
      'itemCount': '60+ items',
      'bgColor': Color(0xFFE0F7FA),
      'image':
          'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400&q=80',
    },
    {
      'id': 'cat-4',
      'name': 'Snacks & Munchies',
      'itemCount': '140+ items',
      'bgColor': Color(0xFFFFF3E0),
      'image':
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&q=80',
    },
    {
      'id': 'cat-5',
      'name': 'Bakery & Biscuits',
      'itemCount': '70+ items',
      'bgColor': Color(0xFFFFFDE7),
      'image':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    },
    {
      'id': 'cat-6',
      'name': 'Meat, Fish & Poultry',
      'itemCount': '45+ items',
      'bgColor': Color(0xFFFFEBEE),
      'image':
          'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Browse Categories',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF047857)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'FRESH DAILY',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Farm Fresh Guarantee',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Directly sourced from trusted local organic farms every morning.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.90),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'All Categories',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              // Categories Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cat['bgColor'],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.70),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                cat['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cat['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cat['itemCount'],
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
