import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Coupon Management Dashboard
/// Project ID: 6885817708675501691
/// Screen ID: ee9fc342aa164f7daa279a40d7a95b32
class AdminCouponDashboardScreen extends StatefulWidget {
  const AdminCouponDashboardScreen({super.key});

  @override
  State<AdminCouponDashboardScreen> createState() => _AdminCouponDashboardScreenState();
}

class _AdminCouponDashboardScreenState extends State<AdminCouponDashboardScreen> {
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

  // State Data
  final Map<String, dynamic> _couponsData = {
    'totalCoupons': 48,
    'activeCoupons': 32,
    'redemptionsToday': '1,240',
    'totalSavings': '₹1.85L',
    'coupons': [
      {
        'id': 'c-1',
        'code': 'WELCOME50',
        'title': '50% OFF up to ₹100',
        'minOrder': 'Min. order ₹199',
        'status': 'ACTIVE',
        'statusBg': const Color(0xFFDCFCE7),
        'statusColor': const Color(0xFF15803D),
        'redemptions': 1420,
        'expires': 'Expires 31 Dec',
        'discountTag': '50% OFF',
      },
      {
        'id': 'c-2',
        'code': 'FRESH20',
        'title': '₹20 Flat OFF on Fresh Produce',
        'minOrder': 'Min. order ₹149',
        'status': 'ACTIVE',
        'statusBg': const Color(0xFFDCFCE7),
        'statusColor': const Color(0xFF15803D),
        'redemptions': 850,
        'expires': 'Expires 15 Nov',
        'discountTag': '₹20 OFF',
      },
      {
        'id': 'c-3',
        'code': 'FESTIVE100',
        'title': '₹100 Mega Savings',
        'minOrder': 'Min. order ₹500',
        'status': 'SCHEDULED',
        'statusBg': const Color(0xFFFFEDD5),
        'statusColor': const Color(0xFFC2410C),
        'redemptions': 0,
        'expires': 'Starts 1 Nov',
        'discountTag': '₹100 OFF',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchCouponsApi();
  }

  Future<void> _fetchCouponsApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/v1/coupons'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _couponsData['totalCoupons'] = data.length;
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
                    const Text(
                      'Coupon Management',
                      style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    const SizedBox(height: 14),

                    // Metrics Strip
                    _buildMetricsStrip(),
                    const SizedBox(height: 14),

                    // Search Input
                    _buildSearchInput(),
                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChipsRow(),
                    const SizedBox(height: 16),

                    // Active Coupons List
                    _buildCouponsList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/admin/marketing/coupons/create'),
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
        'Marketing & Offers',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.analytics_outlined, color: _textDark),
          onPressed: () => Navigator.pushNamed(context, '/admin/marketing/analytics'),
        ),
      ],
    );
  }

  Widget _buildMetricsStrip() {
    return SizedBox(
      height: 94,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMetricCard('Total Coupons', '${_couponsData['totalCoupons']}', Icons.confirmation_number_outlined, _primaryGreen),
          const SizedBox(width: 12),
          _buildMetricCard('Active', '${_couponsData['activeCoupons']}', Icons.check_circle_outline_rounded, _mintText),
          const SizedBox(width: 12),
          _buildMetricCard('Redemptions Today', _couponsData['redemptionsToday'] as String, Icons.trending_up_rounded, const Color(0xFF0284C7)),
          const SizedBox(width: 12),
          _buildMetricCard('Total Savings', _couponsData['totalSavings'] as String, Icons.savings_outlined, const Color(0xFFC2410C)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 138,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: _textMuted, fontSize: 10.5, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(
            value,
            style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 22),
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
          hintText: 'Search code, campaign, offer...',
          hintStyle: TextStyle(color: _textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: _textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    final filters = ['All', 'Active', 'Scheduled', 'Expired', 'Draft'];
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
                border: Border.all(color: isSelected ? _primaryGreen : const Color(0xFFE2E8F0)),
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

  Widget _buildCouponsList() {
    final List<Map<String, dynamic>> list = _couponsData['coupons'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Coupons',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),

        ...list.map((cpn) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/admin/marketing/coupons/details'),
            child: Container(
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          cpn['code'] as String,
                          style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 15, fontFamily: 'monospace'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: cpn['statusBg'] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cpn['status'] as String,
                          style: TextStyle(color: cpn['statusColor'] as Color, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    cpn['title'] as String,
                    style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cpn['minOrder'] as String,
                    style: const TextStyle(color: _textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🔄 ${cpn['redemptions']} redemptions',
                        style: const TextStyle(color: _textDark, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      Text(
                        cpn['expires'] as String,
                        style: const TextStyle(color: _textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
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
              _buildNavItem(1, Icons.shopping_basket_outlined, 'Orders'),
              _buildNavItem(2, Icons.local_offer_rounded, 'Offers', isSelected: true),
              _buildNavItem(3, Icons.storefront_rounded, 'Suppliers'),
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
