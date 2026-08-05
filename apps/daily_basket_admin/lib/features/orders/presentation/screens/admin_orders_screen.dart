import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          title: const Text('Orders & Fulfillment Dispatch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF1E293B),
          bottom: const TabBar(
            indicatorColor: Color(0xFF2DD4BF),
            labelColor: Color(0xFF2DD4BF),
            unselectedLabelColor: Color(0xFF64748B),
            tabs: [
              Tab(text: 'Pending (12)'),
              Tab(text: 'Packing (8)'),
              Tab(text: 'On The Way (14)'),
              Tab(text: 'Delivered (108)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList([
              {'orderNumber': '#DB-892104', 'customer': 'Ananya Sharma', 'items': 'Organic Tomatoes, Milk', 'amount': '₹285', 'status': 'PACKING'},
              {'orderNumber': '#DB-892105', 'customer': 'Rohan Gupta', 'items': 'Aashirvaad Atta 5kg, Paneer', 'amount': '₹405', 'status': 'READY_FOR_PICKUP'},
            ]),
            _buildOrderList([
              {'orderNumber': '#DB-892099', 'customer': 'Priya Nair', 'items': 'Cucumbers, Eggs Pack of 6', 'amount': '₹145', 'status': 'PACKING'},
            ]),
            _buildOrderList([
              {'orderNumber': '#DB-892080', 'customer': 'Karan Verma', 'items': 'Brown Bread, Butter', 'amount': '₹190', 'status': 'OUT_FOR_DELIVERY'},
            ]),
            _buildOrderList([
              {'orderNumber': '#DB-892010', 'customer': 'Sneha Patel', 'items': 'Organic Hass Avocados', 'amount': '₹240', 'status': 'DELIVERED'},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, String>> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final item = orders[index];
        return Card(
          color: const Color(0xFF1E293B),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item['orderNumber']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('${item['customer']} • ${item['items']}', style: const TextStyle(color: Color(0xFF94A3B8))),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item['amount']!, style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(8)),
                  child: Text(item['status']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
