import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/services/stock_alerts_service.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';

/// Back to Stock Alerts Screen — Exact Google Stitch Specification
/// Screen ID: 85cd7a7a93e545678e3ebfcc52c37c32
class BackToStockAlertsScreen extends StatefulWidget {
  final StockAlertsService? alertsService;

  const BackToStockAlertsScreen({super.key, this.alertsService});

  @override
  State<BackToStockAlertsScreen> createState() =>
      _BackToStockAlertsScreenState();
}

class _BackToStockAlertsScreenState extends State<BackToStockAlertsScreen> {
  late final StockAlertsService _service;
  bool _isLoading = true;
  List<Map<String, dynamic>> _alerts = [];

  @override
  void initState() {
    super.initState();
    _service = widget.alertsService ?? StockAlertsService();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    final alerts = await _service.fetchAlerts();
    if (mounted) {
      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2124) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final textSecondary = isDark ? const Color(0xFFB0B3B8) : const Color(0xFF3F4A3D);
    final borderDefault = isDark ? Colors.white12 : const Color(0xFFE2E2E5);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppNavigationDrawer(isDrawer: true),
      bottomNavigationBar: const AppBottomNav(currentIndex: 5),
      appBar: const AppTopBar(
        title: 'Back to Stock Alerts',
        showBack: true,
        showDrawer: true,
        showProfile: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAlerts,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track Favorite Restocks',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get notified instantly when your out-of-stock favorites return to dark store inventory.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  else if (_alerts.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderDefault),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 48,
                            color: textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Stock Alerts Yet',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Items you set restock notifications for will appear here.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Alerts Card List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _alerts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _alerts[index];
                        final isRestocked = item['status'] == 'RESTOCKED';

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isRestocked
                                  ? AppColors.primary
                                  : borderDefault,
                              width: isRestocked ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item['image'] as String? ?? 'https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400&q=80',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 70,
                                        height: 70,
                                        color: isDark ? Colors.white10 : Colors.black12,
                                        child: const Icon(Icons.inventory_2_outlined),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isRestocked
                                                ? (isDark ? const Color(0xFF1E3A24) : const Color(0xFFDCE5DD))
                                                : const Color(0xFFFFDAD6),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isRestocked ? 'RESTOCKED' : 'OUT OF STOCK',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: isRestocked
                                                  ? (isDark ? AppColors.primaryFixedDim : const Color(0xFF006B23))
                                                  : const Color(0xFFBA1A1A),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['name'] as String? ?? 'Daily Basket Item',
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary,
                                          ),
                                        ),
                                        Text(
                                          item['time'] as String? ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Divider(color: borderDefault, height: 1),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item['price']} (${item['mrp']})',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.primaryFixedDim : const Color(0xFF006B23),
                                    ),
                                  ),
                                  if (isRestocked)
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/cart');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Add to Cart',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        Text(
                                          'Push Alert',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: textSecondary,
                                          ),
                                        ),
                                        Switch(
                                          value: item['notifyEnabled'] as bool? ?? false,
                                          activeTrackColor: AppColors.primary,
                                          onChanged: (val) async {
                                            setState(() {
                                              item['notifyEnabled'] = val;
                                            });
                                            await _service.toggleAlert(
                                              item['id'].toString(),
                                              val,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
