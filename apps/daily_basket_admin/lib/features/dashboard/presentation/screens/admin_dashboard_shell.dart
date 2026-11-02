import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_dashboard_provider.dart';
import '../../../../core/providers/admin_products_provider.dart';
import 'admin_overview_screen.dart';
import 'operational_insights_roi_screen.dart';
import '../../../orders/presentation/screens/admin_orders_screen.dart';
import '../../../inventory/presentation/screens/admin_inventory_screen.dart';
import '../../../products/presentation/screens/admin_products_screen.dart';
import '../../../delivery/presentation/screens/admin_delivery_screen.dart';
import '../../../customers/presentation/screens/admin_customers_screen.dart';
import '../../../finance/presentation/screens/admin_finance_screen.dart';
import '../../../marketing/presentation/screens/admin_marketing_screen.dart';
import '../../../support/presentation/screens/admin_support_screen.dart';
import '../../../settings/presentation/screens/admin_settings_screen.dart';
import 'admin_category_management_screen.dart';

/// Admin Dashboard Shell — Single Navigation Shell for all Daily Basket admin modules
/// Follows design.md: Single primary bottom navigation bar (5 destinations) + drawer for 12 modules
class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  // Brand Colors matching design.md
  static const Color _primaryGreen = Color(0xFF2D9D43);
  static const Color _primaryDark = Color(0xFF006837);
  static const Color _surfaceLight = Color(0xFFF9F9FC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF191C1E);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _pillActiveBg = Color(0xFFDCFCE7);

  // All 12 admin modules
  static const List<Widget> _screens = [
    AdminOverviewScreen(), // 0 — Overview (default home)
    AdminOrdersScreen(), // 1 — Orders Live Feed
    AdminProductsScreen(), // 2 — Products Management & Catalog
    AdminInventoryScreen(), // 3 — Stock & Warehouse
    AdminDeliveryScreen(), // 4 — Delivery Fleet
    AdminCategoryManagementScreen(), // 5 — Categories Taxonomy
    AdminCustomersScreen(), // 6 — Customers & VIPs
    OperationalInsightsRoiScreen(), // 7 — Insights & ROI
    AdminFinanceScreen(), // 8 — Finance & GST
    AdminMarketingScreen(), // 9 — Marketing & Coupons
    AdminSupportScreen(), // 10 — Support & AI Copilot
    AdminSettingsScreen(), // 11 — Settings & Roles
  ];

  static const List<_DrawerItem> _drawerItems = [
    _DrawerItem(0, 'Overview Dashboard', Icons.grid_view_rounded),
    _DrawerItem(1, 'Orders & Dispatch', Icons.shopping_basket_rounded),
    _DrawerItem(2, 'Products Catalog', Icons.local_offer_rounded),
    _DrawerItem(3, 'Inventory & Stock', Icons.inventory_2_rounded),
    _DrawerItem(4, 'Delivery Fleet', Icons.two_wheeler_rounded),
    _DrawerItem(5, 'Categories Taxonomy', Icons.category_rounded),
    _DrawerItem(6, 'Customers & VIPs', Icons.people_outline_rounded),
    _DrawerItem(7, 'Operational Insights', Icons.insights_rounded),
    _DrawerItem(8, 'Finance & GST', Icons.account_balance_wallet_outlined),
    _DrawerItem(9, 'Marketing & Coupons', Icons.campaign_outlined),
    _DrawerItem(10, 'Support & AI Copilot', Icons.support_agent_rounded),
    _DrawerItem(11, 'Settings & Security', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<AdminDashboardProvider>();
    final currentIndex = dashboard.currentTabIndex;

    return Scaffold(
      backgroundColor: _surfaceLight,
      drawer: _buildDrawer(context, dashboard, currentIndex),
      body: IndexedStack(
        index: currentIndex.clamp(0, _screens.length - 1),
        children: _screens,
      ),
      bottomNavigationBar: _buildUnifiedBottomNav(context, dashboard, currentIndex),
    );
  }

  Widget _buildDrawer(
      BuildContext context, AdminDashboardProvider dashboard, int currentIndex) {
    final productsProvider = context.watch<AdminProductsProvider>();

    return Drawer(
      backgroundColor: _cardBg,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header matching Daily Basket Green Theme
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryDark, _primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.storefront_rounded,
                            color: Colors.white, size: 26),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_outlined,
                                color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text('Super Admin',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Daily Basket Operations',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  const Text('Dark Store #04 • HSR Hub',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('admin@dailybasket.com',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Navigation items list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: _drawerItems.map((item) {
                  final isSelected = currentIndex == item.index;

                  // Dynamic badge content
                  Widget? badge;
                  if (item.index == 1 && dashboard.pendingOrders > 0) {
                    badge = Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${dashboard.pendingOrders}',
                        style: const TextStyle(
                            color: Color(0xFFB91C1C),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  } else if (item.index == 2 &&
                      productsProvider.lowStockCount > 0) {
                    badge = Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${productsProvider.lowStockCount} alert',
                        style: const TextStyle(
                            color: Color(0xFFC2410C),
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? _pillActiveBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      leading: Icon(
                        item.icon,
                        color: isSelected ? _primaryDark : _textDark,
                        size: 22,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? _primaryDark : _textDark,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13.5,
                        ),
                      ),
                      trailing: badge,
                      onTap: () {
                        dashboard.switchTab(item.index);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(color: Color(0xFFE2E8F0), height: 1),
            ListTile(
              leading: const Icon(Icons.logout_rounded,
                  color: Color(0xFFDC2626), size: 22),
              title: const Text('Logout Admin Session',
                  style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5)),
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

  Widget _buildUnifiedBottomNav(
      BuildContext context, AdminDashboardProvider dashboard, int currentIndex) {
    final productsProvider = context.watch<AdminProductsProvider>();

    // 5 primary bottom destinations:
    // 0: Home, 1: Orders, 2: Products, 3: Inventory, 4: Fleet
    final bottomNavItems = [
      const _BottomDestination(
        index: 0,
        icon: Icons.grid_view_rounded,
        label: 'Home',
      ),
      _BottomDestination(
        index: 1,
        icon: Icons.shopping_basket_rounded,
        label: 'Orders',
        badgeCount: dashboard.pendingOrders,
      ),
      _BottomDestination(
        index: 2,
        icon: Icons.local_offer_rounded,
        label: 'Products',
        badgeCount: productsProvider.lowStockCount,
      ),
      const _BottomDestination(
        index: 3,
        icon: Icons.inventory_2_outlined,
        label: 'Inventory',
      ),
      const _BottomDestination(
        index: 4,
        icon: Icons.two_wheeler_rounded,
        label: 'Fleet',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomNavItems.map((item) {
              final isSelected = currentIndex == item.index;

              return InkWell(
                onTap: () => dashboard.switchTab(item.index),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? _pillActiveBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? _primaryDark : _textMuted,
                            size: 22,
                          ),
                          if (item.badgeCount != null && item.badgeCount! > 0)
                            Positioned(
                              top: -4,
                              right: -8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '${item.badgeCount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? _primaryDark : _textMuted,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
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

class _BottomDestination {
  final int index;
  final IconData icon;
  final String label;
  final int? badgeCount;
  const _BottomDestination({
    required this.index,
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}
