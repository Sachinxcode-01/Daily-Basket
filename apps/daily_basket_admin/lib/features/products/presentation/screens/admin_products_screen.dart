import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_products_provider.dart';
import 'admin_add_product_basic_info_screen.dart';
import 'admin_product_details_screen.dart';

/// Product Management Dashboard — Daily Basket Admin
/// Single Source of Truth: design.md
/// Full CRUD, stock controllers, pricing controllers, filters, and status toggles
class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Brand Colors matching design.md
  static const Color _primaryGreen = Color(0xFF2D9D43);
  static const Color _primaryDark = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF9F9FC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF191C1E);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintBg = Color(0xFFDCFCE7);
  static const Color _mintText = Color(0xFF15803D);
  static const Color _redBg = Color(0xFFFEE2E2);
  static const Color _redText = Color(0xFFB91C1C);
  static const Color _orangeBg = Color(0xFFFFEDD5);
  static const Color _orangeText = Color(0xFFC2410C);
  static const Color _borderColor = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortSheet(BuildContext context, AdminProductsProvider provider) {
    final sortOptions = [
      'Default',
      'Price: Low to High',
      'Price: High to Low',
      'Stock: Low to High',
      'Name: A-Z',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort Catalog',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...sortOptions.map((opt) {
              final isSelected = provider.selectedSort == opt;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: isSelected ? _mintBg : null,
                title: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? _primaryDark : _textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: _primaryDark)
                    : null,
                onTap: () {
                  provider.setSort(opt);
                  Navigator.pop(ctx);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showRestockModal(BuildContext context, AdminProduct product, AdminProductsProvider provider) {
    final stockCtrl = TextEditingController(text: product.stockAvailable.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adjust Inventory Stock',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      Text(
                        product.name,
                        style: const TextStyle(color: _textMuted, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Quick preset increment buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickDeltaBtn(ctx, '+10 units', () {
                  provider.adjustStock(product.id, 10);
                  Navigator.pop(ctx);
                  _showSnack(context, 'Added 10 units to ${product.name}');
                }),
                _buildQuickDeltaBtn(ctx, '+25 units', () {
                  provider.adjustStock(product.id, 25);
                  Navigator.pop(ctx);
                  _showSnack(context, 'Added 25 units to ${product.name}');
                }),
                _buildQuickDeltaBtn(ctx, '+50 units', () {
                  provider.adjustStock(product.id, 50);
                  Navigator.pop(ctx);
                  _showSnack(context, 'Added 50 units to ${product.name}');
                }),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Set Exact Stock Available (Units)',
                labelStyle: const TextStyle(color: _textMuted),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primaryGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final val = int.tryParse(stockCtrl.text);
                  if (val != null) {
                    provider.quickUpdateStock(product.id, val);
                    Navigator.pop(ctx);
                    _showSnack(context, 'Updated stock to $val units');
                  }
                },
                child: const Text('Update Stock Level', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDeltaBtn(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _mintBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: _primaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, AdminProduct product, AdminProductsProvider provider) {
    final nameCtrl = TextEditingController(text: product.name);
    final brandCtrl = TextEditingController(text: product.brand);
    final priceCtrl = TextEditingController(text: product.price.toStringAsFixed(0));
    final mrpCtrl = TextEditingController(text: product.originalPrice.toStringAsFixed(0));
    final stockCtrl = TextEditingController(text: product.stockAvailable.toString());
    final unitCtrl = TextEditingController(text: product.unit);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Product Details', style: TextStyle(fontWeight: FontWeight.bold, color: _textDark)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: brandCtrl,
                decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price (₹)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: mrpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'MRP (₹)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock Units', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: unitCtrl,
                      decoration: const InputDecoration(labelText: 'Unit (e.g. 1 kg)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final newPrice = double.tryParse(priceCtrl.text) ?? product.price;
              final newMrp = double.tryParse(mrpCtrl.text) ?? product.originalPrice;
              final newStock = int.tryParse(stockCtrl.text) ?? product.stockAvailable;

              final updated = product.copyWith(
                name: nameCtrl.text.trim(),
                brand: brandCtrl.text.trim(),
                price: newPrice,
                originalPrice: newMrp,
                stockAvailable: newStock,
                unit: unitCtrl.text.trim(),
                status: newStock <= 0 ? 'Out of Stock' : product.status,
              );
              provider.updateProduct(updated);
              Navigator.pop(ctx);
              _showSnack(context, 'Saved changes to ${updated.name}');
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AdminProduct product, AdminProductsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Product', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
        content: Text('Are you sure you want to permanently delete "${product.name}" from the store catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              provider.deleteProduct(product.id);
              Navigator.pop(ctx);
              _showSnack(context, 'Deleted "${product.name}"');
            },
            child: const Text('Delete Product'),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<AdminProductsProvider>();
    final productsList = productsProvider.filteredProducts;

    return Scaffold(
      backgroundColor: _bgLight,
      appBar: _buildAppBar(context, productsProvider),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primaryGreen,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminAddProductBasicInfoScreen()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Stat Cards Row
            _buildStatCardsRow(productsProvider),
            const SizedBox(height: 12),

            // Search Bar & Filter Buttons
            _buildSearchBar(productsProvider),
            const SizedBox(height: 10),

            // Status Filter Chips
            _buildStatusFilterChips(productsProvider),
            const SizedBox(height: 8),

            // Category Filter Chips
            _buildCategoryFilterChips(productsProvider),
            const SizedBox(height: 12),

            // Catalog Header with result count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${productsList.length} Products Found',
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (productsProvider.searchQuery.isNotEmpty ||
                      productsProvider.selectedCategoryFilter != 'All' ||
                      productsProvider.selectedStatusFilter != 'All Products')
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        productsProvider.resetFilters();
                      },
                      child: const Text(
                        'Clear Filters',
                        style: TextStyle(
                          color: _primaryGreen,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Products List
            Expanded(
              child: productsList.isEmpty
                  ? _buildEmptyState(productsProvider)
                  : AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                        itemCount: productsList.length,
                        itemBuilder: (context, index) {
                          final product = productsList[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              verticalOffset: 20.0,
                              child: FadeInAnimation(
                                child: _buildProductCard(context, product, productsProvider),
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

  PreferredSizeWidget _buildAppBar(BuildContext context, AdminProductsProvider provider) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: Builder(
        builder: (ctx) {
          if (Scaffold.maybeOf(ctx)?.hasDrawer ?? false) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded, color: _textDark),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            );
          }
          if (Navigator.canPop(ctx)) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
              onPressed: () => Navigator.pop(ctx),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          const Text(
            'Products Catalog',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _mintBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${provider.totalProductsCount} Live',
              style: const TextStyle(
                color: _mintText,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort_rounded, color: _textDark),
          tooltip: 'Sort Catalog',
          onPressed: () => _showSortSheet(context, provider),
        ),
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: _primaryGreen),
          tooltip: 'Reset Filters',
          onPressed: () {
            _searchController.clear();
            provider.resetFilters();
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildStatCardsRow(AdminProductsProvider provider) {
    return SizedBox(
      height: 90,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          // Stat 1: Total SKUs
          _buildStatCard(
            title: 'TOTAL PRODUCTS',
            value: '${provider.totalProductsCount}',
            icon: Icons.inventory_2_rounded,
            bgColor: const Color(0xFFF0FDF4),
            borderColor: const Color(0xFFBBF7D0),
            valueColor: _primaryDark,
            iconColor: _primaryGreen,
          ),
          const SizedBox(width: 10),

          // Stat 2: Low Stock Alert
          _buildStatCard(
            title: 'LOW STOCK ALERT',
            value: '${provider.lowStockCount}',
            icon: Icons.warning_amber_rounded,
            bgColor: _orangeBg,
            borderColor: const Color(0xFFFFEDD5),
            valueColor: _orangeText,
            iconColor: _orangeText,
          ),
          const SizedBox(width: 10),

          // Stat 3: Out of Stock
          _buildStatCard(
            title: 'OUT OF STOCK',
            value: '${provider.outOfStockCount}',
            icon: Icons.remove_circle_outline_rounded,
            bgColor: _redBg,
            borderColor: const Color(0xFFFECACA),
            valueColor: _redText,
            iconColor: _redText,
          ),
          const SizedBox(width: 10),

          // Stat 4: Inventory Valuation
          _buildStatCard(
            title: 'INVENTORY VALUE',
            value: '₹${(provider.totalInventoryValue / 1000).toStringAsFixed(1)}k',
            icon: Icons.currency_rupee_rounded,
            bgColor: const Color(0xFFEFF6FF),
            borderColor: const Color(0xFFBFDBFE),
            valueColor: const Color(0xFF1D4ED8),
            iconColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color valueColor,
    required Color iconColor,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(icon, color: iconColor.withOpacity(0.4), size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AdminProductsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search_rounded, color: _textMuted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) => provider.setSearchQuery(val),
                style: const TextStyle(fontSize: 14, color: _textDark),
                decoration: const InputDecoration(
                  hintText: 'Search product, SKU, barcode, brand...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18, color: _textMuted),
                onPressed: () {
                  _searchController.clear();
                  provider.setSearchQuery('');
                },
              ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner_rounded, color: _primaryDark, size: 20),
              tooltip: 'Scan Barcode',
              onPressed: () {
                _searchController.text = '8901234567890';
                provider.setSearchQuery('8901234567890');
                _showSnack(context, 'Simulated barcode scan: 8901234567890');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilterChips(AdminProductsProvider provider) {
    final filters = ['All Products', 'Low Stock', 'Out of Stock', 'Published', 'Draft'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == provider.selectedStatusFilter;
          return GestureDetector(
            onTap: () => provider.setStatusFilter(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _primaryGreen : _borderColor,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF334155),
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

  Widget _buildCategoryFilterChips(AdminProductsProvider provider) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: provider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = provider.categories[index];
          final isSelected = cat == provider.selectedCategoryFilter;
          return GestureDetector(
            onTap: () => provider.setCategoryFilter(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? _textDark : _textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 11.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, AdminProduct product, AdminProductsProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: product.isLowStock
              ? const Color(0xFFFDBA74)
              : (product.isOutOfStock ? const Color(0xFFFCA5A5) : _borderColor),
          width: product.isLowStock || product.isOutOfStock ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminProductDetailsScreen(initialProductId: product.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Image + Metadata + Action Buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        product.image,
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 76,
                          height: 76,
                          color: _primaryGreen.withOpacity(0.1),
                          child: const Icon(Icons.eco_rounded, color: _primaryGreen, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title, Brand & Badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.brand,
                                style: const TextStyle(
                                  color: _textMuted,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              // Status pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: product.status == 'Published'
                                      ? _mintBg
                                      : (product.status == 'Draft'
                                          ? const Color(0xFFF1F5F9)
                                          : _redBg),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product.status,
                                  style: TextStyle(
                                    color: product.status == 'Published'
                                        ? _mintText
                                        : (product.status == 'Draft'
                                            ? _textMuted
                                            : _redText),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.sku,
                                  style: const TextStyle(
                                    color: _textMuted,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.unit,
                                  style: const TextStyle(
                                    color: _textMuted,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
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
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Pricing & Stock Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Pricing Column
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            color: _primaryDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.formattedOriginalPrice,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: _redBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${product.discountPercent}% OFF',
                              style: const TextStyle(
                                color: _redText,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Stock Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.isOutOfStock
                            ? _redBg
                            : (product.isLowStock ? _orangeBg : _mintBg),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.isOutOfStock
                                ? Icons.cancel_rounded
                                : (product.isLowStock
                                    ? Icons.warning_amber_rounded
                                    : Icons.check_circle_outline_rounded),
                            color: product.isOutOfStock
                                ? _redText
                                : (product.isLowStock ? _orangeText : _mintText),
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product.stockAvailable} in Stock',
                            style: TextStyle(
                              color: product.isOutOfStock
                                  ? _redText
                                  : (product.isLowStock ? _orangeText : _mintText),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Bottom Action Controllers Bar
                Row(
                  children: [
                    // Quick Restock Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryDark,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                        label: const Text('Restock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () => _showRestockModal(context, product, provider),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Edit Details Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textDark,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () => _showEditProductDialog(context, product, provider),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Toggle Publish / Draft
                    IconButton(
                      icon: Icon(
                        product.status == 'Published'
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: product.status == 'Published' ? _primaryGreen : _textMuted,
                        size: 20,
                      ),
                      tooltip: product.status == 'Published' ? 'Unpublish (Draft)' : 'Publish Product',
                      onPressed: () {
                        provider.toggleProductStatus(product.id);
                        _showSnack(
                          context,
                          product.status == 'Published'
                              ? 'Moved "${product.name}" to Draft'
                              : 'Published "${product.name}"',
                        );
                      },
                    ),

                    // Duplicate Button
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: _textMuted, size: 18),
                      tooltip: 'Duplicate Product',
                      onPressed: () {
                        provider.duplicateProduct(product.id);
                        _showSnack(context, 'Duplicated "${product.name}"');
                      },
                    ),

                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626), size: 20),
                      tooltip: 'Delete Product',
                      onPressed: () => _showDeleteDialog(context, product, provider),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AdminProductsProvider provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 14),
          const Text(
            'No products found matching filters',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try clearing your search query or changing filters.',
            style: TextStyle(color: _textMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              _searchController.clear();
              provider.resetFilters();
            },
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }
}
