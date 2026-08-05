import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_dashboard_provider.dart';
import '../../../../core/widgets/staggered_animated_card.dart';

/// Stitch Screen: Admin Overview - Daily Basket Ops
/// ID: bb128b8328ea4878b08b95b779ae31d2
class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<AdminDashboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: AnimationLimiter(
        child: CustomScrollView(
        slivers: [
          // Sticky Header with greeting and notifications
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: const Color(0xFF0F172A),
            surfaceTintColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF0F766E),
                child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, Ananya 👋',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Text(
                    'Daily Basket Ops',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Live pulse indicator (Index 0)
                StaggeredAnimatedCard(
                  index: 0,
                  child: _buildLivePulseBar(dashboard),
                ),
                const SizedBox(height: 20),

                // Revenue hero card (Index 1)
                StaggeredAnimatedCard(
                  index: 1,
                  child: _buildRevenueHeroCard(dashboard),
                ),
                const SizedBox(height: 16),

                // Quick-stat chips row (Index 2-5)
                _buildQuickStats(dashboard),
                const SizedBox(height: 24),

                // Operations grid header & items
                StaggeredAnimatedCard(
                  index: 6,
                  child: _SectionHeader(
                    title: 'Live Operations',
                    icon: Icons.bolt_rounded,
                    onTapViewAll: () => Navigator.pushNamed(context, '/admin/orders'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildOpsGrid(context),
                const SizedBox(height: 24),

                // Recent order timeline
                StaggeredAnimatedCard(
                  index: 11,
                  child: _SectionHeader(
                    title: 'Order Activity Feed',
                    icon: Icons.timeline_rounded,
                    onTapViewAll: () => Navigator.pushNamed(context, '/admin/orders'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildOrderFeed(),
                const SizedBox(height: 24),

                // Rider fleet summary
                StaggeredAnimatedCard(
                  index: 16,
                  child: _SectionHeader(
                    title: 'Fleet Status',
                    icon: Icons.two_wheeler_rounded,
                    onTapViewAll: () => Navigator.pushNamed(context, '/admin/delivery'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFleetStatus(),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildLivePulseBar(AdminDashboardProvider dashboard) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F766E).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0F766E).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          const Text(
            'LIVE — All systems operational',
            style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8),
          ),
          const Spacer(),
          Text(
            '${dashboard.todayOrders} orders today',
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueHeroCard(AdminDashboardProvider dashboard) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x5014B8A6), blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TODAY\'S GROSS REVENUE',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.4),
              ),
              Row(
                children: [
                  Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 2),
                  Text('+18.4%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹${(38450.0).toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1),
          ),
          const SizedBox(height: 4),
          const Text(
            'vs ₹32,472 last Tuesday',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              _MiniStat(label: 'Orders', value: '142', icon: Icons.receipt_long_rounded),
              SizedBox(width: 24),
              _MiniStat(label: 'Avg. Order', value: '₹271', icon: Icons.shopping_basket_rounded),
              SizedBox(width: 24),
              _MiniStat(label: 'Refunds', value: '3', icon: Icons.replay_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AdminDashboardProvider dashboard) {
    final chips = [
      {'icon': Icons.pending_actions_rounded, 'label': 'Pending', 'value': '${dashboard.pendingOrders}', 'color': const Color(0xFFF59E0B)},
      {'icon': Icons.inventory_2_outlined, 'label': 'Low Stock', 'value': '7', 'color': const Color(0xFFEF4444)},
      {'icon': Icons.two_wheeler_rounded, 'label': 'Riders', 'value': '${dashboard.activeRiders}', 'color': const Color(0xFF3B82F6)},
      {'icon': Icons.star_half_rounded, 'label': 'Rating', 'value': '4.8', 'color': const Color(0xFF8B5CF6)},
    ];

    return Row(
      children: chips.asMap().entries.map((entry) {
        final i = entry.key;
        final chip = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == chips.length - 1 ? 0 : 8),
            child: StaggeredAnimatedCard(
              index: 2 + i,
              child: _QuickStatChip(
                icon: chip['icon'] as IconData,
                label: chip['label'] as String,
                value: chip['value'] as String,
                color: chip['color'] as Color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOpsGrid(BuildContext context) {
    const ops = [
      {'label': 'Packing Queue', 'count': '8', 'icon': Icons.inventory_rounded, 'color': Color(0xFF0F766E), 'route': '/admin/orders'},
      {'label': 'Out for Delivery', 'count': '14', 'icon': Icons.local_shipping_rounded, 'color': Color(0xFF3B82F6), 'route': '/admin/delivery'},
      {'label': 'Riders Online', 'count': '18', 'icon': Icons.two_wheeler_rounded, 'color': Color(0xFF10B981), 'route': '/admin/delivery'},
      {'label': 'Support Tickets', 'count': '3', 'icon': Icons.headset_mic_rounded, 'color': Color(0xFFF59E0B), 'route': '/admin/support'},
    ];

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: ops.asMap().entries.map((entry) {
        final i = entry.key;
        final op = entry.value;
        final color = op['color'] as Color;
        final route = op['route'] as String;
        return StaggeredAnimatedCard(
          index: 7 + i,
          onTap: () => Navigator.pushNamed(context, route),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Icon(op['icon'] as IconData, color: color, size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(op['count'] as String, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(op['label'] as String, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderFeed() {
    final feeds = [
      {'id': '#DB-892142', 'customer': 'Ananya Sharma', 'status': 'DELIVERED', 'amount': '₹285', 'color': const Color(0xFF10B981), 'time': '2m ago'},
      {'id': '#DB-892141', 'customer': 'Rohan Gupta', 'status': 'OUT_FOR_DELIVERY', 'amount': '₹405', 'color': const Color(0xFF3B82F6), 'time': '5m ago'},
      {'id': '#DB-892140', 'customer': 'Priya Nair', 'status': 'PACKING', 'amount': '₹145', 'color': const Color(0xFFF59E0B), 'time': '8m ago'},
      {'id': '#DB-892139', 'customer': 'Karan Mehta', 'status': 'PLACED', 'amount': '₹610', 'color': const Color(0xFF8B5CF6), 'time': '11m ago'},
    ];

    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: feeds.asMap().entries.map((entry) {
          final i = entry.key;
          final feed = entry.value;
          final isLast = i == feeds.length - 1;
          return StaggeredAnimatedCard(
            index: 12 + i,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (feed['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        (feed['customer'] as String).substring(0, 1),
                        style: TextStyle(color: feed['color'] as Color, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  title: Text(
                    '${feed['id']} • ${feed['customer']}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  subtitle: Text(feed['time'] as String, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(feed['amount'] as String, style: const TextStyle(color: Color(0xFF2DD4BF), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (feed['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          feed['status'] as String,
                          style: TextStyle(color: feed['color'] as Color, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast) const Divider(height: 0, color: Color(0xFF334155)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFleetStatus() {
    final riders = [
      {'name': 'Ravi Kumar', 'zone': 'Koramangala', 'orders': '8/10', 'status': 'ACTIVE', 'rating': '4.9'},
      {'name': 'Suresh Yadav', 'zone': 'HSR Layout', 'orders': '6/10', 'status': 'ACTIVE', 'rating': '4.7'},
      {'name': 'Deepak Singh', 'zone': 'Indiranagar', 'orders': '0/10', 'status': 'OFFLINE', 'rating': '4.5'},
    ];

    return Column(
      children: riders.asMap().entries.map((entry) {
        final i = entry.key;
        final rider = entry.value;
        final isActive = rider['status'] == 'ACTIVE';
        return StaggeredAnimatedCard(
          index: 17 + i,
          margin: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isActive ? const Color(0xFF0F766E) : const Color(0xFF475569),
                  child: Text(rider['name']!.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rider['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('${rider['zone']} • ${rider['orders']} deliveries', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFF475569).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rider['status']!,
                        style: TextStyle(
                          color: isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 12),
                        const SizedBox(width: 2),
                        Text(rider['rating']!, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTapViewAll;
  const _SectionHeader({required this.title, required this.icon, this.onTapViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2DD4BF), size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        const Spacer(),
        GestureDetector(
          onTap: onTapViewAll,
          child: const Row(
            children: [
              Text('View All', style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 12, fontWeight: FontWeight.w600)),
              Icon(Icons.chevron_right_rounded, color: Color(0xFF2DD4BF), size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MiniStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white60, size: 12),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}

class _QuickStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _QuickStatChip({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
