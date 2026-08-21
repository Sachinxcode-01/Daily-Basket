import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/cart_provider.dart';
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

  final List<String> _filters = ['Sort', 'Seasonal', 'Organic', 'Price'];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'prod_gala_apple',
      'name': 'Royal Gala Apple',
      'subtitle': 'Daily Basket Select',
      'unit': '500g',
      'price': 140.0,
      'mrp': 160.0,
      'badge': '10% OFF',
      'badgeColor': AppColors.error,
      'badgeTextColor': Colors.white,
      'inStock': true,
      'category': 'Seasonal',
      'image':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600&auto=format&fit=crop&q=80',
    },
    {
      'id': 'prod_banana_cavendish',
      'name': 'Premium Cavendish Banana',
      'subtitle': 'Organic',
      'unit': '1 kg',
      'price': 65.0,
      'mrp': 75.0,
      'badge': 'Out of Stock',
      'inStock': false,
      'category': 'Organic',
      'image':
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=600&auto=format&fit=crop&q=80',
    },
    {
      'id': 'prod_baby_spinach',
      'name': 'Organic Baby Spinach',
      'subtitle': 'Local Farm',
      'unit': '200g',
      'price': 45.0,
      'mrp': 55.0,
      'badge': 'Daily Basket Select',
      'badgeColor': AppColors.primaryContainer,
      'badgeTextColor': Colors.white,
      'inStock': true,
      'category': 'Organic',
      'image':
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=600&auto=format&fit=crop&q=80',
    },
    {
      'id': 'prod_dutch_carrots',
      'name': 'Dutch Carrots with Tops',
      'subtitle': 'Daily Basket Select',
      'unit': '1 Bunch (500g)',
      'price': 55.0,
      'mrp': 65.0,
      'badge': 'New',
      'badgeColor': AppColors.secondaryContainer,
      'badgeTextColor': AppColors.onSecondaryContainer,
      'inStock': true,
      'category': 'Seasonal',
      'image':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=600&auto=format&fit=crop&q=80',
    },
    {
      'id': 'prod_hass_avocado',
      'name': 'Organic Hass Avocado',
      'subtitle': 'Daily Basket Select',
      'unit': '2 pcs (400g)',
      'price': 120.0,
      'mrp': 150.0,
      'badge': '20% OFF',
      'badgeColor': AppColors.error,
      'badgeTextColor': Colors.white,
      'inStock': true,
      'category': 'Organic',
      'image':
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=600&auto=format&fit=crop&q=80',
    },
    {
      'id': 'prod_red_capsicum',
      'name': 'Fresh Red Bell Pepper',
      'subtitle': 'Hydroponic Farm',
      'unit': '250g',
      'price': 70.0,
      'mrp': 85.0,
      'badge': 'Hydroponic',
      'badgeColor': AppColors.primaryContainer,
      'badgeTextColor': Colors.white,
      'inStock': true,
      'category': 'Seasonal',
      'image':
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=600&auto=format&fit=crop&q=80',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedFilter == 'Seasonal') {
      return _allProducts.where((p) => p['category'] == 'Seasonal' || p['inStock'] == true).toList();
    } else if (_selectedFilter == 'Organic') {
      return _allProducts.where((p) => p['category'] == 'Organic' || (p['subtitle'] ?? '').toString().contains('Organic')).toList();
    } else if (_selectedFilter == 'Price') {
      final list = List<Map<String, dynamic>>.from(_allProducts);
      list.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
      return list;
    }
    return _allProducts;
  }

  void _handleAddToCart(Map<String, dynamic> product) {
    if (product['inStock'] == false) return;

    final cartProvider = context.read<CartProvider>();
    cartProvider.addItem(
      CartItem(
        id: product['id'],
        name: product['name'],
        subtitle: product['unit'],
        price: product['price'] as double,
        qty: 1,
        image: product['image'],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to basket!'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
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
                    child: Text(
                      '${products.length} products',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
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
                            onTap: () {
                              setState(() {
                                _selectedSort = _selectedSort == 'Relevance' ? 'Price Low to High' : 'Relevance';
                              });
                            },
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
                                    'Sort',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.onSurfaceVariant,
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

            // ─── Product Grid ────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 840),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      final inStock = p['inStock'] == true;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                productId: p['id'],
                                productName: p['name'],
                                price: '₹${(p['price'] as double).round()}',
                                mrp: '₹${(p['mrp'] as double).round()}',
                                unitDetails: p['unit'],
                                imageUrl: p['image'],
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
                                  // Product Image
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        p['image'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
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
                                    p['name'],
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
                                    p['unit'],
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Price Row with Add Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '₹${(p['price'] as double).round()}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          if (p['mrp'] != null)
                                            Text(
                                              '₹${(p['mrp'] as double).round()}',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: AppColors.onSurfaceVariant,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: inStock ? () => _handleAddToCart(p) : null,
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

                              // Badge / Out of Stock Overlay
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
                                      p['badge'],
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: p['badgeTextColor'] ?? Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

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
