import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_purchase_orders_screen.dart';

/// Google Stitch Source of Truth Screen: Supplier Management
/// Project ID: 6885817708675501691
/// Screen ID: cbebf2e047194f8989458a08bc60da09
class AdminSuppliersScreen extends StatefulWidget {
  const AdminSuppliersScreen({super.key});

  @override
  State<AdminSuppliersScreen> createState() => _AdminSuppliersScreenState();
}

class _AdminSuppliersScreenState extends State<AdminSuppliersScreen> {
  bool _isLoading = false;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintText = Color(0xFF15803D);
  static const Color _periwinkleBg = Color(0xFFDCE6FE);
  static const Color _orangeText = Color(0xFFC2410C);

  // State Data
  final Map<String, dynamic> _suppliersData = {
    'totalSuppliers': 124,
    'activeCount': 112,
    'pendingCount': 18,
    'suppliers': [
      {
        'id': 'SUP-001',
        'name': 'Organic Roots Co.',
        'rating': '4.9',
        'status': 'Preferred',
        'statusBg': const Color(0xFFDCFCE7),
        'statusColor': const Color(0xFF15803D),
        'accentColor': const Color(0xFF006837),
        'lastDelivery': '2h ago',
        'pendingPOs': 3,
        'hasDelay': false,
        'logoUrl': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=100',
      },
      {
        'id': 'SUP-002',
        'name': 'Heritage Dairy',
        'rating': '4.7',
        'status': 'Active',
        'statusBg': const Color(0xFFF1F5F9),
        'statusColor': const Color(0xFF475569),
        'accentColor': const Color(0xFF006837),
        'lastDelivery': 'Yesterday',
        'pendingPOs': 0,
        'hasDelay': false,
        'logoUrl': 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?w=100',
      },
      {
        'id': 'SUP-003',
        'name': 'Sunrise Bakery',
        'rating': '4.2',
        'status': 'Review Pending',
        'statusBg': const Color(0xFFFFEDD5),
        'statusColor': const Color(0xFFC2410C),
        'accentColor': const Color(0xFFC2410C),
        'lastDelivery': '3 days ago',
        'pendingPOs': 1,
        'hasDelay': true,
        'delayedPoNumber': '#1042',
        'logoUrl': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchSuppliersApi();
  }

  Future<void> _fetchSuppliersApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/purchase-management/suppliers'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _suppliersData['totalSuppliers'] = data.length;
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                    // Top Metrics Horizontal Cards Strip
                    _buildTopMetricsStrip(),
                    const SizedBox(height: 16),

                    // Search Input Field
                    _buildSearchInput(),
                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChipsRow(),
                    const SizedBox(height: 16),

                    // Supplier Directory List
                    _buildSupplierDirectory(),
                    const SizedBox(height: 16),

                    // Smart Insights Card
                    _buildSmartInsightsCard(),
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
        icon: const Icon(Icons.menu_rounded, color: _textDark),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const Text(
        'Suppliers',
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
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: _textDark),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=100',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopMetricsStrip() {
    return SizedBox(
      height: 94,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Card 1: Total Suppliers
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
                const Text('Total Suppliers', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                Text(
                  '${_suppliersData['totalSuppliers']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 26),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 2: Active
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
                const Text('Active', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                Text(
                  '${_suppliersData['activeCount']}',
                  style: const TextStyle(color: _mintText, fontWeight: FontWeight.w900, fontSize: 26),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 3: Pending
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
                const Text('Pending', style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                Text(
                  '${_suppliersData['pendingCount']}',
                  style: const TextStyle(color: _orangeText, fontWeight: FontWeight.w900, fontSize: 26),
                ),
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
          hintText: 'Search suppliers, GST...',
          hintStyle: TextStyle(color: _textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: _textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = ['All', 'Preferred', 'Active', 'Pending'];

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
                color: isSelected ? _periwinkleBg : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? _primaryGreen : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSelected ? _textDark : _textMuted,
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

  Widget _buildSupplierDirectory() {
    final List<Map<String, dynamic>> list = _suppliersData['suppliers'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supplier Directory',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),

        ...list.map((sup) {
          final bool hasDelay = sup['hasDelay'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left Accent Vertical Bar
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: sup['accentColor'] as Color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                      ),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  sup['logoUrl'] as String,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sup['name'] as String,
                                      style: const TextStyle(
                                        color: _textDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
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
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star_rounded, color: Color(0xFF64748B), size: 12),
                                              const SizedBox(width: 2),
                                              Text(
                                                sup['rating'] as String,
                                                style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: sup['statusBg'] as Color,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            sup['status'] as String,
                                            style: TextStyle(
                                              color: sup['statusColor'] as Color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
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
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, color: _textMuted, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Last Delivery: ${sup['lastDelivery']}',
                                style: const TextStyle(color: _textMuted, fontSize: 11.5),
                              ),
                              const Spacer(),
                              if (hasDelay) ...[
                                const Icon(Icons.warning_amber_rounded, color: _orangeText, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Delayed PO: ${sup['delayedPoNumber']}',
                                  style: const TextStyle(color: _orangeText, fontWeight: FontWeight.bold, fontSize: 11.5),
                                ),
                              ] else ...[
                                const Icon(Icons.assignment_outlined, color: _textMuted, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Pending POs: ${sup['pendingPOs']}',
                                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11.5),
                                ),
                              ],
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

  Widget _buildSmartInsightsCard() {
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
              Icon(Icons.auto_awesome_rounded, color: _primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Smart Insights',
                style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOP PERFORMING CATEGORY',
                  style: TextStyle(color: _textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fresh Produce',
                      style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Icon(Icons.show_chart_rounded, color: _primaryGreen.withOpacity(0.6), size: 24),
                  ],
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.trending_down_rounded, color: _mintText, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '2.4% cost reduction',
                      style: TextStyle(color: _mintText, fontWeight: FontWeight.bold, fontSize: 11.5),
                    ),
                  ],
                ),
                const Divider(height: 20, color: Color(0xFFF1F5F9)),
                const Text(
                  'Consider consolidating dairy orders with Heritage Dairy to unlock volume discounts.',
                  style: TextStyle(color: Color(0xFF334155), fontSize: 11.5, height: 1.3),
                ),
              ],
            ),
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
              _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory'),
              _buildNavItem(3, Icons.storefront_rounded, 'Suppliers', isSelected: true),
              _buildNavItem(4, Icons.bar_chart_rounded, 'Analytics'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isSelected = false}) {
    return InkWell(
      onTap: () {
        if (label == 'Orders') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminPurchaseOrdersScreen()),
          );
        }
      },
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
