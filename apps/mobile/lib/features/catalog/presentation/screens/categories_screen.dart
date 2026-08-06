import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'product_listing_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'id': 'cat-1', 'name': 'Fruits & Vegetables', 'icon': Icons.eco_rounded, 'items': '120+ Items', 'gradient': const [Color(0xFF0F766E), Color(0xFF14B8A6)]},
      {'id': 'cat-2', 'name': 'Dairy, Bread & Eggs', 'icon': Icons.egg_alt_rounded, 'items': '85+ Items', 'gradient': const [Color(0xFF0284C7), Color(0xFF38BDF8)]},
      {'id': 'cat-3', 'name': 'Cold Drinks & Juices', 'icon': Icons.local_drink_rounded, 'items': '60+ Items', 'gradient': const [Color(0xFF7C3AED), Color(0xFFA78BFA)]},
      {'id': 'cat-4', 'name': 'Snacks & Munchies', 'icon': Icons.cookie_rounded, 'items': '140+ Items', 'gradient': const [Color(0xFFD97706), Color(0xFFFBBF24)]},
      {'id': 'cat-5', 'name': 'Bakery & Biscuits', 'icon': Icons.bakery_dining_rounded, 'items': '70+ Items', 'gradient': const [Color(0xFFE11D48), Color(0xFFFB7185)]},
      {'id': 'cat-6', 'name': 'Meat, Fish & Poultry', 'icon': Icons.kebab_dining_rounded, 'items': '45+ Items', 'gradient': const [Color(0xFF9333EA), Color(0xFFC084FC)]},
      {'id': 'cat-7', 'name': 'Atta, Rice & Dal', 'icon': Icons.grain_rounded, 'items': '110+ Items', 'gradient': const [Color(0xFF059669), Color(0xFF34D399)]},
      {'id': 'cat-8', 'name': 'Oil, Ghee & Masala', 'icon': Icons.opacity_rounded, 'items': '95+ Items', 'gradient': const [Color(0xFFEA580C), Color(0xFFFB923C)]},
      {'id': 'cat-9', 'name': 'Cleaning & Household', 'icon': Icons.cleaning_services_rounded, 'items': '130+ Items', 'gradient': const [Color(0xFF2563EB), Color(0xFF60A5FA)]},
      {'id': 'cat-10', 'name': 'Personal Care & Beauty', 'icon': Icons.face_rounded, 'items': '150+ Items', 'gradient': const [Color(0xFFDB2777), Color(0xFFF472B6)]},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2DD4BF)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'All Categories',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimationLimiter(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final gradient = cat['gradient'] as List<Color>;

              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListingScreen(
                              categoryId: cat['id'] as String,
                              categoryName: cat['name'] as String,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF334155),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x20000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    gradient[0].withValues(alpha: 0.25),
                                    gradient[1].withValues(alpha: 0.15),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: gradient[1].withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                cat['icon'] as IconData,
                                size: 28,
                                color: gradient[1],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cat['name'] as String,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF334155),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                cat['items'] as String,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF2DD4BF),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
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
      ),
    );
  }
}
