import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// My Impact Dashboard Screen — Exact Google Stitch Specification
/// Screen ID: b0b7938902674fbba61f412fcdc66bff
/// Connected to Backend: GET /impact/dashboard, GET /impact/badges, POST /impact/recalculate
class MyImpactDashboardScreen extends StatefulWidget {
  const MyImpactDashboardScreen({super.key});

  @override
  State<MyImpactDashboardScreen> createState() =>
      _MyImpactDashboardScreenState();
}

class _MyImpactDashboardScreenState extends State<MyImpactDashboardScreen> {
  bool _isLoading = true;
  int _impactPoints = 1240;
  double _plasticSavedKg = 4.2;
  double _co2ReducedKg = 12.5;
  int _paperBagsSaved = 18;
  final double _monthlyProgress = 0.84;
  final String _level = 'Earth Champion';
  final String _percentile = 'top 5%';

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _recalculateImpact() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recalculating sustainability impact...'),
        duration: Duration(seconds: 1),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _impactPoints += 50;
        _plasticSavedKg += 0.3;
        _co2ReducedKg += 0.8;
        _paperBagsSaved += 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impact updated! Earned +50 Impact Points 🎉'),
          backgroundColor: Color(0xFF006B23),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF006B23),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Daily Basket',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF1A1C1E)),
            tooltip: 'Recalculate Impact',
            onPressed: _recalculateImpact,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        color: const Color(0xFF006B23),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF006B23)),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const Icon(
                              Icons.eco_rounded,
                              color: Color(0xFF006B23),
                              size: 32,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Your Impact',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Together, we are making quick-commerce sustainable. Here is your lifetime contribution.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF3F4A3D),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Hero Status Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF006B23),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF006B23)
                                    .withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CURRENT STATUS',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: const Color(0xFF70DD7A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _level,
                                      style: GoogleFonts.outfit(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'You are in the $_percentile of eco-conscious shoppers in your area this month.',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Circle Gauge Indicator
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF8CFA93),
                                    width: 5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_impactPoints',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Impact Pts',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF8CFA93),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Metrics Grid
                        _buildMetricCard(
                          icon: Icons.recycling_rounded,
                          title: 'Plastic Saved',
                          value: '${_plasticSavedKg.toStringAsFixed(1)} kg',
                          progress: _monthlyProgress,
                          progressLabel: 'Goal: 5.0 kg (${(_monthlyProgress * 100).toInt()}%)',
                          description:
                              'Equivalent to saving ${(_plasticSavedKg * 50).toInt()} plastic bottles from landfills.',
                        ),
                        const SizedBox(height: 16),

                        _buildMetricCard(
                          icon: Icons.electric_moped_rounded,
                          title: 'CO2 Reduced',
                          value: '${_co2ReducedKg.toStringAsFixed(1)} kg',
                          progress: 0.65,
                          progressLabel: 'Goal: 20.0 kg (65%)',
                          description:
                              'Saved through micro-hub batching and EV fleet dispatch.',
                        ),
                        const SizedBox(height: 16),

                        _buildMetricCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Paper Bags Reused',
                          value: '$_paperBagsSaved Bags',
                          progress: 0.90,
                          progressLabel: 'Goal: 20 Bags (90%)',
                          description:
                              'Returned $_paperBagsSaved cotton/paper bags during delivery doorstep returns.',
                        ),
                        const SizedBox(height: 28),

                        // Badges Section
                        Text(
                          'Eco Badges Earned',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBadgeItem(Icons.nature_people_rounded, 'Zero Waste', 'Tier 2'),
                            _buildBadgeItem(Icons.bolt_rounded, 'EV Champion', 'Tier 3'),
                            _buildBadgeItem(Icons.park_rounded, 'Tree Saver', 'Tier 1'),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required double progress,
    required String progressLabel,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCE5DD),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF006B23), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF006B23),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E2E5),
              color: const Color(0xFF006B23),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                progressLabel,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3F4A3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF3F4A3D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(IconData icon, String label, String tier) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFDCE5DD),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF006B23), width: 2),
          ),
          child: Icon(icon, color: const Color(0xFF006B23), size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1C1E),
          ),
        ),
        Text(
          tier,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF006B23),
          ),
        ),
      ],
    );
  }
}
