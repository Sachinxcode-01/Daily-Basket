import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/favorites_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../shared/widgets/staggered_animated_card.dart';

/// Stitch Screen: My Favorites - Enhanced Experience
/// ID: a0d31602726f4cf4b931b35d8b3505c7
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Set<String> _selectedItems = {};
  bool _isSelectionMode = false;

  final List<Map<String, String>> _categories = [
    {'id': 'ALL', 'name': 'All Saved'},
    {'id': 'cat-veg', 'name': 'Fresh Produce 🥦'},
    {'id': 'cat-dairy', 'name': 'Dairy & Eggs 🥛'},
    {'id': 'cat-staples', 'name': 'Atta & Rice 🌾'},
    {'id': 'cat-oils', 'name': 'Oils & Ghee 🛢️'},
  ];

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final cartProvider = context.read<CartProvider>();
    final items = favProvider.items;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Favorites ❤️',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '${favProvider.count} saved item${favProvider.count != 1 ? 's' : ''} • 10-min delivery',
              style: const TextStyle(color: Color(0xFF2DD4BF), fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              favProvider.isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: const Color(0xFF2DD4BF),
            ),
            tooltip: favProvider.isGridView ? 'Switch to List View' : 'Switch to Grid View',
            onPressed: () => favProvider.toggleViewMode(),
          ),
          if (favProvider.count > 0)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (val) {
                if (val == 'select_all') {
                  setState(() {
                    _isSelectionMode = !_isSelectionMode;
                    if (_isSelectionMode) {
                      _selectedItems.addAll(items.map((e) => e['id'] as String));
                    } else {
                      _selectedItems.clear();
                    }
                  });
                } else if (val == 'clear_all') {
                  _showClearAllDialog(context, favProvider);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'select_all',
                  child: Row(
                    children: [
                      Icon(_isSelectionMode ? Icons.deselect_rounded : Icons.select_all_rounded, color: const Color(0xFF2DD4BF), size: 18),
                      const SizedBox(width: 10),
                      Text(_isSelectionMode ? 'Cancel Selection' : 'Select Multiple Items', style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_rounded, color: Color(0xFFEF4444), size: 18),
                      SizedBox(width: 10),
                      Text('Clear All Favorites', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF2DD4BF),
        backgroundColor: const Color(0xFF1E293B),
        onRefresh: () async => favProvider.refresh(),
        child: Column(
          children: [
            // Quick Reorder Hero Banner
            if (items.isNotEmpty) _buildFastReorderBanner(context, items, cartProvider),

            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 13),
                onChanged: (v) => favProvider.setSearchQuery(v),
                decoration: InputDecoration(
                  hintText: 'Search saved groceries, brands…',
                  hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2DD4BF), size: 20),
                  suffixIcon: favProvider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 18),
                          onPressed: () => favProvider.setSearchQuery(''),
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            // Category Chips Row
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = favProvider.selectedCategory == cat['id'];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat['name']!),
                      selected: isSelected,
                      selectedColor: const Color(0xFF0F766E),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(color: isSelected ? const Color(0xFF14B8A6) : const Color(0xFF334155)),
                      onSelected: (_) => favProvider.setCategory(cat['id']!),
                    ),
                  );
                },
              ),
            ),

            // Sort & Counter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${items.length} saved product${items.length != 1 ? 's' : ''}',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.sort_rounded, color: Color(0xFF2DD4BF), size: 16),
                  const SizedBox(width: 4),
                  DropdownButton<String>(
                    value: favProvider.sortBy,
                    dropdownColor: const Color(0xFF1E293B),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF2DD4BF)),
                    style: const TextStyle(color: Color(0xFF2DD4BF), fontSize: 12, fontWeight: FontWeight.bold),
                    onChanged: (v) {
                      if (v != null) favProvider.setSortBy(v);
                    },
                    items: const [
                      DropdownMenuItem(value: 'RECENTLY_ADDED', child: Text('Recently Added')),
                      DropdownMenuItem(value: 'PRICE_LOW_HIGH', child: Text('Price: Low → High')),
                      DropdownMenuItem(value: 'PRICE_HIGH_LOW', child: Text('Price: High → Low')),
                      DropdownMenuItem(value: 'ALPHABETICAL', child: Text('Alphabetical (A-Z)')),
                      DropdownMenuItem(value: 'BEST_SELLING', child: Text('Best Selling')),
                    ],
                  ),
                ],
              ),
            ),

            // Product Grid / List Body with Staggered Entrance
            Expanded(
              child: favProvider.isLoading
                  ? _buildSkeletonLoader()
                  : items.isEmpty
                      ? _buildEmptyState(context, favProvider)
                      : AnimationLimiter(
                          child: favProvider.isGridView
                              ? _buildGridView(items, cartProvider)
                              : _buildListView(items, cartProvider),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isSelectionMode && _selectedItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                border: Border(top: BorderSide(color: Color(0xFF334155), width: 0.5)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Text(
                      '${_selectedItems.length} selected',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.shopping_basket_rounded, color: Colors.white, size: 18),
                      label: const Text('Add Selected to Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        for (final id in _selectedItems) {
                          final item = items.firstWhere((e) => e['id'] == id);
                          cartProvider.addItem(CartItem(
                            id: item['id'] as String,
                            name: item['name'] as String,
                            subtitle: item['weight'] as String,
                            price: (item['price'] as double),
                            qty: 1,
                            image: item['imageUrl'] as String,
                          ));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${_selectedItems.length} favorite items to cart! 🛒'),
                            backgroundColor: const Color(0xFF0F766E),
                          ),
                        );
                        setState(() {
                          _selectedItems.clear();
                          _isSelectionMode = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildFastReorderBanner(BuildContext context, List<Map<String, dynamic>> items, CartProvider cartProvider) {
    final totalPrice = items.fold(0.0, (sum, i) => sum + (i['price'] as double));

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x3014B8A6), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Reorder Favorites',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'All ${items.length} items ready for 10-min delivery',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              for (final item in items) {
                cartProvider.addItem(CartItem(
                  id: item['id'] as String,
                  name: item['name'] as String,
                  subtitle: item['weight'] as String,
                  price: (item['price'] as double),
                  qty: 1,
                  image: item['imageUrl'] as String,
                ));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added all ${items.length} favorites to cart (₹${totalPrice.toStringAsFixed(0)}) 🛒'),
                  backgroundColor: const Color(0xFF0F766E),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    'Add All',
                    style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '₹${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> items, CartProvider cartProvider) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        final item = items[idx];
        final id = item['id'] as String;
        final isSelected = _selectedItems.contains(id);

        return StaggeredAnimatedCard(
          index: idx,
          child: GestureDetector(
            onTap: _isSelectionMode
                ? () {
                    setState(() {
                      if (isSelected) {
                        _selectedItems.remove(id);
                      } else {
                        _selectedItems.add(id);
                      }
                    });
                  }
                : () => Navigator.pushNamed(context, '/catalog/product-details', arguments: item),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2DD4BF) : const Color(0xFF334155),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top image stack with heart, discount badge, rating badge
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                        child: Image.network(
                          item['imageUrl'] as String,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: const Color(0xFF334155),
                            child: const Icon(Icons.shopping_basket_rounded, color: Color(0xFF64748B), size: 40),
                          ),
                        ),
                      ),
                      if ((item['discountPercent'] as int? ?? 0) > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              '${item['discountPercent']}% OFF',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: FavoriteButton(productId: id, productDetails: item),
                      ),
                      if (item['rating'] != null)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 11),
                                const SizedBox(width: 2),
                                Text(
                                  '${item['rating']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_isSelectionMode)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                            color: isSelected ? const Color(0xFF2DD4BF) : Colors.white70,
                          ),
                        ),
                    ],
                  ),
                  // Card Info Body
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['brand'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(
                            item['name'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, height: 1.2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(item['weight'] as String, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                '₹${(item['price'] as double).toStringAsFixed(0)}',
                                style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(width: 4),
                              if ((item['mrp'] as double) > (item['price'] as double))
                                Text(
                                  '₹${(item['mrp'] as double).toStringAsFixed(0)}',
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, decoration: TextDecoration.lineThrough),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 34,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F766E),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 14),
                              label: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                              onPressed: () {
                                cartProvider.addItem(CartItem(
                                  id: item['id'] as String,
                                  name: item['name'] as String,
                                  subtitle: item['weight'] as String,
                                  price: (item['price'] as double),
                                  qty: 1,
                                  image: item['imageUrl'] as String,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added "${item['name']}" to cart 🛒'),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: const Color(0xFF0F766E),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> items, CartProvider cartProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        final item = items[idx];
        final id = item['id'] as String;

        return StaggeredAnimatedCard(
          index: idx,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['imageUrl'] as String,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 76, height: 76, color: const Color(0xFF334155)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${item['brand']} • ${item['weight']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('₹${(item['price'] as double).toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(width: 6),
                          if ((item['mrp'] as double) > (item['price'] as double))
                            Text('₹${(item['mrp'] as double).toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    FavoriteButton(productId: id, productDetails: item),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        cartProvider.addItem(CartItem(
                          id: item['id'] as String,
                          name: item['name'] as String,
                          subtitle: item['weight'] as String,
                          price: (item['price'] as double),
                          qty: 1,
                          image: item['imageUrl'] as String,
                        ));
                      },
                      child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, FavoritesProvider favProvider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
            child: const Icon(Icons.favorite_border_rounded, color: Color(0xFF64748B), size: 64),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Favorites Found',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Tap the heart icon on any product to save it here for instant 10-minute reordering.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            label: const Text('Browse Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 80,
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, FavoritesProvider favProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Favorites?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to remove all items from your favorites list?', style: TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              favProvider.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
