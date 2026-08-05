import 'package:flutter/material.dart';

/// Stitch Screen: Order Management - Live Feed
/// ID: 627ff613f73045749bb33296881189d0
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock live order data
  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#DB-892142',
      'customer': 'Ananya Sharma',
      'phone': '+91 98765 43210',
      'items': ['Organic Tomatoes 500g', 'Amul Milk 1L', 'Aashirvaad Atta 5kg'],
      'amount': 285.0,
      'status': 'PLACED',
      'address': '204, Green Leaf Apts, Koramangala 4th Block',
      'time': '2m ago',
      'eta': '12 mins',
      'rider': null,
    },
    {
      'id': '#DB-892141',
      'customer': 'Rohan Gupta',
      'phone': '+91 87654 32109',
      'items': ['Aashirvaad Atta 5kg', 'Fresh Paneer 200g'],
      'amount': 405.0,
      'status': 'PACKING',
      'address': '45-B, Promenade Road, Indiranagar',
      'time': '5m ago',
      'eta': '18 mins',
      'rider': null,
    },
    {
      'id': '#DB-892140',
      'customer': 'Priya Nair',
      'phone': '+91 76543 21098',
      'items': ['Cucumber Basket', 'Free-range Eggs 6pk'],
      'amount': 145.0,
      'status': 'OUT_FOR_DELIVERY',
      'address': '12, 1st Cross, HSR Layout Sector 1',
      'time': '11m ago',
      'eta': '4 mins',
      'rider': 'Ravi Kumar',
    },
    {
      'id': '#DB-892139',
      'customer': 'Karan Mehta',
      'phone': '+91 65432 10987',
      'items': ['Cold-pressed Juice 1L', 'Greek Yogurt 400g', 'Mixed Greens'],
      'amount': 610.0,
      'status': 'DELIVERED',
      'address': '8, Lavelle Road, Cubbon Park Area',
      'time': '28m ago',
      'eta': 'Done',
      'rider': 'Suresh Yadav',
    },
    {
      'id': '#DB-892138',
      'customer': 'Sneha Patel',
      'phone': '+91 54321 09876',
      'items': ['Hass Avocados x4', 'Almond Milk 1L'],
      'amount': 240.0,
      'status': 'DELIVERED',
      'address': '22, CMH Road, Indiranagar',
      'time': '45m ago',
      'eta': 'Done',
      'rider': 'Deepak Singh',
    },
    {
      'id': '#DB-892137',
      'customer': 'Vikram Rao',
      'phone': '+91 43210 98765',
      'items': ['Basmati Rice 5kg', 'Toor Dal 1kg', 'Sunflower Oil 1L'],
      'amount': 520.0,
      'status': 'CANCELLED',
      'address': '15, 5th Main, Jayanagar',
      'time': '1h ago',
      'eta': '-',
      'rider': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getOrdersByStatus(String status) {
    if (status == 'ALL') return _allOrders;
    return _allOrders.where((o) => o['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Order Management — Live Feed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF2DD4BF)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF2DD4BF)),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: const Color(0xFF2DD4BF),
            indicatorWeight: 3,
            labelColor: const Color(0xFF2DD4BF),
            unselectedLabelColor: const Color(0xFF64748B),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            tabs: [
              Tab(text: 'All (${_allOrders.length})'),
              Tab(text: 'New (${_getOrdersByStatus('PLACED').length})'),
              Tab(text: 'Packing (${_getOrdersByStatus('PACKING').length})'),
              Tab(text: 'Out (${_getOrdersByStatus('OUT_FOR_DELIVERY').length})'),
              Tab(text: 'Done (${_getOrdersByStatus('DELIVERED').length})'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Live counter strip
          _buildLiveStrip(),
          // Tab body
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(_getOrdersByStatus('ALL')),
                _buildOrderList(_getOrdersByStatus('PLACED')),
                _buildOrderList(_getOrdersByStatus('PACKING')),
                _buildOrderList(_getOrdersByStatus('OUT_FOR_DELIVERY')),
                _buildOrderList(_getOrdersByStatus('DELIVERED')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStrip() {
    return Container(
      color: const Color(0xFF0F766E).withOpacity(0.15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const _PulseDot(),
          const SizedBox(width: 8),
          const Text('Live Feed', style: TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 12)),
          const Spacer(),
          _buildStrip('₹38,450', 'Revenue'),
          const SizedBox(width: 16),
          _buildStrip('8.4 min', 'Avg. Delivery'),
          const SizedBox(width: 16),
          _buildStrip('98.6%', 'Success Rate'),
        ],
      ),
    );
  }

  Widget _buildStrip(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9)),
      ],
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_rounded, color: Color(0xFF334155), size: 56),
            SizedBox(height: 12),
            Text('No orders in this category', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final statusConfig = _getStatusConfig(order['status'] as String);

    return GestureDetector(
      onTap: () => _showOrderDetail(context, order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: (statusConfig['color'] as Color).withOpacity(0.25)),
        ),
        child: Column(
          children: [
            // Order header
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (statusConfig['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(statusConfig['icon'] as IconData, color: statusConfig['color'] as Color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['id'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '${order['customer']} • ${order['time']}',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${(order['amount'] as double).toStringAsFixed(0)}',
                        style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (statusConfig['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusConfig['label'] as String,
                          style: TextStyle(
                            color: statusConfig['color'] as Color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Items
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_basket_outlined, color: Color(0xFF64748B), size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      (order['items'] as List).join(', '),
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (order['rider'] != null) ...[
                    const Icon(Icons.two_wheeler_rounded, color: Color(0xFF2DD4BF), size: 14),
                    const SizedBox(width: 4),
                    Text(order['rider'] as String, style: const TextStyle(color: Color(0xFF2DD4BF), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                  if (order['eta'] != 'Done' && order['eta'] != '-') ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.timer_outlined, color: Color(0xFFFBBF24), size: 14),
                    const SizedBox(width: 2),
                    Text('ETA: ${order['eta']}', style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 11)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'PLACED':
        return {'color': const Color(0xFF8B5CF6), 'icon': Icons.add_shopping_cart_rounded, 'label': 'NEW ORDER'};
      case 'PACKING':
        return {'color': const Color(0xFFF59E0B), 'icon': Icons.inventory_rounded, 'label': 'PACKING'};
      case 'OUT_FOR_DELIVERY':
        return {'color': const Color(0xFF3B82F6), 'icon': Icons.local_shipping_rounded, 'label': 'OUT FOR DELIVERY'};
      case 'DELIVERED':
        return {'color': const Color(0xFF10B981), 'icon': Icons.check_circle_rounded, 'label': 'DELIVERED'};
      case 'CANCELLED':
        return {'color': const Color(0xFFEF4444), 'icon': Icons.cancel_rounded, 'label': 'CANCELLED'};
      default:
        return {'color': const Color(0xFF64748B), 'icon': Icons.help_outline_rounded, 'label': status};
    }
  }

  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFF475569), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order['id'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const Icon(Icons.print_rounded, color: Color(0xFF2DD4BF)),
                ],
              ),
              const SizedBox(height: 4),
              Text('${order['customer']} • ${order['phone']}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
              const SizedBox(height: 16),
              _detailRow(Icons.location_on_outlined, order['address'] as String),
              const SizedBox(height: 8),
              _detailRow(Icons.access_time_rounded, 'Ordered ${order['time']} • ETA: ${order['eta']}'),
              const SizedBox(height: 20),
              const Text('Items Ordered', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
              const SizedBox(height: 8),
              ...(order['items'] as List).map((item) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFF2DD4BF), size: 6),
                    const SizedBox(width: 10),
                    Text(item as String, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order Total', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                  Text('₹${(order['amount'] as double).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 24),
              // Action buttons
              if (order['status'] == 'PLACED')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.inventory_rounded, color: Colors.white),
                    label: const Text('Mark as Packing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              if (order['status'] == 'PACKING')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.local_shipping_rounded, color: Colors.white),
                    label: const Text('Assign & Dispatch Rider', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF64748B), size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
      ),
    );
  }
}
