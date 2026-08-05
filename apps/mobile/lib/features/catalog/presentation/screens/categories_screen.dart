import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_listing_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'id': 'cat-1', 'name': 'Fruits & Vegetables', 'icon': Icons.eco_rounded, 'items': '120+ Items', 'color': const Color(0xFFE8F5E9)},
      {'id': 'cat-2', 'name': 'Dairy, Bread & Eggs', 'icon': Icons.egg_alt_rounded, 'items': '85+ Items', 'color': const Color(0xFFFFF8E1)},
      {'id': 'cat-3', 'name': 'Cold Drinks & Juices', 'icon': Icons.local_drink_rounded, 'items': '60+ Items', 'color': const Color(0xFFE0F7FA)},
      {'id': 'cat-4', 'name': 'Snacks & Munchies', 'icon': Icons.cookie_rounded, 'items': '140+ Items', 'color': const Color(0xFFFFF3E0)},
      {'id': 'cat-5', 'name': 'Bakery & Biscuits', 'icon': Icons.bakery_dining_rounded, 'items': '70+ Items', 'color': const Color(0xFFFFFDE7)},
      {'id': 'cat-6', 'name': 'Meat, Fish & Poultry', 'icon': Icons.kebab_dining_rounded, 'items': '45+ Items', 'color': const Color(0xFFFFEBEE)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'All Categories',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cat['color'] as Color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'] as IconData, size: 40, color: const Color(0xFF006B23)),
                  const SizedBox(height: 10),
                  Text(
                    cat['name'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF1A1C1E),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['items'] as String,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6E7A6C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
