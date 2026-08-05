import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/widgets/staggered_animated_card.dart';

/// Stitch Screen: Inventory - Stock & Expiry
/// ID: 7104b640b2f24799946ab9a420d41e70
class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Organic Farm Tomatoes 500g',
      'sku': 'SKU-TOM-001',
      'shelf': 'Aisle-1-A4',
      'stock': 142,
      'minStock': 20,
      'batchCode': 'BAT-2408-01',
      'expiresIn': 6,
      'category': 'Fresh Produce',
      'buyPrice': 28.0,
      'sellPrice': 45.0,
      'alert': null,
    },
    {
      'name': 'Amul Taaza Toned Milk 1L',
      'sku': 'SKU-MLK-002',
      'shelf': 'Aisle-2-B1',
      'stock': 88,
      'minStock': 30,
      'batchCode': 'BAT-2408-02',
      'expiresIn': 3,
      'category': 'Dairy',
      'buyPrice': 52.0,
      'sellPrice': 68.0,
      'alert': 'Near-Expiry',
    },
    {
      'name': 'Organic Milk 500ml',
      'sku': 'SKU-MLK-003',
      'shelf': 'Aisle-2-B2',
      'stock': 14,
      'minStock': 20,
      'batchCode': 'BAT-9921',
      'expiresIn': 2,
      'category': 'Dairy',
      'buyPrice': 38.0,
      'sellPrice': 55.0,
      'alert': 'Critical Expiry',
    },
    {
      'name': 'Fresh Sandwich Bread 400g',
      'sku': 'SKU-BRD-004',
      'shelf': 'Aisle-3-C1',
      'stock': 8,
      'minStock': 15,
      'batchCode': 'BAT-8812',
      'expiresIn': 1,
      'category': 'Bakery',
      'buyPrice': 30.0,
      'sellPrice': 42.0,
      'alert': 'Critical Expiry',
    },
    {
      'name': 'Aashirvaad Atta 5kg',
      'sku': 'SKU-ATT-005',
      'shelf': 'Aisle-4-D1',
      'stock': 55,
      'minStock': 10,
      'batchCode': 'BAT-7712',
      'expiresIn': 180,
      'category': 'Staples',
      'buyPrice': 215.0,
      'sellPrice': 265.0,
      'alert': null,
    },
    {
      'name': 'Fortune Sunlite Sunflower Oil 1L',
      'sku': 'SKU-OIL-006',
      'shelf': 'Aisle-4-D2',
      'stock': 3,
      'minStock': 10,
      'batchCode': 'BAT-5520',
      'expiresIn': 365,
      'category': 'Oils & Ghee',
      'buyPrice': 420.0,
      'sellPrice': 599.0,
      'alert': 'Low Stock',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    var list = _products;
    if (_searchQuery.isNotEmpty) {
      list = list.where((p) =>
        (p['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (p['sku'] as String).toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    switch (_selectedFilter) {
      case 1: return list.where((p) => p['alert'] != null && (p['alert'] as String).contains('Expiry')).toList();
      case 2: return list.where((p) => (p['stock'] as int) <= (p['minStock'] as int)).toList();
      default: return list;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Inventory — Stock & Expiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded, color: Color(0xFF2DD4BF)),
            tooltip: 'Add Product / GRN',
            onPressed: () => _showAddProductSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF2DD4BF)),
            tooltip: 'Scan Barcode',
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Inventory KPI header
          StaggeredAnimatedCard(
            index: 0,
            child: _buildInventoryKpis(),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search products, SKU, batch…',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(label: 'All Items', index: 0, selected: _selectedFilter, onTap: (i) => setState(() => _selectedFilter = i)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Near-Expiry ⚠️', index: 1, selected: _selectedFilter, onTap: (i) => setState(() => _selectedFilter = i)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Low Stock 🔴', index: 2, selected: _selectedFilter, onTap: (i) => setState(() => _selectedFilter = i)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product list with staggered scrolling animation
          Expanded(
            child: _filteredProducts.isEmpty
              ? const Center(child: Text('No products found', style: TextStyle(color: Color(0xFF64748B))))
              : AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return StaggeredAnimatedCard(
                        index: index,
                        margin: const EdgeInsets.only(bottom: 10),
                        onTap: () => _showProductDetail(context, _filteredProducts[index]),
                        child: _buildProductCard(_filteredProducts[index]),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F766E),
        icon: const Icon(Icons.post_add_rounded, color: Colors.white),
        label: const Text('New PO Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAddProductSheet(context),
      ),
    );
  }

  Widget _buildInventoryKpis() {
    final total = _products.length;
    final lowStock = _products.where((p) => (p['stock'] as int) <= (p['minStock'] as int)).length;
    final expiring = _products.where((p) => p['alert'] != null).length;
    final totalValue = _products.fold(0.0, (sum, p) => sum + (p['stock'] as int) * (p['buyPrice'] as double));

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F2034)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _kpiMini('Total SKUs', '$total', const Color(0xFF2DD4BF)),
          _kpiDivider(),
          _kpiMini('Low Stock', '$lowStock', const Color(0xFFEF4444)),
          _kpiDivider(),
          _kpiMini('Expiring Soon', '$expiring', const Color(0xFFF59E0B)),
          _kpiDivider(),
          _kpiMini('Stock Value', '₹${(totalValue / 1000).toStringAsFixed(1)}K', const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _kpiMini(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
      ],
    );
  }

  Widget _kpiDivider() => Container(width: 1, height: 32, color: const Color(0xFF334155));

  Widget _buildProductCard(Map<String, dynamic> product) {
    final stock = product['stock'] as int;
    final minStock = product['minStock'] as int;
    final expiresIn = product['expiresIn'] as int;
    final alert = product['alert'] as String?;
    final stockPercent = (stock / (minStock * 10)).clamp(0.0, 1.0);

    Color alertColor = const Color(0xFF10B981);
    if (alert == 'Critical Expiry') {
      alertColor = const Color(0xFFEF4444);
    } else if (alert == 'Near-Expiry') {
      alertColor = const Color(0xFFF59E0B);
    } else if (alert == 'Low Stock') {
      alertColor = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: alert != null ? Border.all(color: alertColor.withOpacity(0.4)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${product['sku']} • ${product['shelf']} • ${product['category']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (alert != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: alertColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(alert, style: TextStyle(color: alertColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Stock: $stock units', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                        Text(expiresIn <= 3 ? 'Expires in $expiresIn day${expiresIn != 1 ? 's' : ''}' : '$expiresIn days shelf life', style: TextStyle(color: alertColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: stockPercent,
                        backgroundColor: const Color(0xFF334155),
                        valueColor: AlwaysStoppedAnimation<Color>(stock <= minStock ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${(product['sellPrice'] as double).toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('buy ₹${(product['buyPrice'] as double).toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductDetail(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF475569), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(product['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text('Batch: ${product['batchCode']} • ${product['shelf']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _detailKpi('Stock', '${product['stock']} units', const Color(0xFF2DD4BF)),
                _detailKpi('Min. Stock', '${product['minStock']} units', const Color(0xFFF59E0B)),
                _detailKpi('Expires', '${product['expiresIn']} days', const Color(0xFFEF4444)),
                _detailKpi('Margin', '${((1 - (product['buyPrice'] as double) / (product['sellPrice'] as double)) * 100).toStringAsFixed(0)}%', const Color(0xFF10B981)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: StaggeredAnimatedButton(
                    index: 0,
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF2DD4BF),
                    borderSide: const BorderSide(color: Color(0xFF2DD4BF)),
                    onPressed: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_rounded, size: 16),
                        SizedBox(width: 6),
                        Text('Adjust Stock'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StaggeredAnimatedButton(
                    index: 1,
                    backgroundColor: const Color(0xFF0F766E),
                    onPressed: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Flash Sale', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailKpi(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
      ],
    );
  }

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Product / GRN Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            _buildField('Product Name'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildField('SKU Code')),
              const SizedBox(width: 12),
              Expanded(child: _buildField('EAN / Barcode (890...)')),
            ]),
            const SizedBox(height: 12),
            _buildField('Search Keywords & Brand Aliases'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildField('Quantity')),
              const SizedBox(width: 12),
              Expanded(child: _buildField('Shelf Location')),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildField('Buy Price (₹)')),
              const SizedBox(width: 12),
              Expanded(child: _buildField('Sell Price (₹)')),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: StaggeredAnimatedButton(
                index: 0,
                backgroundColor: const Color(0xFF0F766E),
                onPressed: () => Navigator.pop(context),
                child: const Text('Save GRN Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int index;
  final int selected;
  final void Function(int) onTap;
  const _FilterChip({required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF14B8A6) : const Color(0xFF334155)),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
      ),
    );
  }
}
