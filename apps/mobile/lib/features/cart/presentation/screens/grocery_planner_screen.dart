import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroceryPlannerScreen extends StatefulWidget {
  const GroceryPlannerScreen({super.key});

  @override
  State<GroceryPlannerScreen> createState() => _GroceryPlannerScreenState();
}

class _GroceryPlannerScreenState extends State<GroceryPlannerScreen> {
  final List<Map<String, dynamic>> _lists = [
    {
      'id': 'gl_01',
      'name': 'Weekly Staples Plan',
      'itemCount': 6,
      'isRecurring': true,
      'frequency': 'Every Monday',
      'icon': Icons.calendar_today_rounded,
    },
    {
      'id': 'gl_02',
      'name': 'Monthly Household Stockup',
      'itemCount': 14,
      'isRecurring': true,
      'frequency': '1st of Month',
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'id': 'gl_03',
      'name': 'Weekend Family BBQ & Snacks',
      'itemCount': 5,
      'isRecurring': false,
      'frequency': 'One-time',
      'icon': Icons.outdoor_grill_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Smart Grocery Planner',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.playlist_add_check_circle_outlined, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automated Grocery Reminders',
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Never run out of essentials. AI reminds you before items deplete.',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'YOUR SAVED SHOPPING PLANS',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF64748B), letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),

          ..._lists.map((plan) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(plan['icon'] as IconData, color: const Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan['name'],
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                        ),
                        Text(
                          '${plan['itemCount']} items • ${plan['frequency']}',
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${plan['name']} to basket!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Add All'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateListDialog,
        backgroundColor: const Color(0xFF059669),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('New Shopping List', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  void _showCreateListDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Shopping Plan'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'e.g. Weekly Organic Fruits'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  setState(() {
                    _lists.add({
                      'id': 'gl_${DateTime.now().millisecondsSinceEpoch}',
                      'name': textController.text,
                      'itemCount': 4,
                      'isRecurring': true,
                      'frequency': 'Every Week',
                      'icon': Icons.shopping_basket_outlined,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Create List'),
            ),
          ],
        );
      },
    );
  }
}
