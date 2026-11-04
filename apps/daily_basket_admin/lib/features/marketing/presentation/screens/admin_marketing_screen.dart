import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/admin_marketing_provider.dart';
import '../../../../core/models/daily_message_campaign.dart';
import '../../../../core/models/admin_coupon.dart';
import '../widgets/create_campaign_sheet.dart';

/// Stitch Enterprise Admin Screen: Marketing & Daily Campaigns Command Center
class AdminMarketingScreen extends StatefulWidget {
  const AdminMarketingScreen({super.key});

  @override
  State<AdminMarketingScreen> createState() => _AdminMarketingScreenState();
}

class _AdminMarketingScreenState extends State<AdminMarketingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _primaryGreen = Color(0xFF2D9D43);
  static const Color _surfaceDark = Color(0xFF0F172A);
  static const Color _cardBg = Color(0xFF1E293B);
  static const Color _borderDark = Color(0xFF334155);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminMarketingProvider>().loadMarketingData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCreateCampaignModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateCampaignSheet(),
    );
  }

  Future<void> _triggerBroadcast([String? campaignId]) async {
    final provider = context.read<AdminMarketingProvider>();
    final active = provider.activeCampaign;

    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.bolt_rounded, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text('Dispatch Push Broadcast?',
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
        content: Text(
          'This will send instant push notifications and update the in-app daily grocery banner for target customers.\n\nCampaign: "${active?.title ?? 'Active Daily Message'}"',
          style:
              const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Broadcast Now 🚀'),
          ),
        ],
      ),
    );

    if (shouldProceed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final result = await provider.dispatchBroadcast(campaignId);

    if (!mounted) return;

    if (result['success'] == true) {
      final delivered =
          result['deliveredCount'] ?? result['totalTargeted'] ?? 0;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              '⚡ Broadcast delivered to $delivered customers successfully!'),
          backgroundColor: _primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content:
              Text('Broadcast failed: ${result['error'] ?? 'Unknown error'}'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openAddCouponDialog() {
    final codeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final valueCtrl = TextEditingController(text: '50');
    final minOrderCtrl = TextEditingController(text: '199');
    String discountType = 'FLAT';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _cardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Create Promo Coupon',
              style: TextStyle(color: Colors.white, fontSize: 17)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: minAxisSizeMin,
              children: [
                TextField(
                  controller: codeCtrl,
                  style: const TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Coupon Code (e.g. FLASH50)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Offer Description',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: discountType,
                        dropdownColor: _cardBg,
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(
                              value: 'FLAT', child: Text('Flat (₹)')),
                          DropdownMenuItem(
                              value: 'PERCENTAGE', child: Text('Percent (%)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => discountType = val);
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: 'Type',
                            labelStyle: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: valueCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Discount',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: minOrderCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Min. Order Value (₹)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (codeCtrl.text.trim().isEmpty) return;
                final provider = context.read<AdminMarketingProvider>();
                await provider.addCoupon({
                  'code': codeCtrl.text.trim().toUpperCase(),
                  'description': descCtrl.text.trim(),
                  'discountType': discountType,
                  'discountValue': double.tryParse(valueCtrl.text) ?? 50.0,
                  'minOrderValue': double.tryParse(minOrderCtrl.text) ?? 199.0,
                });
                if (ctx.mounted) Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Coupon'),
            ),
          ],
        ),
      ),
    );
  }

  static const MainAxisSize minAxisSizeMin = MainAxisSize.min;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminMarketingProvider>();

    return Scaffold(
      backgroundColor: _surfaceDark,
      appBar: AppBar(
        backgroundColor: _surfaceDark,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Marketing & Growth Hub',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: provider.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.refresh_rounded, color: Colors.white70),
            onPressed: () => provider.loadMarketingData(),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _primaryGreen,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.campaign_rounded), text: 'Daily Messages'),
            Tab(
                icon: Icon(Icons.local_offer_rounded),
                text: 'Coupons & Vouchers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyMessagesTab(provider),
          _buildCouponsTab(provider),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(_tabController.index == 0 ? 'New Campaign' : 'New Coupon'),
        onPressed: () {
          if (_tabController.index == 0) {
            _openCreateCampaignModal();
          } else {
            _openAddCouponDialog();
          }
        },
      ),
    );
  }

  Widget _buildDailyMessagesTab(AdminMarketingProvider provider) {
    if (provider.isLoading && provider.campaigns.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: _primaryGreen));
    }

    final active = provider.activeCampaign;

    return RefreshIndicator(
      onRefresh: () => provider.loadMarketingData(),
      color: _primaryGreen,
      backgroundColor: _cardBg,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // KPI Metric Bar
          _buildKpiMetrics(provider),
          const SizedBox(height: 16),

          // Quick Action Broadcast Banner
          if (active != null) _buildBroadcastActionCard(active, provider),
          const SizedBox(height: 16),

          // Filter by Audience
          Row(
            children: [
              const Text(
                'Campaign History',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _buildFilterChip('ALL', 'All', provider),
              const SizedBox(width: 6),
              _buildFilterChip('CUSTOMER', 'Customers', provider),
              const SizedBox(width: 6),
              _buildFilterChip('VIP', 'VIP', provider),
            ],
          ),
          const SizedBox(height: 12),

          // Campaigns List
          if (provider.campaigns.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.campaign_outlined,
                      color: Colors.white38, size: 48),
                  SizedBox(height: 12),
                  Text('No campaigns found',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          else
            ...provider.campaigns.map((c) => _buildCampaignCard(c, provider)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildKpiMetrics(AdminMarketingProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            'Outbox Dispatched',
            '${(provider.totalDispatchedCount / 1000).toStringAsFixed(1)}k',
            Icons.send_rounded,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            'Active Daily Promo',
            provider.activeCampaign != null ? 'LIVE 🟢' : 'IDLE ⚪',
            Icons.radio_button_checked_rounded,
            const Color(0xFF38BDF8),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            'Total Campaigns',
            '${provider.allCampaigns.length}',
            Icons.layers_rounded,
            const Color(0xFFA855F7),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(
      String label, String value, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderDark.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastActionCard(
      DailyMessageCampaign campaign, AdminMarketingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D9D43).withOpacity(0.25),
            const Color(0xFF0F766E).withOpacity(0.20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _primaryGreen.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'CURRENT ACTIVE MORNING MESSAGE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(
                '${campaign.outboxCount} Dispatched',
                style: const TextStyle(
                    color: Color(0xFF70DD7A),
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            campaign.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            campaign.body,
            style:
                TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _openCreateCampaignModal,
                icon: const Icon(Icons.edit_rounded, size: 16),
                label: const Text('Update Copy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: provider.isDispatching
                    ? null
                    : () => _triggerBroadcast(campaign.id),
                icon: provider.isDispatching
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.bolt_rounded, size: 18),
                label: const Text('Broadcast Now ⚡'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(
      DailyMessageCampaign campaign, AdminMarketingProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: campaign.enabled
              ? _primaryGreen.withOpacity(0.5)
              : _borderDark.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: campaign.enabled
                      ? const Color(0xFF15803D)
                      : const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  campaign.enabled ? 'ACTIVE' : 'INACTIVE',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  campaign.audienceRole,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  campaign.enabled
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  color: campaign.enabled ? _primaryGreen : Colors.white38,
                  size: 30,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => provider.toggleCampaignEnabled(campaign.id),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            campaign.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            campaign.body,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.outbox_rounded,
                  color: Color(0xFF94A3B8), size: 14),
              const SizedBox(width: 4),
              Text(
                '${campaign.outboxCount} Dispatched',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _triggerBroadcast(campaign.id),
                icon: const Icon(Icons.send_rounded,
                    size: 14, color: _primaryGreen),
                label: const Text('Dispatch',
                    style: TextStyle(color: _primaryGreen, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String key, String label, AdminMarketingProvider provider) {
    final isSelected = provider.audienceFilter == key;
    return GestureDetector(
      onTap: () => provider.setAudienceFilter(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? _primaryGreen : _cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _primaryGreen : _borderDark),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCouponsTab(AdminMarketingProvider provider) {
    if (provider.isLoading && provider.coupons.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: _primaryGreen));
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadMarketingData(),
      color: _primaryGreen,
      backgroundColor: _cardBg,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text(
                '${provider.coupons.length} Active Vouchers',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _openAddCouponDialog,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Coupon'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (provider.coupons.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.local_offer_outlined,
                      color: Colors.white38, size: 48),
                  SizedBox(height: 12),
                  Text('No coupons registered',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          else
            ...provider.coupons.map((c) => _buildCouponCard(c, provider)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCouponCard(AdminCoupon coupon, AdminMarketingProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderDark.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.confirmation_number_rounded,
                color: _primaryGreen, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      coupon.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F766E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        coupon.discountDisplay,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent, size: 20),
                      onPressed: () => provider.deleteCoupon(coupon.id),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Min: ₹${coupon.minOrderValue.toInt()}',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${coupon.usageCount} Redemptions',
                      style: const TextStyle(
                          color: Color(0xFF70DD7A),
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
