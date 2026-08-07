import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../catalog/presentation/screens/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categorySlug;

  const CategoryProductsScreen({
    super.key,
    required this.categorySlug,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final provider = context.watch<CategoriesProvider>();
    final cartProvider = context.watch<CartProvider>();
    final category = provider.findBySlugOrId(widget.categorySlug);
    final products = provider.getProductsForCategory(widget.categorySlug);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsible HD Category Banner Header
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            backgroundColor: const Color(0xFF1E293B),
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2DD4BF)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF2DD4BF)),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                category.name,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    const Shadow(color: Colors.black87, blurRadius: 8),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(
                    imageUrl: category.bannerImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          const Color(0xFF0F172A).withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                          ),
                          child: Icon(_getCategoryIcon(category.iconName), color: const Color(0xFF2DD4BF), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.description,
                                style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEC4899),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'UP TO 40% OFF',
                                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2DD4BF),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '⚡ 10-MIN EXPRESS',
                                      style: GoogleFonts.outfit(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search inside Category
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => provider.setSearchQuery(val),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search in ${category.name}...',
                  hintStyle: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2DD4BF)),
                  suffixIcon: provider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: Color(0xFF64748B)),
                          onPressed: () {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF2DD4BF), width: 1.5),
                  ),
                ),
              ),
            ),
          ),

          // Subcategory Chips Bar
          if (category.subcategories.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: category.subcategories.length,
                  itemBuilder: (context, idx) {
                    final sub = category.subcategories[idx];
                    final isSelected = provider.selectedSubcategory == sub;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(sub),
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? Colors.black : const Color(0xFFCBD5E1),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                        selectedColor: const Color(0xFF2DD4BF),
                        backgroundColor: const Color(0xFF1E293B),
                        checkmarkColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF2DD4BF) : const Color(0xFF334155),
                        ),
                        onSelected: (_) => provider.selectSubcategory(sub),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Header Controls (Count & Sort)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${products.length} Products Available',
                    style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  PopupMenuButton<String>(
                    initialValue: provider.sortOption,
                    onSelected: (val) => provider.setSortOption(val),
                    color: const Color(0xFF1E293B),
                    icon: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort_rounded, color: Color(0xFF2DD4BF), size: 18),
                        SizedBox(width: 4),
                        Text('Sort', style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'popular', child: Text('Popularity', style: TextStyle(color: Colors.white))),
                      const PopupMenuItem(value: 'price_low_high', child: Text('Price: Low to High', style: TextStyle(color: Colors.white))),
                      const PopupMenuItem(value: 'price_high_low', child: Text('Price: High to Low', style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          products.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, color: Color(0xFF64748B), size: 64),
                        const SizedBox(height: 12),
                        Text(
                          'No products found in this category',
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try clearing filters or search query',
                          style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: AnimationLimiter(
                    child: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = products[index];
                          final id = p['id'] as String;
                          final name = p['name'] as String;
                          final subtitle = (p['subtitle'] ?? p['sub'] ?? '500g Pack') as String;
                          final priceNum = (p['price'] as num).toDouble();
                          final mrpNum = (p['mrp'] as num?)?.toDouble() ?? (priceNum * 1.25);
                          final image = p['image'] as String;
                          final currentQty = cartProvider.getQuantity(id);

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
                                        builder: (_) => ProductDetailsScreen(
                                          productId: id,
                                          productName: name,
                                          price: '₹${priceNum.toStringAsFixed(0)}',
                                          mrp: '₹${mrpNum.toStringAsFixed(0)}',
                                          unitDetails: subtitle,
                                          imageUrl: image,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFF334155)),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x20000000),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product Image & Favorite Button
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                              child: AppNetworkImage(
                                                imageUrl: image,
                                                height: 120,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: FavoriteButton(productId: id, size: 18),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  subtitle,
                                                  style: GoogleFonts.inter(
                                                    color: const Color(0xFF94A3B8),
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          '₹${priceNum.toStringAsFixed(0)}',
                                                          style: GoogleFonts.outfit(
                                                            color: const Color(0xFF2DD4BF),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          '₹${mrpNum.toStringAsFixed(0)}',
                                                          style: GoogleFonts.inter(
                                                            color: const Color(0xFF64748B),
                                                            fontSize: 11,
                                                            decoration: TextDecoration.lineThrough,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    currentQty > 0
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF2DD4BF),
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    cartProvider.updateQuantityById(
                                                                      id: id,
                                                                      name: name,
                                                                      subtitle: subtitle,
                                                                      price: priceNum,
                                                                      image: image,
                                                                      delta: -1,
                                                                    );
                                                                  },
                                                                  child: const Icon(Icons.remove, size: 16, color: Colors.black),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                  child: Text(
                                                                    '$currentQty',
                                                                    style: GoogleFonts.outfit(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    cartProvider.updateQuantityById(
                                                                      id: id,
                                                                      name: name,
                                                                      subtitle: subtitle,
                                                                      price: priceNum,
                                                                      image: image,
                                                                      delta: 1,
                                                                    );
                                                                  },
                                                                  child: const Icon(Icons.add, size: 16, color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : ElevatedButton(
                                                            onPressed: () {
                                                              cartProvider.addItem(
                                                                CartItem(
                                                                  id: id,
                                                                  name: name,
                                                                  subtitle: subtitle,
                                                                  price: priceNum,
                                                                  qty: 1,
                                                                  image: image,
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text('$name added to basket'),
                                                                  duration: const Duration(seconds: 2),
                                                                  behavior: SnackBarBehavior.floating,
                                                                ),
                                                              );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color(0xFF2DD4BF),
                                                              foregroundColor: Colors.black,
                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                              minimumSize: Size.zero,
                                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                            ),
                                                            child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                          ),
                                                  ],
                                                ),
                                              ],
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
                        childCount: products.length,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
