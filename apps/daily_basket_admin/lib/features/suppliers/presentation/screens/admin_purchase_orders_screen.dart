import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Purchase Order Management
/// Project ID: 6885817708675501691
/// Screen ID: 1ed38b1be9d84fa6a1eabb2b964f9a70
class AdminPurchaseOrdersScreen extends StatefulWidget {
  const AdminPurchaseOrdersScreen({super.key});

  @override
  State<AdminPurchaseOrdersScreen> createState() => _AdminPurchaseOrdersScreenState();
}

class _AdminPurchaseOrdersScreenState extends State<AdminPurchaseOrdersScreen> {
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);

  // State Data
  final Map<String, dynamic> _poData = {
    'totalPOs': '1,240',
    'pendingCount': 18,
    'inTransitCount': 12,
    'aiPurchaseInsight': 'Suggested 15% increase in Avocado orders for next week based on local festival demand forecast.',
    'orders': [
      {
        'id': 'PO #1084',
        'status': 'IN TRANSIT',
        'statusBg': const Color(0xFFE0F2FE),
        'statusColor': const Color(0xFF0284C7),
        'amount': '₹14,500',
        'supplier': 'Organic Roots Co.',
        'expectedDate': '24 Oct',
        'progress': 0.7,
        'action1Label': 'Download PDF',
        'action2Label': 'Receive Goods',
        'action2Bg': _primaryGreen,
      },
      {
        'id': 'PO #1085',
        'status': 'PENDING',
        'statusBg': const Color(0xFFFFEDD5),
        'statusColor': const Color(0xFFC2410C),
        'amount': '₹8,200',
        'supplier': 'Fresh Farms Ltd.',
        'expectedDate': '26 Oct',
        'progress': 0.3,
        'action1Label': 'Review',
        'action2Label': 'Approve',
        'action2Bg': _primaryGreen,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchPurchaseOrdersApi();
  }

  Future<void> _fetchPurchaseOrdersApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/purchase-management/orders'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _poData['pendingCount'] = data.length;
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleReceiveGoods(String poId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('GRN Goods Receipt recorded for $poId'),
        backgroundColor: _primaryGreen,
        duration: const Duration(seconds: 2),
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
                    // AI Purchase Insight Banner
                    _buildAiInsightBanner(),
                    const SizedBox(height: 16),

                    // Metrics Strip (3 Cards with Left Accent Bar)
                    _buildMetricsStrip(),
                    const SizedBox(height: 16),

                    // Search Field
                    _buildSearchInput(),
                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChipsRow(),
                    const SizedBox(height: 16),

                    // Active Orders List
                    _buildActiveOrdersList(),
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
        'Daily Basket',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiInsightBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCE6FE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: _primaryGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Purchase Insight',
                  style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _poData['aiPurchaseInsight'] as String,
                  style: const TextStyle(color: Color(0xFF334155), fontSize: 11.5, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsStrip() {
    return SizedBox(
      height: 94,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Card 1: Total POs
          _buildAccentMetricCard(
            label: 'Total POs',
            value: _poData['totalPOs'] as String,
            icon: Icons.assignment_outlined,
            accentColor: const Color(0xFF475569),
          ),
          const SizedBox(width: 12),

          // Card 2: Pending
          _buildAccentMetricCard(
            label: 'Pending',
            value: '${_poData['pendingCount']}',
            icon: Icons.timer_outlined,
            accentColor: const Color(0xFFC2410C),
          ),
          const SizedBox(width: 12),

          // Card 3: In Transit
          _buildAccentMetricCard(
            label: 'In Transit',
            value: '${_poData['inTransitCount']}',
            icon: Icons.local_shipping_outlined,
            accentColor: const Color(0xFF0284C7),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label, style: const TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                        Icon(icon, color: accentColor, size: 16),
                      ],
                    ),
                    Text(
                      value,
                      style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          hintText: 'Search PO#, Supplier, Product...',
          hintStyle: TextStyle(color: _textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: _textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = ['All', 'Draft', 'Pending', 'Approved', 'Shipped'];

    return Row(
      children: filters.map((f) {
        final bool isSelected = _selectedFilter == f;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? _primaryGreen : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSelected ? Colors.white : _textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActiveOrdersList() {
    final List<Map<String, dynamic>> list = _poData['orders'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Orders',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),

        ...list.map((po) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          po['id'] as String,
                          style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: po['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            po['status'] as String,
                            style: TextStyle(
                              color: po['statusColor'] as Color,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      po['amount'] as String,
                      style: const TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Text(
                  po['supplier'] as String,
                  style: const TextStyle(color: _textMuted, fontSize: 12.5),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: _textMuted, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Expected: ${po['expectedDate']}',
                      style: const TextStyle(color: _textMuted, fontSize: 11.5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Multi-Segment Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: po['progress'] as double,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    color: _primaryGreen,
                  ),
                ),
                const SizedBox(height: 14),

                // Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textDark,
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          po['action1Label'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleReceiveGoods(po['id'] as String),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: po['action2Bg'] as Color,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          po['action2Label'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
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
              _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory'),
              _buildNavItem(3, Icons.storefront_rounded, 'Suppliers'),
              _buildNavItem(4, Icons.shopping_cart_rounded, 'Purchase', isSelected: true),
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
