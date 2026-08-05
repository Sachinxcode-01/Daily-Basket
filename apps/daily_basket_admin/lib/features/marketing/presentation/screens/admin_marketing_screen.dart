import 'package:flutter/material.dart';

class AdminMarketingScreen extends StatelessWidget {
  const AdminMarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Marketing & Banner Campaigns', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCampaignTile('Weekend Organic Harvest Sale', 'PUSH & SMS Broadcast', '14.2k Dispatched • 12% Conversion', 'ACTIVE'),
          _buildCampaignTile('Monsoon Dairy Festival', 'In-App Homepage Banner', 'Targeting VIP Segment', 'SCHEDULED'),
          _buildCampaignTile('Flat ₹100 Off Coupon (DAILYFRESH100)', 'Promo Coupon Code', '1.4k Redemptions', 'ACTIVE'),
        ],
      ),
    );
  }

  Widget _buildCampaignTile(String title, String channel, String metrics, String status) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFF0F766E), child: Icon(Icons.campaign_rounded, color: Colors.white)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('$channel\n$metrics', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(8)),
          child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
