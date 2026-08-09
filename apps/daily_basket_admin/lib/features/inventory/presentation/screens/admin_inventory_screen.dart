import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Google Stitch Source of Truth Screen: Inventory Management Dashboard
/// Project ID: 6885817708675501691
/// Screen ID: 97fc58a67cca4a028c337f14f0d1233c
class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  int _activeNavIndex = 2; // 2 = Inventory tab

  // Brand Colors matching Google Stitch Specs
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF4F6F4);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _inStockBg = Color(0xFFDCFCE7);
  static const Color _inStockText = Color(0xFF15803D);
  static const Color _inStockDot = Color(0xFF16A34A);
  static const Color _lowStockBg = Color(0xFFFEE2E2);
  static const Color _lowStockText = Color(0xFFB91C1C);
  static const Color _lowStockDot = Color(0xFFDC2626);
  static const Color _urgentRed = Color(0xFFB91C1C);

  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': 'AV-ORG-001',
      'name': 'Organic Hass Avocados',
      'sku': 'SKU: AV-ORG-001',
      'price': '\$2.49',
      'unit': '/ ea',
      'stock': 124,
      'status': 'IN_STOCK',
      'isLowStock': false,
      'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300',
    },
    {
      'id': 'MK-FR-002',
      'name': 'Farm Fresh Milk',
      'sku': 'SKU: MK-FR-002',
      'price': '\$4.99',
      'unit': '/ gal',
      'stock': 8,
      'status': 'LOW_STOCK',
      'isLowStock': true,
      'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300',
    },
    {
      'id': 'BD-SD-003',
      'name': 'Artisan Sourdough',
      'sku': 'SKU: BD-SD-003',
      'price': '\$6.50',
      'unit': '/ loaf',
      'stock': 42,
      'status': 'IN_STOCK',
      'isLowStock': false,
      'image': 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300',
    },
    {
      'id': 'HNY-ORG-004',
      'name': 'Organic Wildflower Honey',
      'sku': 'SKU: HNY-ORG-004',
      'price': '\$8.99',
      'unit': '/ jar',
      'stock': 15,
      'status': 'IN_STOCK',
      'isLowStock': false,
      'image': 'https://images.unsplash.com/photo-1587049352847-4a222e784d38?w=300',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    return _inventoryItems.where((item) {
      final matchesFilter = switch (_selectedFilter) {
        'Low Stock' => item['isLowStock'] == true,
        'Near Expiry' => item['stock'] < 20,
        _ => true,
      };

      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) return matchesFilter;

      final matchesQuery = item['name'].toString().toLowerCase().contains(query) ||
          item['sku'].toString().toLowerCase().contains(query);

      return matchesFilter && matchesQuery;
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

            // Category Filter Chips
            _buildFilterChips(),
            const SizedBox(height: 14),

            // Inventory Item Cards List
            Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 20.0,
                              child: FadeInAnimation(
                                child: _buildInventoryCard(item),
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
        onPressed: () => _showAddStockDialog(context),
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
        icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      titleSpacing: 0,
      title: const Text(
        'Inventory',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: _textDark),
          onPressed: () {},
        ),
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
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildStatCardsRow() {
    return SizedBox(
      height: 105,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          // Stat Card 1: Products
          _buildStatCard(
            icon: Icons.inventory_2_outlined,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: _primaryGreen,
            title: 'Products',
            value: '1,248',
            subtext: '📈 +12 this week',
            subtextColor: const Color(0xFF16A34A),
          ),
          const SizedBox(width: 12),

          // Stat Card 2: Low Stock
          _buildStatCard(
            icon: Icons.warning_amber_rounded,
            iconBg: const Color(0xFFFFEDD5),
            iconColor: const Color(0xFFC2410C),
            title: 'Low Stock',
            value: '32',
            valueColor: const Color(0xFFDC2626),
            subtext: '❗ Needs attention',
            subtextColor: const Color(0xFFC2410C),
            borderColor: const Color(0xFFFCA5A5),
          ),
          const SizedBox(width: 12),

          // Stat Card 3: Near Expiry
          _buildStatCard(
            icon: Icons.hourglass_empty_rounded,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
            title: 'Near Expiry',
            value: '15',
            subtext: '📅 Next 7 days',
            subtextColor: _textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String value,
    Color valueColor = _textDark,
    required String subtext,
    required Color subtextColor,
    Color? borderColor,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          Text(
            subtext,
            style: TextStyle(
              color: subtextColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
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
                  hintText: 'Search inventory, SKU...',
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

  Widget _buildFilterChips() {
    final filters = ['All', 'Low Stock', 'Near Expiry', 'Best Seller'];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
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

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    final bool isLowStock = item['isLowStock'] as bool;
    final int stock = item['stock'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLowStock ? const Color(0xFFFFF5F5) : _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLowStock ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0),
          width: isLowStock ? 1.5 : 1.0,
        ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  item['image'] as String,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: _primaryGreen.withOpacity(0.1),
                    child: const Icon(Icons.shopping_basket_rounded, color: _primaryGreen, size: 32),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, color: _textMuted, size: 20),
                          onSelected: (val) {},
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit SKU Details')),
                            const PopupMenuItem(value: 'barcode', child: Text('Print Barcode Label')),
                            const PopupMenuItem(value: 'delete', child: Text('Archive SKU', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      item['sku'] as String,
                      style: const TextStyle(color: _textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 8),

                    // Price & Stock Status Pill
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: item['price'] as String,
                                style: const TextStyle(
                                  color: _primaryGreen,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: ' ${item['unit']}',
                                style: const TextStyle(
                                  color: _textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Status Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLowStock ? _lowStockBg : _inStockBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isLowStock ? _lowStockDot : _inStockDot,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isLowStock ? 'Low Stock ($stock)' : 'In Stock ($stock)',
                                style: TextStyle(
                                  color: isLowStock ? _lowStockText : _inStockText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLowStock ? _urgentRed : _primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isLowStock ? Icons.bolt_rounded : Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isLowStock ? 'Urgent Restock' : 'Restock',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _textDark,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isLowStock ? Icons.local_offer_outlined : Icons.edit_outlined,
                          color: _textDark,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isLowStock ? 'Price' : 'Edit',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
          const Icon(Icons.inventory_2_outlined, size: 56, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          const Text(
            'No inventory items found',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search query or filter chips',
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
              _buildNavItem(1, Icons.shopping_basket_outlined, 'Orders'),
              _buildNavItem(2, Icons.inventory_2_rounded, 'Inventory'),
              _buildNavItem(3, Icons.bar_chart_rounded, 'Analytics'),
              _buildNavItem(4, Icons.person_outline_rounded, 'Profile'),
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
          color: isSelected ? const Color(0xFFDCFCE7) : Colors.transparent,
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
                color: isSelected ? _primaryGreen : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Add SKU to Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Scan or enter SKU details to update stock level.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            child: const Text('Add Stock', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

