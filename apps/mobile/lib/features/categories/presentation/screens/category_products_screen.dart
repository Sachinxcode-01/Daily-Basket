import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../catalog/presentation/screens/product_details_screen.dart';

/// CategoryProductsScreen — Google Stitch Design System (ID: 2836cddb63dc41079f82c31b1dafaa01)
/// "Snacks & Packaged Foods - Product Listing"
///
/// Features:
/// - Light background (#F9F9FC) with Stitch design tokens
/// - Collapsible Parallax Hero Banner with HD snacks background, dark overlay, discount badges & delivery SLA
/// - Glassmorphism floating back button & action buttons over hero
/// - Sticky Search Bar with Voice (mic) & Visual AI (lens) search integration
/// - Horizontal scrollable filter chips bar (All, Best Sellers, Popular | Subcategories)
/// - Product Grid with Stitch card styling (SurfaceContainerLowest cards, shadow level 1, brand labels, ratings)
/// - Interactive ADD / Stepper button with CartProvider integration
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
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();
    final cartProvider = context.watch<CartProvider>();
    final category = provider.findBySlugOrId(widget.categorySlug);
    final products = provider.getProductsForCategory(widget.categorySlug);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Collapsible Hero Banner App Bar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 320.0,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.30),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.30),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing ${category.name}...', style: GoogleFonts.inter(fontSize: 13, color: Colors.white)),
                          backgroundColor: AppColors.primary,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.surfaceContainerLowest.withValues(alpha: 0.30),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                      ),
                      if (cartProvider.totalCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartProvider.totalCount}',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                category.name,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: const [
                    Shadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 2)),
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
                  // Dark Gradient Overlay matching Stitch (inverse-surface/90 to transparent)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          AppColors.inverseSurface.withValues(alpha: 0.40),
                          AppColors.inverseSurface.withValues(alpha: 0.92),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Hero Content & Badges
                  Positioned(
                    bottom: 48,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badges Row (Stitch spec: 10 Mins, Up to 40% OFF, 325 Products)
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppTheme.level1,
                              ),
                              child: Text(
                                '⚡ 10 MINS',
                                style: GoogleFonts.inter(
                                  color: AppColors.onPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppTheme.level1,
                              ),
                              child: Text(
                                'UP TO 40% OFF',
                                style: GoogleFonts.inter(
                                  color: AppColors.onError,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                              ),
                              child: Text(
                                '${products.isNotEmpty ? products.length * 25 : 325} Products',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.description.isNotEmpty
                              ? category.description
                              : 'Crispy chips, biscuits, instant noodles, and more.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Sticky Search Bar & Subcategories Filter ─────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Column(
                children: [
                  // Search Input with Mic & Lens (Visual Search) Icons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppTheme.level1,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => provider.setSearchQuery(val),
                            style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search in ${category.name}...',
                              hintStyle: GoogleFonts.inter(color: AppColors.outline, fontSize: 14),
                              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.outline, size: 22),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 20),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Listening for product name...', style: GoogleFonts.inter(fontSize: 13, color: Colors.white)),
                                          backgroundColor: AppColors.primary,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.center_focus_weak_rounded, color: AppColors.primary, size: 20),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/visual-search');
                                    },
                                  ),
                                ],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filter Tune Button
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppTheme.level1,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune_rounded, color: AppColors.onSurface, size: 22),
                          onPressed: () {
                            _showFilterBottomSheet(context, provider);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Subcategory Chips Horizontal Scroll ──────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Filter: All
                  _buildFilterChip(
                    label: 'All',
                    isSelected: provider.selectedSubcategory == 'All' && _selectedFilter == 'All',
                    onTap: () {
                      setState(() => _selectedFilter = 'All');
                      provider.selectSubcategory('All');
                    },
                  ),
                  _buildFilterChip(
                    label: 'Best Sellers',
                    isSelected: _selectedFilter == 'Best Sellers',
                    onTap: () {
                      setState(() => _selectedFilter = 'Best Sellers');
                      provider.selectSubcategory('All');
                    },
                  ),
                  _buildFilterChip(
                    label: 'Popular',
                    isSelected: _selectedFilter == 'Popular',
                    onTap: () {
                      setState(() => _selectedFilter = 'Popular');
                      provider.selectSubcategory('All');
                    },
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  // Subcategories from provider
                  ...category.subcategories.where((s) => s != 'All').map((sub) {
                    final isSelected = provider.selectedSubcategory == sub;
                    return _buildFilterChip(
                      label: sub,
                      isSelected: isSelected,
                      isOutline: true,
                      onTap: () {
                        setState(() => _selectedFilter = sub);
                        provider.selectSubcategory(sub);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // ─── Count & Sort Header Bar ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${products.length} Products Available',
                    style: GoogleFonts.inter(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PopupMenuButton<String>(
                    initialValue: provider.sortOption,
                    onSelected: (val) => provider.setSortOption(val),
                    color: AppColors.surfaceContainerLowest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Sort',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'popular',
                        child: Text('Popularity', style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 13)),
                      ),
                      PopupMenuItem(
                        value: 'price_low_high',
                        child: Text('Price: Low to High', style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 13)),
                      ),
                      PopupMenuItem(
                        value: 'price_high_low',
                        child: Text('Price: High to Low', style: GoogleFonts.inter(color: AppColors.onSurface, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Product Grid ────────────────────────────────────────────────
          products.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, color: AppColors.outline, size: 64),
                        const SizedBox(height: 12),
                        Text(
                          'No products found in this category',
                          style: GoogleFonts.outfit(
                            color: AppColors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try clearing filters or search query',
                          style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: AnimationLimiter(
                    child: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = products[index];
                          final id = p['id'] as String;
                          final name = p['name'] as String;
                          final subtitle = (p['subtitle'] ?? p['sub'] ?? '500g Pack') as String;
                          final brand = (p['brand'] ?? 'Daily Basket') as String;
                          final priceNum = (p['price'] as num).toDouble();
                          final mrpNum = (p['mrp'] as num?)?.toDouble() ?? (priceNum * 1.25);
                          final image = p['image'] as String;
                          final rating = (p['rating'] ?? 4.8).toString();
                          final reviews = (p['reviews'] ?? '1.2k').toString();
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
                                      color: AppColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.surfaceContainer),
                                      boxShadow: AppTheme.level1,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product Image & Badges Overlay
                                        Stack(
                                          children: [
                                            Container(
                                              height: 128,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: AppColors.surfaceContainerLow,
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                                child: AppNetworkImage(
                                                  imageUrl: image,
                                                  height: 128,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            // Badges (Best Seller & -15%)
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if (index % 2 == 0)
                                                    Container(
                                                      margin: const EdgeInsets.only(bottom: 4),
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primary,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        'BEST SELLER',
                                                        style: GoogleFonts.inter(
                                                          color: AppColors.onPrimary,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.error,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      '-${(((mrpNum - priceNum) / mrpNum) * 100).toStringAsFixed(0)}%',
                                                      style: GoogleFonts.inter(
                                                        color: AppColors.onError,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Favorite Heart Button
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: FavoriteButton(productId: id, size: 18),
                                            ),
                                          ],
                                        ),

                                        // Product Details Content Area
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Brand Label
                                                Text(
                                                  brand.toUpperCase(),
                                                  style: GoogleFonts.inter(
                                                    color: AppColors.outline,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 2),
                                                // Product Name
                                                Text(
                                                  name,
                                                  style: GoogleFonts.outfit(
                                                    color: AppColors.onSurface,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                // Subtitle/Quantity Unit
                                                Text(
                                                  subtitle,
                                                  style: GoogleFonts.inter(
                                                    color: AppColors.onSurfaceVariant,
                                                    fontSize: 11,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                // Rating Row
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      rating,
                                                      style: GoogleFonts.inter(
                                                        color: AppColors.onSurface,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '($reviews)',
                                                      style: GoogleFonts.inter(
                                                        color: AppColors.outline,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                // Price & Action Button Row
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          '₹${mrpNum.toStringAsFixed(0)}',
                                                          style: GoogleFonts.inter(
                                                            color: AppColors.outline,
                                                            fontSize: 10,
                                                            decoration: TextDecoration.lineThrough,
                                                          ),
                                                        ),
                                                        Text(
                                                          '₹${priceNum.toStringAsFixed(0)}',
                                                          style: GoogleFonts.outfit(
                                                            color: AppColors.onSurface,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Stepper or ADD Button
                                                    currentQty > 0
                                                        ? Container(
                                                            height: 34,
                                                            decoration: BoxDecoration(
                                                              color: AppColors.primary,
                                                              borderRadius: BorderRadius.circular(8),
                                                              boxShadow: AppTheme.level1,
                                                            ),
                                                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                                                  child: const Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                                                    child: Icon(Icons.remove, size: 16, color: Colors.white),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '$currentQty',
                                                                  style: GoogleFonts.inter(
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 12,
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
                                                                  child: const Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                                                    child: Icon(Icons.add, size: 16, color: Colors.white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            height: 34,
                                                            width: 64,
                                                            child: ElevatedButton(
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
                                                                    duration: const Duration(seconds: 1),
                                                                    behavior: SnackBarBehavior.floating,
                                                                  ),
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: AppColors.secondaryContainer,
                                                                foregroundColor: AppColors.primary,
                                                                elevation: 0,
                                                                padding: EdgeInsets.zero,
                                                                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.20)),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                              ),
                                                              child: Text(
                                                                'ADD',
                                                                style: GoogleFonts.inter(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                  color: AppColors.primary,
                                                                ),
                                                              ),
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

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isOutline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isOutline ? AppColors.surfaceContainerLowest : AppColors.surfaceContainer),
            borderRadius: BorderRadius.circular(20),
            border: isOutline && !isSelected
                ? Border.all(color: AppColors.outlineVariant)
                : null,
            boxShadow: isSelected ? AppTheme.level1 : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected
                    ? AppColors.onPrimary
                    : (isOutline ? AppColors.onSurface : AppColors.onSurfaceVariant),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, CategoriesProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Text('Sort By', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: provider.sortOption,
                onChanged: (val) {
                  if (val != null) {
                    provider.setSortOption(val);
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Popularity'),
                      leading: const Radio<String>(value: 'popular'),
                      onTap: () {
                        provider.setSortOption('popular');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Price: Low to High'),
                      leading: const Radio<String>(value: 'price_low_high'),
                      onTap: () {
                        provider.setSortOption('price_low_high');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Price: High to Low'),
                      leading: const Radio<String>(value: 'price_high_low'),
                      onTap: () {
                        provider.setSortOption('price_high_low');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
