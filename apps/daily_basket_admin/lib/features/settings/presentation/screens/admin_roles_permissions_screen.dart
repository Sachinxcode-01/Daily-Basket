import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Roles & Permissions - Daily Basket Admin
/// Project ID: 6885817708675501691
/// Screen ID: 25b5d2e145f049b0b0656481e8e11725
class AdminRolesPermissionsScreen extends StatefulWidget {
  const AdminRolesPermissionsScreen({super.key});

  @override
  State<AdminRolesPermissionsScreen> createState() => _AdminRolesPermissionsScreenState();
}

class _AdminRolesPermissionsScreenState extends State<AdminRolesPermissionsScreen> {
  bool _isLoading = false;
  bool _isMatrixExpanded = true;

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintText = Color(0xFF15803D);

  // State Data
  final Map<String, dynamic> _rolesData = {
    'totalRoles': 12,
    'activeUsers': 452,
    'customPolicies': 8,
    'roles': [
      {
        'id': 'role-1',
        'title': 'Super Admin',
        'subtitle': 'Full system access',
        'userCount': 4,
        'icon': Icons.shield_outlined,
        'iconBg': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFDC2626),
      },
      {
        'id': 'role-2',
        'title': 'Store Manager',
        'subtitle': 'Location specific access',
        'userCount': 48,
        'icon': Icons.storefront_outlined,
        'iconBg': const Color(0xFFDCFCE7),
        'iconColor': const Color(0xFF15803D),
      },
      {
        'id': 'role-3',
        'title': 'Finance Manager',
        'subtitle': 'Payments & billing',
        'userCount': 12,
        'icon': Icons.account_balance_outlined,
        'iconBg': const Color(0xFFDCE6FE),
        'iconColor': const Color(0xFF2563EB),
      },
      {
        'id': 'role-4',
        'title': 'Inventory Manager',
        'subtitle': 'Stock & suppliers',
        'userCount': 24,
        'icon': Icons.inventory_2_outlined,
        'iconBg': const Color(0xFFFCE7F3),
        'iconColor': const Color(0xFFDB2777),
      },
    ],
    'permissionMatrix': [
      {'module': 'Products', 'read': true, 'write': true},
      {'module': 'Orders', 'read': true, 'write': true},
      {'module': 'Inventory', 'read': true, 'write': true},
    ],
    'recentActivity': [
      {
        'title': 'Permission Updated',
        'time': '10m ago',
        'actor': 'SuperAdmin',
        'action': 'added \'Delete\' access to ',
        'target': 'Inventory Manager.',
        'icon': Icons.manage_accounts_outlined,
        'iconBg': const Color(0xFFE2E8F0),
        'iconColor': const Color(0xFF475569),
        'isFailed': false,
      },
      {
        'title': 'Failed Access Attempt',
        'time': '2h ago',
        'userBadge': 'US-8821',
        'action': 'attempted to access ',
        'target': 'Finance Module.',
        'icon': Icons.gpp_maybe_outlined,
        'iconBg': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFDC2626),
        'isFailed': true,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchRolesPermissionsApi();
  }

