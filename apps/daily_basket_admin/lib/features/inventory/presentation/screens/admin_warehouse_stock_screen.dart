import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Warehouse & Stock Transfer
/// Project ID: 6885817708675501691
/// Screen ID: 61fae24afaf04b269022aaeb5696ed71
class AdminWarehouseStockScreen extends StatefulWidget {
  const AdminWarehouseStockScreen({super.key});

  @override
  State<AdminWarehouseStockScreen> createState() => _AdminWarehouseStockScreenState();
}

class _AdminWarehouseStockScreenState extends State<AdminWarehouseStockScreen> {
  bool _isLoading = false;
  String _selectedFilter = 'All';
  bool _isSmartOptimizationDismissed = false;
  final TextEditingController _searchController = TextEditingController();

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintText = Color(0xFF15803D);

  // State Data
  final Map<String, dynamic> _warehouseData = {
    'totalStock': '45.2k',
    'totalStockTrend': '+2.4%',
    'lowStockCount': 12,
    'inTransitCount': 8,
    'smartOptimizationRecommendation': 'Demand forecast indicates potential shortage. Recommend transferring 50 units of Organic Milk from WH-South to WH-Central.',
    'items': [
      {
        'id': 'INV-001',
        'name': 'Organic Farm Veggies',
        'sku': 'SKU: VEG-ORG-001',
        'location': 'WH-North • Shelf A4',
        'status': 'OPTIMAL',
        'statusBg': const Color(0xFFDCFCE7),
        'statusColor': const Color(0xFF15803D),
        'available': 342,
        'reserved': 45,
        'accentColor': Colors.transparent,
        'imageUrl': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200',
      },
      {
        'id': 'INV-002',
        'name': 'Premium Avocados',
        'sku': 'SKU: FRT-AVO-002',
        'location': 'WH-South • Cold Zone B',
        'status': 'LOW',
        'statusBg': const Color(0xFBFEE2E2),
        'statusColor': const Color(0xFFDC2626),
        'available': 12,
        'reserved': 80,
        'accentColor': const Color(0xFFDC2626),
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchWarehouseApi();
  }

  Future<void> _fetchWarehouseApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/fleet/zones'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _warehouseData['inTransitCount'] = data.length * 2;
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _executeStockTransfer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ Smart Stock Transfer triggered: 50 units Organic Milk moving to WH-Central'),
        backgroundColor: _primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: _buildStitchAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primaryGreen))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Metrics Strip
                    _buildMetricsStrip(),
                    const SizedBox(height: 14),

                    // Search Bar with Barcode Scanner Icon
                    _buildSearchInput(),
                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChipsRow(),
                    const SizedBox(height: 16),

                    // Smart Optimization Card
                    if (!_isSmartOptimizationDismissed) ...[
                      _buildSmartOptimizationCard(),
                      const SizedBox(height: 16),
                    ],

                    // Inventory List
                    _buildInventoryList(),
                    const SizedBox(height: 16),

                    // Quick Tools Section
                    _buildQuickToolsSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _primaryGreen,
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
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'Warehouse & Stock',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: _textDark),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsStrip() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Card 1: TOTAL STOCK
          Container(
            width: 140,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: _textMuted, size: 14),
                    SizedBox(width: 4),
                    Text('TOTAL STOCK', style: TextStyle(color: _textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
                Text(
                  _warehouseData['totalStock'] as String,
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                Text(
                  '📈 ${_warehouseData['totalStockTrend']}',
                  style: const TextStyle(color: _mintText, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 2: LOW STOCK
          Container(
            width: 140,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 14),
                    SizedBox(width: 4),
                    Text('LOW STOCK', style: TextStyle(color: Color(0xFFDC2626), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
                Text(
                  '${_warehouseData['lowStockCount']}',
                  style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text('Items require action', style: TextStyle(color: _textMuted, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 3: IN TRANSIT
          Container(
            width: 140,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, color: Color(0xFF0284C7), size: 14),
                    SizedBox(width: 4),
                    Text('IN TRANSIT', style: TextStyle(color: Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
                Text(
                  '${_warehouseData['inTransitCount']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text('Active transfers', style: TextStyle(color: _textMuted, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _textDark, fontSize: 13, fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          hintText: 'Search Product, SKU, Barcode...',
          hintStyle: TextStyle(color: _textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.qr_code_scanner_rounded, color: _textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = [
      {'label': 'All', 'hasDot': false},
      {'label': 'Available', 'hasDot': false},
      {'label': 'Low Stock', 'hasDot': true},
      {'label': 'In Transit', 'hasDot': false},
    ];

    return Row(
      children: filters.map((f) {
        final label = f['label'] as String;
        final hasDot = f['hasDot'] as bool;
        final bool isSelected = _selectedFilter == label;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilter = label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? _primaryGreen : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : _textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  if (hasDot) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.circle, color: Color(0xFFDC2626), size: 6),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmartOptimizationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: _primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Smart Optimization',
                style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _warehouseData['smartOptimizationRecommendation'] as String,
            style: const TextStyle(color: Color(0xFF334155), fontSize: 12, height: 1.35),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _executeStockTransfer,
                icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                label: const Text('Execute Transfer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => setState(() => _isSmartOptimizationDismissed = true),
                child: const Text('Dismiss', style: TextStyle(color: _textMuted, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    final List<Map<String, dynamic>> items = _warehouseData['items'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inventory List',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),

        ...items.map((item) {
          final isLow = item['status'] == 'LOW';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isLow ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
                width: isLow ? 1.5 : 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  if (isLow)
                    Container(
                      width: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          bottomLeft: Radius.circular(22),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  item['imageUrl'] as String,
                                  width: 54,
                                  height: 54,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['name'] as String,
                                          style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: item['statusBg'] as Color,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            item['status'] as String,
                                            style: TextStyle(
                                              color: item['statusColor'] as Color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['sku'] as String,
                                      style: const TextStyle(color: _textMuted, fontSize: 11, fontFamily: 'monospace'),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on_outlined, color: _textMuted, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            item['location'] as String,
                                            style: const TextStyle(color: _textDark, fontSize: 10.5, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('AVAILABLE', style: TextStyle(color: _textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${item['available']} ',
                                          style: TextStyle(
                                            color: isLow ? const Color(0xFFDC2626) : _textDark,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const TextSpan(text: 'units', style: TextStyle(color: _textMuted, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('RESERVED', style: TextStyle(color: _textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${item['reserved']} ',
                                          style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
                                        ),
                                        const TextSpan(text: 'units', style: TextStyle(color: _textMuted, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ],
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
          );
        }),
      ],
    );
  }

  Widget _buildQuickToolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Tools',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildToolButton(
                icon: Icons.edit_outlined,
                label: 'Adjust Stock',
                bgColor: const Color(0xFFDCE6FE),
                iconColor: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildToolButton(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Scan Barcode',
                bgColor: const Color(0xFFDCFCE7),
                iconColor: _mintText,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildToolButton(
                icon: Icons.history_rounded,
                label: 'Transfer History',
                bgColor: const Color(0xFFFCE7F3),
                iconColor: const Color(0xFFDB2777),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11),
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
              _buildNavItem(1, Icons.receipt_long_outlined, 'Orders'),
              _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory', isSelected: true),
              _buildNavItem(3, Icons.storefront_rounded, 'Suppliers'),
              _buildNavItem(4, Icons.shopping_cart_rounded, 'Purchase'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isSelected = false}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
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
