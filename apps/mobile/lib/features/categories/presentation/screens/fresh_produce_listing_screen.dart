import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../catalog/presentation/screens/product_details_screen.dart';

/// Fresh Fruits & Vegetables Product Listing Screen
/// Stitch Screen ID: f8d0070376a249618783bc48ce8cf9a8
/// Project: Daily Basket Quick-Commerce Suite
class FreshProduceListingScreen extends StatefulWidget {
  const FreshProduceListingScreen({super.key});

  @override
  State<FreshProduceListingScreen> createState() => _FreshProduceListingScreenState();
}

class _FreshProduceListingScreenState extends State<FreshProduceListingScreen> {
  String _selectedFilter = 'Seasonal';
  String _selectedSort = 'Relevance';

  final List<String> _filters = [
    'Sort',
    'Seasonal',
    'Organic',
    'Price',
    'Fresh Fruits',
    'Fresh Vegetables',
    'Leafy Greens',
  ];

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final sortOptions = [
          'Relevance',
          'Price Low to High',
          'Price High to Low',
          'Rating',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Sort Products By',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const Divider(),
                ...sortOptions.map((opt) {
                  final isSelected = _selectedSort == opt;
                  return ListTile(
                    title: Text(
                      opt,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : AppColors.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedSort = opt);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final cartProvider = context.watch<CartProvider>();
    final products = categoriesProvider.getProduceProducts(
      filter: _selectedFilter,
      sort: _selectedSort,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Fresh Fruits & Vegetables',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, _) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_basket_outlined, color: AppColors.primary),
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                        if (cart.totalCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                '${cart.totalCount}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      body: SafeArea(
        child: Column(
          children: [
            // ─── Sub Header & Filter Chips Bar ──────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(color: AppColors.surfaceContainer),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${products.length} products',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        if (_selectedSort != 'Relevance')
                          InkWell(
                            onTap: _showSortBottomSheet,
                            child: Row(
                              children: [
                                const Icon(Icons.sort, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  _selectedSort,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = _selectedFilter == filter;

                        if (filter == 'Sort') {
                          return InkWell(
                            onTap: _showSortBottomSheet,
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: AppColors.outlineVariant),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.swap_vert, size: 16, color: AppColors.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedSort == 'Relevance' ? 'Sort' : _selectedSort,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedSort == 'Relevance'
                                          ? AppColors.onSurfaceVariant
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return InkWell(
                          onTap: () => setState(() => _selectedFilter = filter),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryContainer.withValues(alpha: 0.15)
                                  : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
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

            // ─── Product Grid / Empty State ─────────────────────────────────
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.eco_outlined,
                              size: 32,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No produce found',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try selecting another filter or resetting your sort options.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedFilter = 'Seasonal';
                                _selectedSort = 'Relevance';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Text('Reset Filters'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 840),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final p = products[index];
                            final inStock = p['inStock'] == true;
                            final productId = p['id'] as String;
                            final qty = cartProvider.getQuantity(productId);

                            final priceDouble = (p['price'] as num).toDouble();
                            final mrpDouble = p['mrp'] != null ? (p['mrp'] as num).toDouble() : null;
                            final unitText = (p['unit'] ?? p['subtitle'] ?? '500g').toString();
                            final productName = p['name'] as String;
                            final imageUrl = p['image'] as String;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: productId,
                                      productName: productName,
                                      price: '₹${priceDouble.round()}',
                                      mrp: mrpDouble != null ? '₹${mrpDouble.round()}' : '₹${priceDouble.round()}',
                                      unitDetails: unitText,
                                      imageUrl: imageUrl,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Product Image via AppNetworkImage
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.surfaceContainerLow,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: AppNetworkImage(
                                              imageUrl: imageUrl,
                                              fit: BoxFit.cover,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Subtitle
                                        Text(
                                          p['subtitle'] ?? 'Daily Basket Select',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurfaceVariant,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),

                                        // Product Title
                                        Text(
                                          productName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),

                                        // Unit/Weight
                                        Text(
                                          unitText,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.outline,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Price Row with Interactive Add/Stepper Button
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '₹${priceDouble.round()}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                if (mrpDouble != null)
                                                  Text(
                                                    '₹${mrpDouble.round()}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      color: AppColors.onSurfaceVariant,
                                                      decoration: TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            // Cart Action: Add or Stepper
                                            if (inStock && qty > 0)
                                              Container(
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        cartProvider.updateQuantityById(
                                                          id: productId,
                                                          name: productName,
                                                          subtitle: unitText,
                                                          price: priceDouble,
                                                          image: imageUrl,
                                                          delta: -1,
                                                        );
                                                      },
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: const Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: Icon(Icons.remove, size: 14, color: Colors.white),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                                      child: Text(
                                                        '$qty',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        cartProvider.updateQuantityById(
                                                          id: productId,
                                                          name: productName,
                                                          subtitle: unitText,
                                                          price: priceDouble,
                                                          image: imageUrl,
                                                          delta: 1,
                                                        );
                                                      },
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: const Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: Icon(Icons.add, size: 14, color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              InkWell(
                                                onTap: inStock
                                                    ? () {
                                                        cartProvider.updateQuantityById(
                                                          id: productId,
                                                          name: productName,
                                                          subtitle: unitText,
                                                          price: priceDouble,
                                                          image: imageUrl,
                                                          delta: 1,
                                                        );
                                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('$productName added to basket!'),
                                                            backgroundColor: AppColors.primary,
                                                            duration: const Duration(seconds: 1),
                                                            behavior: SnackBarBehavior.floating,
                                                          ),
                                                        );
                                                      }
                                                    : null,
                                                borderRadius: BorderRadius.circular(100),
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: inStock ? AppColors.primary : AppColors.surfaceContainerHigh,
                                                    shape: BoxShape.circle,
                                                    boxShadow: inStock
                                                        ? [
                                                            BoxShadow(
                                                              color: AppColors.primary.withValues(alpha: 0.3),
                                                              blurRadius: 4,
                                                              offset: const Offset(0, 2),
                                                            ),
                                                          ]
                                                        : null,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: inStock ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Top Row: Discount / Category Badge (Left) & Favorite Button (Right)
                                    if (p['badge'] != null && inStock)
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: p['badgeColor'] ?? AppColors.error,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            p['badge'] as String,
                                            style: GoogleFonts.inter(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: p['badgeTextColor'] ?? Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Top-Right Favorite Button
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: FavoriteButton(
                                        productId: productId,
                                        productDetails: p,
                                        size: 20,
                                      ),
                                    ),

                                    // Out of Stock Overlay
                                    if (!inStock)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.65),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.surfaceContainerHigh,
                                                borderRadius: BorderRadius.circular(100),
                                                border: Border.all(color: AppColors.outlineVariant),
                                              ),
                                              child: Text(
                                                'Out of Stock',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.onSurface,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
