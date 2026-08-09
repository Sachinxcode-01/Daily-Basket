import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Google Stitch Source of Truth Screen: Orders Management Dashboard
/// Project ID: 6885817708675501691
/// Screen ID: 1a0e4c0c22d9478697693d8a728bfc22
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _selectedFilter = 'All Orders';
  final TextEditingController _searchController = TextEditingController();
  int _activeNavIndex = 1; // 1 = Orders tab

  // Brand Colors matching Google Stitch Design Spec
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF4F6F4);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _priorityRedBg = Color(0xFFFEE2E2);
  static const Color _priorityRedText = Color(0xFFB91C1C);
  static const Color _pendingOrangeBg = Color(0xFFFFF7ED);
  static const Color _pendingOrangeBorder = Color(0xFFFFEDD5);
  static const Color _pendingOrangeText = Color(0xFFC2410C);
  static const Color _blueCallBg = Color(0xFFE0F2FE);
  static const Color _blueCallIcon = Color(0xFF0284C7);

  final List<Map<String, dynamic>> _ordersData = [
    {
      'id': '#DB-9842',
      'customer': 'Rahul Sharma',
      'address': '12, Green Park Avenue, Block C, HSR',
      'phone': '+91 98765 43210',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      'amount': 1240,
      'isPriority': true,
      'statusStep': 1, // 0: New, 1: Accept, 2: Pack, 3: Assign, 4: Done
      'time': '10:24 AM (5m ago)',
      'paymentMethod': 'Paid via UPI',
      'items': ['Organic Avocados x4', 'Aashirvaad Atta 5kg', 'Amul Butter 500g'],
    },
    {
      'id': '#DB-9840',
      'customer': 'Priya Desai',
      'address': 'Sector 4, HSR Layout, Bengaluru',
      'phone': '+91 98765 12345',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'amount': 450,
      'isPriority': false,
      'statusStep': 2,
      'time': '09:45 AM (44m ago)',
      'paymentMethod': 'Paid via Card',
      'items': ['Fresh Paneer 200g', 'Free-range Eggs 6pk'],
    },
    {
      'id': '#DB-9838',
      'customer': 'Ananya R.',
      'address': '102, Sun City Apts, Sarjapur Road',
      'phone': '+91 91234 56789',
      'avatar': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
      'amount': 890,
      'isPriority': true,
      'statusStep': 0,
      'time': '10:28 AM (1m ago)',
      'paymentMethod': 'Paid via Wallet',
      'items': ['Greek Yogurt 400g', 'Cold Pressed Juice 1L', 'Blueberries 125g'],
    },
    {
      'id': '#DB-9835',
      'customer': 'Vikram Malhotra',
      'address': '45, Koramangala 5th Block, Bengaluru',
      'phone': '+91 99887 76655',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'amount': 1560,
      'isPriority': false,
      'statusStep': 3,
      'time': '09:12 AM (1h ago)',
      'paymentMethod': 'Paid via UPI',
      'items': ['Basmati Rice 5kg', 'Sunflower Oil 2L', 'Toor Dal 1kg'],
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    return _ordersData.where((order) {
      final matchesFilter = switch (_selectedFilter) {
        'New (12)' => order['statusStep'] == 0,
        'Pending' => order['statusStep'] == 1,
        'Packed' => order['statusStep'] == 2,
        'Dispatched' => order['statusStep'] == 3,
        _ => true,
      };

      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) return matchesFilter;

      final matchesQuery = order['id'].toString().toLowerCase().contains(query) ||
          order['customer'].toString().toLowerCase().contains(query) ||
          order['address'].toString().toLowerCase().contains(query);

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
            // Search Input Field
            _buildSearchBar(),
            const SizedBox(height: 12),

            // Filter Chips Bar
            _buildFilterChips(),
            const SizedBox(height: 14),

            // Summary Stats Cards Strip
            _buildSummaryStatsRow(),
            const SizedBox(height: 14),

            // Order Cards List
            Expanded(
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = _filteredOrders[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 20.0,
                              child: FadeInAnimation(
                                child: _buildOrderCard(order),
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
        onPressed: () => _showNewOrderDialog(context),
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
      title: Row(
        children: [
          const Text(
            'Orders',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 10),
          // "● Open" Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF86EFAC), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Open',
                  style: TextStyle(
                    color: Color(0xFF15803D),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: _primaryGreen),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2EF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  hintText: 'Search Order ID, Customer...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
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
    final filters = ['All Orders', 'New (12)', 'Pending', 'Packed', 'Dispatched'];
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildSummaryStatsRow() {
    return SizedBox(
      height: 100,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          // Stat Card 1: Today's Orders
          _buildStatCard(
            title: "TODAY'S ORDERS",
            value: '142',
            bgColor: const Color(0xFFF4FAF6),
            borderColor: const Color(0xFFD0E5D7),
            titleColor: const Color(0xFF475569),
            valueColor: _primaryGreen,
            icon: Icons.trending_up_rounded,
            iconColor: _primaryGreen,
          ),
          const SizedBox(width: 12),

          // Stat Card 2: Pending
          _buildStatCard(
            title: 'PENDING',
            value: '24',
            bgColor: _pendingOrangeBg,
            borderColor: _pendingOrangeBorder,
            titleColor: _pendingOrangeText,
            valueColor: _pendingOrangeText,
            icon: Icons.shopping_bag_outlined,
            iconColor: _pendingOrangeText,
          ),
          const SizedBox(width: 12),

          // Stat Card 3: Packed / Processing
          _buildStatCard(
            title: 'PACKED',
            value: '18',
            bgColor: const Color(0xFFF0F9FF),
            borderColor: const Color(0xFFBAE6FD),
            titleColor: const Color(0xFF0369A1),
            valueColor: const Color(0xFF0284C7),
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF0284C7),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color bgColor,
    required Color borderColor,
    required Color titleColor,
    required Color valueColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
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
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final int currentStep = order['statusStep'] as int;
    final bool isPriority = order['isPriority'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          // Card Header: #Order ID, Badge, Amount
          Row(
            children: [
              Text(
                order['id'] as String,
                style: const TextStyle(
                  color: _textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              if (isPriority)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _priorityRedBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department_rounded, color: _priorityRedText, size: 14),
                      SizedBox(width: 3),
                      Text(
                        'Priority',
                        style: TextStyle(
                          color: _priorityRedText,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Text(
                '₹${order['amount']}',
                style: const TextStyle(
                  color: _primaryGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Customer Box Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    order['avatar'] as String,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: _primaryGreen.withOpacity(0.1),
                      child: const Icon(Icons.person_rounded, color: _primaryGreen),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['customer'] as String,
                        style: const TextStyle(
                          color: _textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order['address'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Phone Call Circle Button
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: _blueCallBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_rounded, color: _blueCallIcon, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5-Stage Stepper Timeline: New -> Accept -> Pack -> Assign -> Done
          _buildStepperTimeline(currentStep),
          const SizedBox(height: 14),

          // Footer meta info: Time & Payment Method
          Row(
            children: [
              const Icon(Icons.access_time_rounded, color: _textMuted, size: 14),
              const SizedBox(width: 4),
              Text(
                order['time'] as String,
                style: const TextStyle(color: _textMuted, fontSize: 12),
              ),
              const Spacer(),
              const Icon(Icons.check_circle_rounded, color: _primaryGreen, size: 14),
              const SizedBox(width: 4),
              Text(
                order['paymentMethod'] as String,
                style: const TextStyle(
                  color: _primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Row: Primary Button + Print Icon
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (order['statusStep'] < 4) {
                          order['statusStep'] = (order['statusStep'] as int) + 1;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _getButtonText(currentStep),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.print_outlined, color: _textDark, size: 20),
                  onPressed: () => _showPrintReceiptSheet(context, order),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperTimeline(int activeStep) {
    final steps = ['New', 'Accept', 'Pack', 'Assign', 'Done'];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: List.generate(steps.length, (index) {
                final isPassed = index <= activeStep;
                final isCurrent = index == activeStep;

                return Expanded(
                  child: Row(
                    children: [
                      // Node circle
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPassed ? _primaryGreen : const Color(0xFFE2E8F0),
                          border: isCurrent
                              ? Border.all(color: const Color(0xFF86EFAC), width: 3)
                              : null,
                        ),
                      ),

                      // Line connecting to next node
                      if (index < steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 3,
                            color: (index < activeStep)
                                ? _primaryGreen
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                final isPassed = index <= activeStep;
                return SizedBox(
                  width: (constraints.maxWidth / steps.length),
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isPassed ? _primaryGreen : const Color(0xFF94A3B8),
                      fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
                      fontSize: 10.5,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  String _getButtonText(int step) {
    switch (step) {
      case 0:
        return 'Accept Order';
      case 1:
        return 'Mark as Packed';
      case 2:
        return 'Assign Delivery';
      case 3:
        return 'Mark as Delivered';
      case 4:
        return 'Completed';
      default:
        return 'Update Status';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_rounded, size: 56, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          const Text(
            'No orders found',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try selecting another filter or clear search',
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
              _buildNavItem(0, Icons.grid_view_rounded, 'Home'),
              _buildNavItem(1, Icons.shopping_basket_rounded, 'Orders'),
              _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory'),
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

  void _showPrintReceiptSheet(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.print_rounded, size: 48, color: _primaryGreen),
            const SizedBox(height: 12),
            Text(
              'Print Order Invoice ${order['id']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Sending receipt payload to thermal Bluetooth printer...',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Manual Order Entry', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Create a quick manual dark store phone order entry.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ordersData.insert(0, {
                  'id': '#DB-${9843 + _ordersData.length}',
                  'customer': 'New Customer',
                  'address': 'Koramangala 4th Block, Bengaluru',
                  'phone': '+91 99999 88888',
                  'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                  'amount': 350,
                  'isPriority': true,
                  'statusStep': 0,
                  'time': 'Just now',
                  'paymentMethod': 'Paid via Cash',
                  'items': ['Organic Tomatoes 1kg'],
                });
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
            child: const Text('Create Order', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

