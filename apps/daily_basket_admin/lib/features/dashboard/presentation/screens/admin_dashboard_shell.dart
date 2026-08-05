import 'package:flutter/material.dart';
import 'operational_insights_roi_screen.dart';
import '../../../orders/presentation/screens/admin_orders_screen.dart';
import '../../../inventory/presentation/screens/admin_inventory_screen.dart';
import '../../../delivery/presentation/screens/admin_delivery_screen.dart';
import '../../../customers/presentation/screens/admin_customers_screen.dart';
import '../../../finance/presentation/screens/admin_finance_screen.dart';
import '../../../marketing/presentation/screens/admin_marketing_screen.dart';
import '../../../support/presentation/screens/admin_support_screen.dart';
import '../../../settings/presentation/screens/admin_settings_screen.dart';

class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    OperationalInsightsRoiScreen(),
    AdminOrdersScreen(),
    AdminInventoryScreen(),
    AdminDeliveryScreen(),
    AdminCustomersScreen(),
    AdminFinanceScreen(),
    AdminMarketingScreen(),
    AdminSupportScreen(),
    AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E293B),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0F766E)),
              accountName: Text('Ananya R. (Senior Director)', style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('admin@dailybasket.com'),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.admin_panel_settings, color: Color(0xFF0F766E))),
            ),
            _drawerItem(0, 'Operational Insights', Icons.insights_rounded),
            _drawerItem(1, 'Orders & Dispatch', Icons.shopping_bag_outlined),
            _drawerItem(2, 'Inventory & POs', Icons.inventory_2_outlined),
            _drawerItem(3, 'Delivery Fleet', Icons.two_wheeler_rounded),
            _drawerItem(4, 'Customers & VIPs', Icons.people_outline_rounded),
            _drawerItem(5, 'Finance & GST', Icons.account_balance_wallet_outlined),
            _drawerItem(6, 'Marketing & Banners', Icons.campaign_outlined),
            _drawerItem(7, 'Support & AI Logs', Icons.support_agent_rounded),
            _drawerItem(8, 'Settings & Security', Icons.settings_outlined),
            const Divider(color: Color(0xFF334155)),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
              title: const Text('Logout Admin Session', style: TextStyle(color: Color(0xFFEF4444))),
              onTap: () => Navigator.pushReplacementNamed(context, '/admin/welcome'),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF2DD4BF),
        unselectedItemColor: const Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.two_wheeler_rounded), label: 'Fleet'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), label: 'Customers'),
        ],
      ),
    );
  }

  Widget _drawerItem(int index, String title, IconData icon) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF2DD4BF) : Colors.white70),
      title: Text(title, style: TextStyle(color: isSelected ? const Color(0xFF2DD4BF) : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
