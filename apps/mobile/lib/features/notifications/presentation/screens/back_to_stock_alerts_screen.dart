import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Back to Stock Alerts Screen — Exact Google Stitch Specification
/// Screen ID: 85cd7a7a93e545678e3ebfcc52c37c32
class BackToStockAlertsScreen extends StatefulWidget {
  const BackToStockAlertsScreen({super.key});

  @override
  State<BackToStockAlertsScreen> createState() =>
      _BackToStockAlertsScreenState();
}

class _BackToStockAlertsScreenState extends State<BackToStockAlertsScreen> {
  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 'bs1',
      'name': 'A2 Desi Cow Ghee 500ml',
      'brand': 'Daily Basket Farm Fresh',
      'price': '₹599',
      'mrp': '₹650',
      'status': 'RESTOCKED',
      'time': 'Restocked 10 mins ago',
      'notifyEnabled': true,
      'image':
          'https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400&q=80',
    },
    {
      'id': 'bs2',
      'name': 'Alphonso Mangoes Box (1kg)',
      'brand': 'Devgad Premium',
      'price': '₹299',
      'mrp': '₹399',
      'status': 'OUT_OF_STOCK',
      'time': 'Expected restock today, 4 PM',
      'notifyEnabled': true,
      'image':
          'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
    },
    {
      'id': 'bs3',
      'name': 'Organic Strawberries (250g)',
      'brand': 'Mahabaleshwar Organic',
      'price': '₹140',
      'mrp': '₹180',
      'status': 'OUT_OF_STOCK',
      'time': 'Expected restock tomorrow morning',
      'notifyEnabled': false,
      'image':
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF006B23)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Back to Stock Alerts',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get notified instantly when your out-of-stock favorites return to dark store inventory.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF3F4A3D),
                  ),
                ),
                const SizedBox(height: 20),

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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isRestocked
                              ? const Color(0xFF006B23)
                              : const Color(0xFFE2E2E5),
                          width: isRestocked ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
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
                                  item['image'] as String,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
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
                                            ? const Color(0xFFDCE5DD)
                                            : const Color(0xFFFFDAD6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isRestocked ? 'RESTOCKED' : 'OUT OF STOCK',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isRestocked
                                              ? const Color(0xFF006B23)
                                              : const Color(0xFFBA1A1A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['name'] as String,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1C1E),
                                      ),
                                    ),
                                    Text(
                                      item['time'] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF3F4A3D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(color: Color(0xFFE2E2E5), height: 1),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item['price']} (${item['mrp']})',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF006B23),
                                ),
                              ),
                              if (isRestocked)
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/cart');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006B23),
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
                                        color: const Color(0xFF3F4A3D),
                                      ),
                                    ),
                                    Switch(
                                      value: item['notifyEnabled'] as bool,
                                      activeTrackColor: const Color(0xFF006B23),
                                      onChanged: (val) {
                                        setState(() {
                                          item['notifyEnabled'] = val;
                                        });
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
    );
  }
}
