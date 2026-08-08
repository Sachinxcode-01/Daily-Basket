import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreManagementScreen extends StatefulWidget {
  const StoreManagementScreen({super.key});

  @override
  State<StoreManagementScreen> createState() => _StoreManagementScreenState();
}

class _StoreManagementScreenState extends State<StoreManagementScreen> {
  bool _isOpen = true;
  bool _isMaintenance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Store Owner Operations',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Store Open/Close Toggle Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isOpen ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _isOpen ? Icons.storefront : Icons.storefront_outlined,
                            color: _isOpen ? const Color(0xFF059669) : const Color(0xFFEF4444),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOpen ? 'Store is OPEN' : 'Store is CLOSED',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              _isOpen ? 'Accepting customer orders' : 'Orders paused',
                              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _isOpen,
                      activeTrackColor: const Color(0xFF059669),
                      onChanged: (val) {
                        setState(() => _isOpen = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Store status updated to ${_isOpen ? "OPEN" : "CLOSED"}')),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Temporary Maintenance Mode', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                        Text('Pause new orders for restock / cleanup', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                      ],
                    ),
                    Switch(
                      value: _isMaintenance,
                      activeTrackColor: const Color(0xFFF59E0B),
                      onChanged: (val) {
                        setState(() => _isMaintenance = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Daily Summary Metrics
          Text(
            'TODAY\'S STORE OVERVIEW',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Today Revenue', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      Text('₹28,480', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF059669))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Orders Delivered', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      Text('142', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Operational Actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFF2563EB)),
                  title: Text('Low Stock & Expiry Alerts', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('3 items near reorder level', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.local_shipping_outlined, color: Color(0xFF059669)),
                  title: Text('Delivery Partner Attendance', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('8 riders active online', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined, color: Color(0xFFD97706)),
                  title: Text('Execute Daily Financial Closing', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Daily closing executed and ledger locked for today!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