  Future<void> _fetchRolesPermissionsApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/fleet/drivers'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          setState(() {
            _rolesData['activeUsers'] = data.length * 10;
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleCreateRole() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('➕ Opening Role Creation Wizard'),
        backgroundColor: _primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleExportAudit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📥 Exporting Security Audit Log (PDF/CSV)...'),
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
                    // Screen Title & Subtitle Header
                    const Text(
                      'Roles & Permissions',
                      style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Manage access control and security policies.',
                      style: TextStyle(color: _textMuted, fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),

                    // Metrics Strip
                    _buildMetricsStrip(),
                    const SizedBox(height: 16),

                    // Action Buttons Row
                    _buildActionButtonsRow(),
                    const SizedBox(height: 20),

                    // Built-in Roles List
                    _buildBuiltInRolesSection(),
                    const SizedBox(height: 20),

                    // Permission Matrix Card
                    _buildPermissionMatrixCard(),
                    const SizedBox(height: 20),

                    // Recent Activity Timeline
                    _buildRecentActivitySection(),
                    const SizedBox(height: 24),
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
        icon: const Icon(Icons.menu_rounded, color: _textDark),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Daily Basket',
            style: TextStyle(
              color: _primaryGreen,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
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
      ],
    );
  }

  Widget _buildMetricsStrip() {
    return SizedBox(
      height: 94,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Card 1: Total Roles
          _buildMetricCard(
            icon: Icons.badge_outlined,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: _mintText,
            label: 'Total Roles',
            value: '${_rolesData['totalRoles']}',
          ),
          const SizedBox(width: 12),

          // Card 2: Active Users
          _buildMetricCard(
            icon: Icons.people_outline_rounded,
            iconBg: const Color(0xFFDCE6FE),
            iconColor: const Color(0xFF2563EB),
            label: 'Active Users',
            value: '${_rolesData['activeUsers']}',
          ),
          const SizedBox(width: 12),

          // Card 3: Custom Policies
          _buildMetricCard(
            icon: Icons.key_outlined,
            iconBg: const Color(0xFFFCE7F3),
            iconColor: const Color(0xFFDB2777),
            label: 'Custom Policies',
            value: '${_rolesData['customPolicies']}',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      width: 135,
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: _textMuted, fontSize: 10.5, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleCreateRole,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            label: const Text(
              'Create Role',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleExportAudit,
            icon: const Icon(Icons.download_rounded, color: _textDark, size: 18),
            label: const Text(
              'Export Audit',
              style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE2E8F0),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuiltInRolesSection() {
    final List<Map<String, dynamic>> roles = _rolesData['roles'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Built-in Roles',
              style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'View All',
                style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ...roles.map((role) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: role['iconBg'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(role['icon'] as IconData, color: role['iconColor'] as Color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role['title'] as String,
                        style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 14.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role['subtitle'] as String,
                        style: const TextStyle(color: _textMuted, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${role['userCount']}',
                      style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    const Text(
                      'Users',
                      style: TextStyle(color: _textMuted, fontSize: 10.5, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPermissionMatrixCard() {
    final List<Map<String, dynamic>> matrix = _rolesData['permissionMatrix'] as List<Map<String, dynamic>>;

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Collapsible Header Row
          InkWell(
            onTap: () => setState(() => _isMatrixExpanded = !_isMatrixExpanded),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded, color: _textDark, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Permission Matrix',
                      style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  Icon(
                    _isMatrixExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: _textDark,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          if (_isMatrixExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Matrix Table
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Table Header
                  const Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Module',
                          style: TextStyle(color: _textMuted, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            'Read',
                            style: TextStyle(color: _textMuted, fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            'Write',
                            style: TextStyle(color: _textMuted, fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ...matrix.map((row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              row['module'] as String,
                              style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: row['read'] == true
                                  ? const Icon(Icons.check_circle_outline_rounded, color: _mintText, size: 20)
                                  : const Icon(Icons.cancel_outlined, color: Color(0xFFCBD5E1), size: 20),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: row['write'] == true
                                  ? const Icon(Icons.check_circle_outline_rounded, color: _mintText, size: 20)
                                  : const Icon(Icons.cancel_outlined, color: Color(0xFFCBD5E1), size: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 12),
                  const Text(
                    'Showing preview for \'Store Manager\' role.',
                    style: TextStyle(color: _textMuted, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    final List<Map<String, dynamic>> activities = _rolesData['recentActivity'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 12),

        ...activities.map((act) {
          final isFailed = act['isFailed'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFailed ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: act['iconBg'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(act['icon'] as IconData, color: act['iconColor'] as Color, size: 18),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            act['title'] as String,
                            style: TextStyle(
                              color: isFailed ? const Color(0xFFDC2626) : _textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          Text(
                            act['time'] as String,
                            style: const TextStyle(color: _textMuted, fontSize: 10.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Color(0xFF334155), fontSize: 12, height: 1.3),
                          children: [
                            if (act['actor'] != null)
                              TextSpan(
                                text: '${act['actor']} ',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: _textDark),
                              ),
                            if (act['userBadge'] != null) ...[
                              const TextSpan(text: 'User '),
                              WidgetSpan(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    act['userBadge'] as String,
                                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const TextSpan(text: ' '),
                            ],
                            TextSpan(text: act['action'] as String),
                            TextSpan(
                              text: act['target'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isFailed ? _textDark : _mintText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              _buildNavItem(1, Icons.shopping_cart_outlined, 'Orders'),
              _buildNavItem(2, Icons.inventory_2_outlined, 'Inventory'),
              _buildNavItem(3, Icons.local_shipping_outlined, 'Suppliers'),
              _buildNavItem(4, Icons.more_horiz_rounded, 'More', isSelected: true),
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
