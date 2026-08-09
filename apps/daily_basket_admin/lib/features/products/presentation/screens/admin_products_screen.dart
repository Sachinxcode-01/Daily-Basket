import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Google Stitch Source of Truth Screen: Product Management Dashboard
/// Project ID: 6885817708675501691
/// Screen ID: 7f4ce4c9d581414bbd9ee1df7768f876
class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _selectedStatusFilter = 'All Products';
  String _selectedCategoryFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  int _activeNavIndex = 3; // 3 = Products tab

  // Brand Colors matching Google Stitch Specs
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF4F6F4);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintBg = Color(0xFFDCFCE7);
  static const Color _mintText = Color(0xFF15803D);
  static const Color _redBg = Color(0xFFFEE2E2);
  static const Color _redText = Color(0xFFB91C1C);
  static const Color _orangeBg = Color(0xFFFFEDD5);
  static const Color _orangeText = Color(0xFFC2410C);
  static const Color _periwinkleBg = Color(0xFFDCE6FE);

  final List<Map<String, dynamic>> _productsList = [
    {
      'id': 'FR-BAN-001',
      'brand': 'FRESH FARMS',
      'name': 'Organic Bananas (Robusta)',
      'sku': 'SKU: FR-BAN-001',
      'category': 'Fruits',
      'price': '\$1.99',
      'originalPrice': '\$2.35',
      'discount': '-15%',
      'margin': 'Margin: 42%',
      'stockAvailable': 345,
      'reserved': 12,
      'stockBadge': 'Good',
      'isLowStock': false,
      'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300',
    },
    {
      'id': 'DY-MLK-042',
      'brand': 'VALLEY DAIRY',
      'name': 'Whole Milk (1L Glass)',
      'sku': 'SKU: DY-MLK-042',
      'category': 'Dairy',
      'price': '\$4.50',
      'originalPrice': '\$4.50',
      'discount': null,
      'margin': 'Margin: 28%',
      'stockAvailable': 14,
      'reserved': 4,
      'stockBadge': 'Alert',
      'isLowStock': true,
      'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300',
    },
    {
      'id': 'BD-SD-003',
      'brand': 'ARTISAN BAKERY',
      'name': 'Sourdough Loaf (Whole Grain)',
      'sku': 'SKU: BD-SD-003',
      'category': 'Bakery',
      'price': '\$5.99',
      'originalPrice': '\$6.99',
      'discount': '-14%',
      'margin': 'Margin: 38%',
      'stockAvailable': 88,
      'reserved': 6,
      'stockBadge': 'Good',
      'isLowStock': false,
      'image': 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300',
    },
    {
      'id': 'BEV-JUC-012',
      'brand': 'TROPICAL SUN',
      'name': 'Cold Pressed Orange Juice 1L',
      'sku': 'SKU: BEV-JUC-012',
      'category': 'Beverages',
      'price': '\$3.75',
      'originalPrice': '\$4.20',
      'discount': '-10%',
      'margin': 'Margin: 35%',
      'stockAvailable': 120,
      'reserved': 8,
      'stockBadge': 'Good',
      'isLowStock': false,
      'image': 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _productsList.where((p) {
      final matchesStatus = switch (_selectedStatusFilter) {
        'Low Stock' => p['isLowStock'] == true,
        'Published' => true,
        'Draft' => false,
        _ => true,
      };

      final matchesCategory = _selectedCategoryFilter == 'All' ||
          p['category'].toString().toLowerCase() == _selectedCategoryFilter.toLowerCase();

      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) return matchesStatus && matchesCategory;

      final matchesQuery = p['name'].toString().toLowerCase().contains(query) ||
          p['sku'].toString().toLowerCase().contains(query) ||
          p['brand'].toString().toLowerCase().contains(query);

      return matchesStatus && matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: _buildStitchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Top Stat Cards Strip
            _buildStatCardsRow(),
            const SizedBox(height: 14),

            // Search Bar & Scanner
            _buildSearchBar(),
            const SizedBox(height: 12),

            // Status Filter Chips Row 1
            _buildStatusFilterChips(),
            const SizedBox(height: 8),

            // Category Filter Chips Row 2
            _buildCategoryFilterChips(),
            const SizedBox(height: 14),

            // Product Cards List
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 20.0,
                              child: FadeInAnimation(
                                child: _buildProductCard(product),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/admin/products/new'),
        backgroundColor: _primaryGreen,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildStitchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: _textDark),
        onPressed: () {},
      ),
      titleSpacing: 0,
      title: const Text(
        'Products',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: _textDark),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.smart_toy_outlined, color: _textDark),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 4),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
            ),
            backgroundColor: _primaryGreen.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsRow() {
    return SizedBox(
      height: 100,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          // Stat Card 1: TOTAL PRODUCTS (Green Solid Gradient)
          Container(
            width: 170,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF22C55E), Color(0xFF15803D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF16A34A).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL PRODUCTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '10,100',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Stat Card 2: PUBLISHED (Soft Periwinkle Lavender Card)
          Container(
            width: 170,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFC7D2FE).withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA5B4FC)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PUBLISHED',
                  style: TextStyle(
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '8,306',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 14, color: _textDark),
                decoration: const InputDecoration(
                  hintText: 'Search by name, SKU, barco...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner_rounded, color: _textDark, size: 20),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.mic_none_rounded, color: _primaryGreen, size: 22),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final filters = ['All Products', 'Published', 'Draft', 'Low Stock'];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedStatusFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedStatusFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _primaryGreen : const Color(0xFFCBD5E1),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilterChips() {
    final categories = ['All', 'Fruits', 'Vegetables', 'Dairy', 'Snacks', 'Beverages'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == _selectedCategoryFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryFilter = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? _textDark : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final bool isLowStock = product['isLowStock'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Image + Brand + Title + SKU + Low Stock Alert Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product['image'] as String,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: _primaryGreen.withOpacity(0.1),
                        child: const Icon(Icons.eco_rounded, color: _primaryGreen, size: 36),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco_outlined, color: _primaryGreen, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['brand'] as String,
                          style: const TextStyle(
                            color: _textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (isLowStock)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _redBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning_amber_rounded, color: _redText, size: 12),
                                SizedBox(width: 3),
                                Text(
                                  'Low Stock',
                                  style: TextStyle(
                                    color: _redText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product['name'] as String,
                      style: const TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product['sku'] as String,
                            style: const TextStyle(
                              color: _textDark,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '| ${product['category']}',
                          style: const TextStyle(color: _textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price, Margin & Stock Breakdown Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Price & Margin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(color: _textMuted, fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          if (product['discount'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: _mintBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product['discount'] as String,
                                style: const TextStyle(
                                  color: _mintText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            product['price'] as String,
                            style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          if (product['discount'] != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              product['originalPrice'] as String,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['margin'] as String,
                        style: const TextStyle(
                          color: _mintText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 48, color: const Color(0xFFE2E8F0)),
                const SizedBox(width: 14),

                // Stock Units & Reserved
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Stock (Units)',
                            style: TextStyle(color: _textMuted, fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isLowStock ? _orangeBg : _mintBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product['stockBadge'] as String,
                              style: TextStyle(
                                color: isLowStock ? _orangeText : _mintText,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${product['stockAvailable']}',
                              style: TextStyle(
                                color: isLowStock ? _orangeText : _textDark,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            const TextSpan(
                              text: ' Available',
                              style: TextStyle(
                                color: _textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Reserved: ${product['reserved']}',
                        style: const TextStyle(color: _textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons Row
          Row(
            children: isLowStock
                ? [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textDark,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
                          label: const Text('Restock', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textDark,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.inventory_2_outlined, size: 18),
                          label: const Text('Stock', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textDark,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.local_offer_outlined, size: 18),
                          label: const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textDark,
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 56, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting search or category filters',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.shopping_bag_outlined, 'Orders'),
              _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory'),
              _buildNavItem(3, Icons.local_offer_rounded, 'Products'),
              _buildNavItem(4, Icons.bar_chart_rounded, 'Analytics'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _activeNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeNavIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _periwinkleBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? _primaryGreen : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _textDark : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
