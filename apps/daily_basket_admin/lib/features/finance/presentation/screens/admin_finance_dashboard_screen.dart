import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Finance Dashboard
/// Project ID: 6885817708675501691
/// Screen ID: bed36b1f6f634b1395586a035fd48e7d
class AdminFinanceDashboardScreen extends StatefulWidget {
  const AdminFinanceDashboardScreen({super.key});

  @override
  State<AdminFinanceDashboardScreen> createState() => _AdminFinanceDashboardScreenState();
}

class _AdminFinanceDashboardScreenState extends State<AdminFinanceDashboardScreen> {
  bool _isLoading = false;

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintText = Color(0xFF15803D);

  // State Data
  final Map<String, dynamic> _financeData = {
    'todaysRevenue': '₹45,230',
    'revenueTrend': '📈 12%',
    'netProfit': '₹12,840',
    'aiGrowthOpportunity': 'Dairy category revenue is projected to increase by 15% this weekend.',
    'aiLossAlert': 'High spoilage rate in leafy greens causing 4% revenue leak.',
    'recentTransactions': [
      {
        'id': 'Order #4429',
        'time': 'Today, 10:42 AM',
        'amount': '+₹1,250',
        'amountColor': const Color(0xFF15803D),
        'badgeText': 'Payment',
        'icon': Icons.arrow_downward_rounded,
        'iconBg': const Color(0xFFDCFCE7),
        'iconColor': const Color(0xFF15803D),
      },
      {
        'id': 'Fresh Farm Suppliers',
        'time': 'Today, 09:15 AM',
        'amount': '-₹4,500',
        'amountColor': _textDark,
        'badgeText': 'Payout',
        'icon': Icons.arrow_upward_rounded,
        'iconBg': const Color(0xFFFFEDD5),
        'iconColor': const Color(0xFFC2410C),
      },
      {
        'id': 'Refund: Order #4410',
        'time': 'Yesterday, 04:30 PM',
        'amount': '-₹320',
        'amountColor': const Color(0xFFDC2626),
        'badgeText': 'Refund',
        'icon': Icons.swap_horiz_rounded,
        'iconBg': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFDC2626),
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _fetchFinanceApi();
  }

  Future<void> _fetchFinanceApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/v1/finance/overview'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['todaysRevenue'] != null) {
          setState(() {
            _financeData['todaysRevenue'] = data['todaysRevenue'] ?? _financeData['todaysRevenue'];
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _triggerQuickAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executing Finance Action "$action"'),
        backgroundColor: _primaryGreen,
        duration: const Duration(seconds: 2),
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
                    // Metrics 2-Columns Strip
                    _buildTopMetricsRow(),
                    const SizedBox(height: 16),

                    // AI Insights Card
                    _buildAiInsightsCard(),
                    const SizedBox(height: 16),

                    // Quick Actions Section
                    _buildQuickActionsSection(),
                    const SizedBox(height: 16),

                    // Revenue Trend Graph Mock Card
                    _buildRevenueTrendCard(),
                    const SizedBox(height: 16),

                    // Expense Breakdown Donut Chart Representation
                    _buildExpenseBreakdownCard(),
                    const SizedBox(height: 16),

                    // Recent Transactions List
                    _buildRecentTransactionsList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _primaryGreen,
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
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'Finance Dashboard',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_outlined, color: _textDark, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildTopMetricsRow() {
    return Row(
      children: [
        // Card 1: Today's Revenue
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: _primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.attach_money_rounded, color: Colors.white, size: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _financeData['revenueTrend'] as String,
                        style: const TextStyle(color: _mintText, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Today\'s Revenue', style: TextStyle(color: _textMuted, fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  _financeData['todaysRevenue'] as String,
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Card 2: Net Profit
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCE6FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_outlined, color: Color(0xFF2563EB), size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Net Profit', style: TextStyle(color: _textMuted, fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  _financeData['netProfit'] as String,
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
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
                'AI Insights',
                style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recommendation 1: Growth Opportunity
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.trending_up_rounded, color: _mintText, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Growth Opportunity',
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _financeData['aiGrowthOpportunity'] as String,
                        style: const TextStyle(color: _textMuted, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Alert 2: Loss Alert
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFEE2E2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loss Alert: Perishables',
                        style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _financeData['aiLossAlert'] as String,
                        style: const TextStyle(color: Color(0xFF991B1B), fontSize: 11, height: 1.3),
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
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt_rounded, color: _textDark, size: 18),
            SizedBox(width: 6),
            Text(
              'Quick Actions',
              style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _triggerQuickAction('Approve Refund'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.receipt_long_outlined, color: _mintText, size: 22),
                      SizedBox(height: 6),
                      Text(
                        'Approve Refund',
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _triggerQuickAction('Create Expense'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: Color(0xFF0284C7), size: 22),
                      SizedBox(height: 6),
                      Text(
                        'Create Expense',
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        GestureDetector(
          onTap: () => _triggerQuickAction('Generate GST Report'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description_outlined, color: Color(0xFFC2410C), size: 20),
                SizedBox(width: 8),
                Text(
                  'Generate GST Report',
                  style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueTrendCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Revenue Trend',
                style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('This Week', style: TextStyle(color: _textDark, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Graph Mock Container
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomPaint(
              painter: _RevenueGraphPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdownCard() {
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
            'Expense Breakdown',
            style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Donut Chart Graphic representation
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: _DonutChartPainter(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(children: [Icon(Icons.square, color: _primaryGreen, size: 10), SizedBox(width: 4), Text('Inventory', style: TextStyle(color: _textMuted, fontSize: 11))]),
              Row(children: [Icon(Icons.square, color: Color(0xFFC2410C), size: 10), SizedBox(width: 4), Text('Logistics', style: TextStyle(color: _textMuted, fontSize: 11))]),
              Row(children: [Icon(Icons.square, color: Color(0xFF0284C7), size: 10), SizedBox(width: 4), Text('Salary', style: TextStyle(color: _textMuted, fontSize: 11))]),
              Row(children: [Icon(Icons.square, color: Color(0xFF475569), size: 10), SizedBox(width: 4), Text('Misc', style: TextStyle(color: _textMuted, fontSize: 11))]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsList() {
    final List<Map<String, dynamic>> list = _financeData['recentTransactions'] as List<Map<String, dynamic>>;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
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
          const SizedBox(height: 14),

          ...list.map((tx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tx['iconBg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(tx['icon'] as IconData, color: tx['iconColor'] as Color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx['id'] as String,
                          style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          tx['time'] as String,
                          style: const TextStyle(color: _textMuted, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tx['amount'] as String,
                        style: TextStyle(
                          color: tx['amountColor'] as Color,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tx['badgeText'] as String,
                          style: const TextStyle(color: _textMuted, fontSize: 9.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
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
              _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard'),
              _buildNavItem(1, Icons.receipt_long_outlined, 'Orders'),
              _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Finance', isSelected: true),
              _buildNavItem(3, Icons.storefront_rounded, 'Suppliers'),
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

class _RevenueGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF006837)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.8, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 24.0;

    final paintGreen = Paint()
      ..color = const Color(0xFF006837)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paintOrange = Paint()
      ..color = const Color(0xFFC2410C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paintBlue = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, 0, 3.14 * 1.1, false, paintGreen);
    canvas.drawArc(rect, 3.14 * 1.1, 3.14 * 0.5, false, paintOrange);
    canvas.drawArc(rect, 3.14 * 1.6, 3.14 * 0.4, false, paintBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
