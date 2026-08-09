import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_rider_profile_screen.dart';

/// Google Stitch Source of Truth Screen: Delivery Management Dashboard
/// Project ID: 6885817708675501691
/// Screen ID: e3716d1d69d5417aaa1ddfbb89b6a272
class AdminDeliveryDashboardScreen extends StatefulWidget {
  const AdminDeliveryDashboardScreen({super.key});

  @override
  State<AdminDeliveryDashboardScreen> createState() => _AdminDeliveryDashboardScreenState();
}

class _AdminDeliveryDashboardScreenState extends State<AdminDeliveryDashboardScreen> {
  bool _isLoading = false;
  bool _isAutoDispatchApplied = false;

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintText = Color(0xFF15803D);
  static const Color _periwinkleBg = Color(0xFFDCE6FE);

  // Delivery Management State Data
  final Map<String, dynamic> _dashboardData = {
    'activeDeliveries': 42,
    'availableRiders': 18,
    'availableRidersDelta': '+2',
    'waitingAssignment': 12,
    'activeZones': 3,
    'autoDispatchRecommendation': {
      'title': 'Route Optimization',
      'subtitle': 'Batching 4 orders for Rider John D. to save 12 mins.',
    },
    'currentPriorityOrder': {
      'id': 'ORD-8923',
      'currentStepIndex': 2, // 0: Packed, 1: Assigned, 2: On Way, 3: Delivered
    },
    'activeFleet': [
      {
        'id': 'RIDER-101',
        'name': 'Michael T.',
        'vehicle': 'E-Scooter',
        'vehicleIcon': Icons.electric_scooter_outlined,
        'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        'status': 'Online',
        'statusColor': const Color(0xFF16A34A),
        'rating': 4.9,
        'doneToday': 14,
        'earnedToday': '₹845.00',
        'isAvailable': true,
      },
      {
        'id': 'RIDER-402',
        'name': 'Sarah K.',
        'vehicle': 'Busy (On Route)',
        'vehicleIcon': Icons.local_shipping_outlined,
        'avatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
        'status': 'Busy',
        'statusColor': const Color(0xFFC2410C),
        'rating': 4.8,
        'doneToday': 11,
        'earnedToday': '₹620.00',
        'isAvailable': false,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchFleetApiData();
  }

  Future<void> _fetchFleetApiData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/fleet/vehicles'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _dashboardData['availableRiders'] = data.length;
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyAutoDispatch() {
    setState(() => _isAutoDispatchApplied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Auto-Dispatch AI applied! 4 orders batched for Rider John D.'),
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
                    // Top Metrics Scroll Strip
                    _buildTopMetricsStrip(),
                    const SizedBox(height: 16),

                    // Live Fleet Tracking Map Card
                    _buildLiveFleetTrackingMapCard(),
                    const SizedBox(height: 16),

                    // Auto-Dispatch AI Card
                    _buildAutoDispatchAiCard(),
                    const SizedBox(height: 16),

                    // Current Priority Order Card
                    _buildCurrentPriorityOrderCard(),
                    const SizedBox(height: 16),

                    // Active Fleet Section
                    _buildActiveFleetSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
        'Delivery Management',
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

  Widget _buildTopMetricsStrip() {
    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Card 1: Active Deliveries
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.local_shipping_outlined, color: Color(0xFF0284C7), size: 20),
                    Icon(Icons.circle, color: Color(0xFF0284C7), size: 8),
                  ],
                ),
                Text(
                  '${_dashboardData['activeDeliveries']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text(
                  'Active Deliveries',
                  style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 2: Available Riders
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.electric_scooter_outlined, color: _primaryGreen, size: 20),
                    Text(
                      '${_dashboardData['availableRidersDelta']}',
                      style: const TextStyle(color: _mintText, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${_dashboardData['availableRiders']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text(
                  'Available Riders',
                  style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Card 3: Waiting Assignment
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
                const Icon(Icons.assignment_late_outlined, color: Color(0xFFEA580C), size: 20),
                Text(
                  '${_dashboardData['waitingAssignment']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const Text(
                  'Waiting Assignment',
                  style: TextStyle(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveFleetTrackingMapCard() {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay Map Pins Representation
          const Positioned(
            top: 30,
            left: 50,
            child: Icon(Icons.location_on_rounded, color: _primaryGreen, size: 26),
          ),
          const Positioned(
            top: 70,
            right: 80,
            child: Icon(Icons.location_on_rounded, color: _primaryGreen, size: 26),
          ),
          const Positioned(
            bottom: 80,
            left: 140,
            child: Icon(Icons.electric_scooter_rounded, color: _primaryGreen, size: 28),
          ),

          // Bottom Floating Pill Box
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: _primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.explore_outlined, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Live Fleet Tracking',
                          style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '${_dashboardData['activeZones']} zones active',
                          style: const TextStyle(color: _textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textDark,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    ),
                    child: const Text('Expand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoDispatchAiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: _primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Auto-Dispatch AI',
                style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 15),
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
            child: Row(
              children: [
                const Icon(Icons.alt_route_rounded, color: Color(0xFFC2410C), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Route Optimization',
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _dashboardData['autoDispatchRecommendation']['subtitle'] as String,
                        style: const TextStyle(color: _textMuted, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _isAutoDispatchApplied ? null : _applyAutoDispatch,
                  child: Text(
                    _isAutoDispatchApplied ? 'Applied' : 'Apply',
                    style: TextStyle(
                      color: _isAutoDispatchApplied ? _textMuted : _primaryGreen,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPriorityOrderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Priority Order',
            style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // 4 Steps Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusStepItem(
                icon: Icons.inventory_2_rounded,
                label: 'Packed',
                isCompleted: true,
                isActive: false,
              ),
              _buildStatusStepItem(
                icon: Icons.person_add_alt_1_rounded,
                label: 'Assigned',
                isCompleted: true,
                isActive: false,
              ),
              _buildStatusStepItem(
                icon: Icons.two_wheeler_rounded,
                label: 'On Way',
                isCompleted: true,
                isActive: true,
              ),
              _buildStatusStepItem(
                icon: Icons.home_rounded,
                label: 'Delivered',
                isCompleted: false,
                isActive: false,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Actions Row: Chat & View Route
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: _textDark, size: 18),
                  label: const Text('Chat', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map_outlined, color: Colors.white, size: 18),
                  label: const Text('View Route', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStepItem({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    Color bg = const Color(0xFFF1F5F9);
    Color iconColor = const Color(0xFF94A3B8);
    Color textColor = _textMuted;

    if (isCompleted || isActive) {
      bg = _primaryGreen;
      iconColor = Colors.white;
      if (isActive) {
        textColor = _primaryGreen;
      }
    }

    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFleetSection() {
    final List<Map<String, dynamic>> riders = _dashboardData['activeFleet'] as List<Map<String, dynamic>>;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Fleet',
              style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'View All',
                style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...riders.map((r) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminRiderProfileScreen(riderId: r['id'] as String),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              r['avatar'] as String,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: r['statusColor'] as Color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r['name'] as String,
                              style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(r['vehicleIcon'] as IconData, color: _textMuted, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  r['vehicle'] as String,
                                  style: TextStyle(
                                    color: (r['isAvailable'] as bool) ? _textMuted : const Color(0xFFC2410C),
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                          const SizedBox(width: 2),
                          Text(
                            '${r['rating']}',
                            style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (r['isAvailable'] as bool) ...[
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Done', style: TextStyle(color: _textMuted, fontSize: 10)),
                                Text('${r['doneToday']}', style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Earned', style: TextStyle(color: _textMuted, fontSize: 10)),
                                Text(r['earnedToday'] as String, style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit_calendar_rounded, color: _mintText, size: 14),
                              SizedBox(width: 4),
                              Text('Assign', style: TextStyle(color: _mintText, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
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
              _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard', isSelected: true),
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

  Widget _buildNavItem(int index, IconData icon, String label, {bool isSelected = false}) {
    return InkWell(
      onTap: () {},
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
