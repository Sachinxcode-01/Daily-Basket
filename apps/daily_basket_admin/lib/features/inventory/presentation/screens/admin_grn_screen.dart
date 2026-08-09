import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Goods Receipt Note (GRN)
/// Project ID: 6885817708675501691
/// Screen ID: 2976f395e6a74cda8bb155e7eb488a81
class AdminGrnScreen extends StatefulWidget {
  const AdminGrnScreen({super.key});

  @override
  State<AdminGrnScreen> createState() => _AdminGrnScreenState();
}

class _AdminGrnScreenState extends State<AdminGrnScreen> {
  bool _isLoading = false;
  String _selectedFilter = 'Pending';
  final TextEditingController _searchController = TextEditingController();

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _orangeText = Color(0xFFC2410C);
  static const Color _mintText = Color(0xFF15803D);

  // State Data
  final Map<String, dynamic> _grnData = {
    'pendingCount': 12,
    'receivedToday': 45,
    'rejectedCount': 3,
    'grnRecords': [
      {
        'id': 'GRN-9921',
        'supplier': 'Fresh Farms Ltd.',
        'poNumber': 'PO-2023-0891',
        'invNumber': 'INV-9921',
        'status': 'Partial',
        'statusBg': const Color(0xFFFFEDD5),
        'statusColor': const Color(0xFFC2410C),
        'receivedItems': 45,
        'totalItems': 50,
        'progress': 0.90,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchGrnDataApi();
  }

  Future<void> _fetchGrnDataApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/purchase-management/orders'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _grnData['receivedToday'] = data.length * 15;
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleScanBarcode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📷 Barcode Scanner activated for GRN Inspection'),
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
                    // Title Header
                    const Text(
                      'Goods Receipt (GRN)',
                      style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    const SizedBox(height: 14),

                    // Search Bar
                    _buildSearchInput(),
                    const SizedBox(height: 14),

                    // Metrics Strip
                    _buildMetricsStrip(),
                    const SizedBox(height: 14),

                    // Filter Chips Row
                    _buildFilterChipsRow(),
                    const SizedBox(height: 16),

                    // GRN Cards List
                    _buildGrnCardsList(),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'AU',
              style: TextStyle(color: _textDark, fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ),
      ],
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
          hintText: 'Search GRN #, PO #, or Supplier...',
          hintStyle: TextStyle(color: _textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: _textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildMetricsStrip() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Card 1: Pending
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
                    Icon(Icons.assignment_outlined, color: _orangeText, size: 16),
                    SizedBox(width: 4),
                    Text('Pending', style: TextStyle(color: _orangeText, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  '${_grnData['pendingCount']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text('Require action', style: TextStyle(color: _textMuted, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 2: Received
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
                    Icon(Icons.check_circle_outline_rounded, color: _mintText, size: 16),
                    SizedBox(width: 4),
                    Text('Received', style: TextStyle(color: _mintText, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  '${_grnData['receivedToday']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text('Today', style: TextStyle(color: _textMuted, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 3: Rejected
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
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 16),
                    SizedBox(width: 4),
                    Text('Rejected', style: TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  '${_grnData['rejectedCount']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text('Items damaged', style: TextStyle(color: _textMuted, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = ['Pending', 'Partial', 'Completed', 'Damaged'];

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

  Widget _buildGrnCardsList() {
    final List<Map<String, dynamic>> records = _grnData['grnRecords'] as List<Map<String, dynamic>>;

    return Column(
      children: records.map((grn) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    grn['supplier'] as String,
                    style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: grn['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      grn['status'] as String,
                      style: TextStyle(color: grn['statusColor'] as Color, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Text(
                '${grn['poNumber']} • ${grn['invNumber']}',
                style: const TextStyle(color: _textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Received', style: TextStyle(color: _textMuted, fontSize: 11.5)),
                  Text(
                    '${grn['receivedItems']} / ${grn['totalItems']} items',
                    style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11.5),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: grn['progress'] as double,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFF1F5F9),
                  color: _primaryGreen,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.remove_red_eye_outlined, color: _textDark, size: 16),
                      label: const Text('Review', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 12.5)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleScanBarcode,
                      icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 16),
                      label: const Text('Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
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
