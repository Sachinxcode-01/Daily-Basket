import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_dashboard_provider.dart';

class OperationalInsightsRoiScreen extends StatelessWidget {
  const OperationalInsightsRoiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<AdminDashboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Operational Insights & ROI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2DD4BF)),
            onPressed: () => context.read<AdminDashboardProvider>().refreshMetrics(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ROI Executive Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF14B8A6)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x4014B8A6), blurRadius: 16, offset: Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SYSTEM ROI & PERFORMANCE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      Icon(Icons.trending_up_rounded, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('₹${dashboard.todayRevenue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Today Gross Revenue (+18.4% vs prev week)', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),

                ],
              ),
            ),
            const SizedBox(height: 20),

            // KPI Grid
            Row(
              children: [
                Expanded(child: _buildKpiCard('Orders Today', '${dashboard.todayOrders}', Icons.shopping_bag_outlined, const Color(0xFF3B82F6))),
                const SizedBox(width: 12),
                Expanded(child: _buildKpiCard('Pending Packing', '${dashboard.pendingOrders}', Icons.pending_actions_rounded, const Color(0xFFF59E0B))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildKpiCard('Active Riders', '${dashboard.activeRiders}', Icons.two_wheeler_rounded, const Color(0xFF10B981))),
                const SizedBox(width: 12),
                Expanded(child: _buildKpiCard('Uptime SLA', '${dashboard.systemHealth}%', Icons.speed_rounded, const Color(0xFF8B5CF6))),
              ],
            ),
            const SizedBox(height: 24),

            const Text('Dark Store Operational Heat Map', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildHeatMapRow('Koramangala 4th Block', 94, '8.2 mins avg SLA'),
                  const Divider(color: Color(0xFF334155)),
                  _buildHeatMapRow('HSR Layout Sector 1', 88, '9.1 mins avg SLA'),
                  const Divider(color: Color(0xFF334155)),
                  _buildHeatMapRow('Indiranagar 100 Feet Rd', 76, '8.5 mins avg SLA'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHeatMapRow(String sector, int density, String sla) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sector, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sla, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(12)),
            child: Text('$density Density', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
