import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/favorites_provider.dart';
import '../../../../core/widgets/app_network_image.dart';

class ProductListingScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListingScreen({
    super.key,
    this.categoryId = 'cat-1',
    this.categoryName = 'Fruits & Vegetables',
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSubcategory = 'All';
  String _sortBy = 'POPULAR'; // POPULAR, PRICE_LOW_HIGH, PRICE_HIGH_LOW, RATING

  final List<Map<String, dynamic>> _catalogProducts = [
    {
      'id': 'prod-001',
      'categoryId': 'cat-1',
      'categoryName': 'Fruits & Vegetables',
      'subCategory': 'Vegetables',
      'name': 'Organic Hass Avocados',
      'brand': 'Organic India',
      'subtitle': '2 pcs (approx. 400g)',
      'price': 180.0,
      'mrp': 220.0,
      'rating': 4.8,
      'deliveryTime': '10 mins',
      'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500',
    },
    {
      'id': 'prod-002',
      'categoryId': 'cat-1',
      'categoryName': 'Fruits & Vegetables',
      'subCategory': 'Vegetables',
      'name': 'Farm Fresh Tomatoes',
      'brand': 'Organic India',
      'subtitle': '500g Pack',
      'price': 45.0,
      'mrp': 55.0,
      'rating': 4.7,
      'deliveryTime': '8 mins',
      'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500',
    },
    {
      'id': 'prod-003',
      'categoryId': 'cat-1',
      'categoryName': 'Fruits & Vegetables',
      'subCategory': 'Fruits',
      'name': 'Fresh Shimla Apples',
      'brand': 'Himachal Fresh',
      'subtitle': '4 pcs (approx. 500g)',
      'price': 140.0,
      'mrp': 160.0,
      'rating': 4.9,
      'deliveryTime': '12 mins',
      'image': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500',
    },
    {
      'id': 'prod-004',
      'categoryId': 'cat-1',
      'categoryName': 'Fruits & Vegetables',
      'subCategory': 'Fruits',
      'name': 'Organic Robusta Bananas',
      'brand': 'Farm Fresh',
      'subtitle': '6 pcs (approx. 700g)',
      'price': 50.0,
      'mrp': 60.0,
      'rating': 4.6,
      'deliveryTime': '10 mins',
      'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500',
    },
    {
      'id': 'prod-005',
      'categoryId': 'cat-2',
      'categoryName': 'Dairy, Bread & Eggs',
      'subCategory': 'Milk',
      'name': 'Amul Taaza Toned Fresh Milk',
      'brand': 'Amul',
      'subtitle': '1 Litre Pouch',
      'price': 70.0,
      'mrp': 75.0,
      'rating': 4.9,
      'deliveryTime': '8 mins',
      'image': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500',
    },
    {
      'id': 'prod-006',
      'categoryId': 'cat-2',
      'categoryName': 'Dairy, Bread & Eggs',
      'subCategory': 'Bread',
      'name': 'Whole Wheat Gourmet Bread',
      'brand': 'English Oven',
      'subtitle': '400g Pack',
      'price': 50.0,
      'mrp': 55.0,
      'rating': 4.7,
      'deliveryTime': '10 mins',
      'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
    },
    {
      'id': 'prod-007',
      'categoryId': 'cat-3',
      'categoryName': 'Cold Drinks & Juices',
      'subCategory': 'Juices',
      'name': 'Raw Pressed Orange Juice',
      'brand': 'Raw Pressery',
      'subtitle': '250 ml Bottle',
      'price': 90.0,
      'mrp': 110.0,
      'rating': 4.8,
      'deliveryTime': '10 mins',
      'image': 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500',
    },
    {
      'id': 'prod-008',
      'categoryId': 'cat-4',
      'categoryName': 'Snacks & Munchies',
      'subCategory': 'Chips',
      'name': 'Sea Salt Potato Chips',
      'brand': 'Kettle Studio',
      'subtitle': '125g Pack',
      'price': 85.0,
      'mrp': 99.0,
      'rating': 4.7,
      'deliveryTime': '10 mins',
      'image': 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    var list = _catalogProducts.where((p) {
      if (widget.categoryId.isNotEmpty && widget.categoryId != 'ALL') {
        return p['categoryId'] == widget.categoryId ||
            p['categoryName'].toString().toLowerCase().contains(widget.categoryName.toLowerCase());
      }
      return true;
    }).toList();

    if (_selectedSubcategory != 'All') {
      list = list.where((p) => p['subCategory'] == _selectedSubcategory).toList();
    }

    if (_searchController.text.trim().isNotEmpty) {
      final q = _searchController.text.trim().toLowerCase();
      list = list.where((p) =>
          p['name'].toString().toLowerCase().contains(q) ||
          p['brand'].toString().toLowerCase().contains(q)).toList();
    }

    if (_sortBy == 'PRICE_LOW_HIGH') {
      list.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_sortBy == 'PRICE_HIGH_LOW') {
      list.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
    } else if (_sortBy == 'RATING') {
      list.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    }

    return list;
  }

  List<String> get subcategories {
    final set = <String>{'All'};
    for (var p in _catalogProducts) {
      if (p['categoryId'] == widget.categoryId ||
          p['categoryName'].toString().toLowerCase().contains(widget.categoryName.toLowerCase())) {
        if (p['subCategory'] != null) {
          set.add(p['subCategory'] as String);
        }
      }
    }
    return set.toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final products = filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.categoryName,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1C1E),
              ),
            ),
            Text(
              '${products.length} Items Available',
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6E7A6C)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF006B23)),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Strip
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search in ${widget.categoryName}...',
                            hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9EA59D)),
                            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6E7A6C)),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () => setState(() => _searchController.clear()),
                                  )
                                : null,
                            filled: true,
                            fillColor: const Color(0xFFF3F3F6),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.sort_rounded, color: Color(0xFF006B23), size: 20),
                        ),
                        onSelected: (val) => setState(() => _sortBy = val),
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: 'POPULAR', child: Text('Most Popular')),
                          const PopupMenuItem(value: 'PRICE_LOW_HIGH', child: Text('Price: Low to High')),
                          const PopupMenuItem(value: 'PRICE_HIGH_LOW', child: Text('Price: High to Low')),
                          const PopupMenuItem(value: 'RATING', child: Text('Top Rated')),
                        ],
                      ),
                    ],
                  ),
                  if (subcategories.length > 1) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 34,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: subcategories.length,
                        itemBuilder: (context, idx) {
                          final sub = subcategories[idx];
                          final isSelected = _selectedSubcategory == sub;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(sub),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedSubcategory = sub),
                              selectedColor: const Color(0xFF006B23),
                              backgroundColor: const Color(0xFFF3F3F6),
                              labelStyle: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Product Grid or Empty State
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 64, color: Color(0xFF9EA59D)),
                          const SizedBox(height: 12),
                          Text(
                            'No products found',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try adjusting your search or subcategory filter.',
                            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6E7A6C)),
                          ),
                        ],
                      ),
                    )
                  : AnimationLimiter(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final item = products[index];
                          final isFav = favoritesProvider.isFavorite(item['id']);
                          final qtyInCart = cartProvider.getQuantity(item['id']);

                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 300),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/product-details',
                                      arguments: {
                                        'productId': item['id'],
                                        'productName': item['name'],
                                        'price': '₹${(item['price'] as double).toStringAsFixed(0)}',
                                        'mrp': '₹${(item['mrp'] as double).toStringAsFixed(0)}',
                                        'unitDetails': item['subtitle'],
                                        'imageUrl': item['image'],
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFBECAB9).withValues(alpha: 0.3),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.03),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Image Stack with Heart & Delivery Tag
                                        Stack(
                                          children: [
                                            AppNetworkImage(
                                              imageUrl: item['image'],
                                              width: double.infinity,
                                              height: 120,
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  favoritesProvider.toggleFavorite(item['id'], item);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                    color: isFav ? const Color(0xFFD32F2F) : const Color(0xFF6E7A6C),
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 6,
                                              left: 6,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF006B23),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  item['deliveryTime'],
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Product Text Info
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['brand'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF6E7A6C),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['name'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF1A1C1E),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['subtitle'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: const Color(0xFF6E7A6C),
                                                ),
                                              ),
                                              const SizedBox(height: 6),

                                              // Price & Add Button Row
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '₹${(item['price'] as double).toStringAsFixed(0)}',
                                                        style: GoogleFonts.outfit(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w800,
                                                          color: const Color(0xFF006B23),
                                                        ),
                                                      ),
                                                      Text(
                                                        '₹${(item['mrp'] as double).toStringAsFixed(0)}',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 10,
                                                          decoration: TextDecoration.lineThrough,
                                                          color: const Color(0xFF9EA59D),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  qtyInCart > 0
                                                      ? Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFE8F5E9),
                                                            borderRadius: BorderRadius.circular(8),
                                                            border: Border.all(color: const Color(0xFF006B23)),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () => cartProvider.updateQuantityById(
                                                                  id: item['id'],
                                                                  name: item['name'],
                                                                  subtitle: item['subtitle'],
                                                                  price: item['price'],
                                                                  image: item['image'],
                                                                  delta: -1,
                                                                ),
                                                                child: const Icon(Icons.remove, size: 14, color: Color(0xFF006B23)),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                child: Text(
                                                                  '$qtyInCart',
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w800,
                                                                    color: const Color(0xFF006B23),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () => cartProvider.updateQuantityById(
                                                                  id: item['id'],
                                                                  name: item['name'],
                                                                  subtitle: item['subtitle'],
                                                                  price: item['price'],
                                                                  image: item['image'],
                                                                  delta: 1,
                                                                ),
                                                                child: const Icon(Icons.add, size: 14, color: Color(0xFF006B23)),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            cartProvider.updateQuantityById(
                                                              id: item['id'],
                                                              name: item['name'],
                                                              subtitle: item['subtitle'],
                                                              price: item['price'],
                                                              image: item['image'],
                                                              delta: 1,
                                                            );
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: const Color(0xFF006B23),
                                                            foregroundColor: Colors.white,
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                            minimumSize: Size.zero,
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'ADD',
                                                            style: GoogleFonts.outfit(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w800,
                                                            ),
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
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
