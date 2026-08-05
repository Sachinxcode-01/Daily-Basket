import 'package:flutter/material.dart';
import 'admin_overview_screen.dart';
import 'operational_insights_roi_screen.dart';
import '../../../orders/presentation/screens/admin_orders_screen.dart';
import '../../../inventory/presentation/screens/admin_inventory_screen.dart';
import '../../../delivery/presentation/screens/admin_delivery_screen.dart';
import '../../../customers/presentation/screens/admin_customers_screen.dart';
import '../../../finance/presentation/screens/admin_finance_screen.dart';
import '../../../marketing/presentation/screens/admin_marketing_screen.dart';
import '../../../support/presentation/screens/admin_support_screen.dart';
import '../../../settings/presentation/screens/admin_settings_screen.dart';

import 'admin_category_management_screen.dart';

/// Admin Dashboard Shell — Navigation container for all admin modules
/// Uses BottomNavigationBar (5 primary tabs) + Drawer (all 9 modules)
class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  int _currentIndex = 0;

  // All module screens (indexed 0-10)
  static const List<Widget> _screens = [
    AdminOverviewScreen(),             // 0 — Overview (default home)
    AdminOrdersScreen(),               // 1 — Orders Live Feed
    AdminInventoryScreen(),            // 2 — Stock & Expiry
    AdminCategoryManagementScreen(),   // 3 — Categories Taxonomy
    AdminDeliveryScreen(),             // 4 — Fleet
    AdminCustomersScreen(),            // 5 — Customers
    OperationalInsightsRoiScreen(),    // 6 — Insights & ROI
    AdminFinanceScreen(),              // 7 — Finance & GST
    AdminMarketingScreen(),            // 8 — Marketing
    AdminSupportScreen(),              // 9 — Support AI
    AdminSettingsScreen(),             // 10 — Settings & Security
  ];

  static const List<_DrawerItem> _drawerItems = [
    _DrawerItem(0, 'Overview', Icons.home_rounded),
    _DrawerItem(1, 'Orders & Dispatch', Icons.shopping_bag_outlined),
    _DrawerItem(2, 'Inventory & Stock', Icons.inventory_2_outlined),
    _DrawerItem(3, 'Categories Taxonomy', Icons.category_rounded),
    _DrawerItem(4, 'Delivery Fleet', Icons.two_wheeler_rounded),
    _DrawerItem(5, 'Customers & VIPs', Icons.people_outline_rounded),
    _DrawerItem(6, 'Operational Insights', Icons.insights_rounded),
    _DrawerItem(7, 'Finance & GST', Icons.account_balance_wallet_outlined),
    _DrawerItem(8, 'Marketing & Banners', Icons.campaign_outlined),
    _DrawerItem(9, 'Support & AI', Icons.support_agent_rounded),
    _DrawerItem(10, 'Settings & Security', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E293B),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF14B8A6)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text('Ananya R.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Text('Senior Director • Super Admin', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                    child: const Text('admin@dailybasket.com', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Nav items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _drawerItems.map((item) => _buildDrawerItem(context, item)).toList(),
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 1),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
              title: const Text('Logout Admin Session', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/admin/welcome');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, _DrawerItem item) {
    final isSelected = _currentIndex == item.index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F766E).withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(item.icon, color: isSelected ? const Color(0xFF2DD4BF) : Colors.white70, size: 22),
        title: Text(
          item.label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2DD4BF) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        trailing: isSelected ? Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: Color(0xFF2DD4BF), shape: BoxShape.circle),
        ) : null,
        onTap: () {
          setState(() => _currentIndex = item.index);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    // Only show 5 tabs in bottom nav (most used)
    const bottomItems = [
      _NavItem(0, 'Overview', Icons.home_rounded),
      _NavItem(1, 'Orders', Icons.shopping_bag_outlined),
      _NavItem(2, 'Inventory', Icons.inventory_2_outlined),
      _NavItem(3, 'Fleet', Icons.two_wheeler_rounded),
      _NavItem(5, 'Insights', Icons.insights_rounded),
    ];

    // Map bottom nav index to actual screen index
    final bottomToScreen = [0, 1, 2, 3, 5];
    final activeBottomIndex = bottomToScreen.indexOf(_currentIndex);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(top: BorderSide(color: Color(0xFF334155), width: 0.5)),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: activeBottomIndex >= 0 ? activeBottomIndex : 0,
          onTap: (index) => setState(() => _currentIndex = bottomToScreen[index]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF2DD4BF),
          unselectedItemColor: const Color(0xFF64748B),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: bottomItems.map((item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          )).toList(),
        ),
      ),
    );
  }
}

class _DrawerItem {
  final int index;
  final String label;
  final IconData icon;
  const _DrawerItem(this.index, this.label, this.icon);
}

class _NavItem {
  final int screenIndex;
  final String label;
  final IconData icon;
  const _NavItem(this.screenIndex, this.label, this.icon);
}
