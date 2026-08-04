import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Quick Buy Essentials Screen — Exact Google Stitch Specification
/// Screen ID: 1cd16f49f43e43ffb32b782360095aef
class QuickBuyEssentialsScreen extends StatefulWidget {
  const QuickBuyEssentialsScreen({super.key});

  @override
  State<QuickBuyEssentialsScreen> createState() =>
      _QuickBuyEssentialsScreenState();
}

class _QuickBuyEssentialsScreenState extends State<QuickBuyEssentialsScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 'qb1',
      'name': 'Amul Taaza Toned Milk',
      'weight': '1 L',
      'price': 54,
      'mrp': 54,
      'qty': 1,
      'image':
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
    },
    {
      'id': 'qb2',
      'name': 'Brown Sandwich Bread',
      'weight': '400 g',
      'price': 45,
      'mrp': 50,
      'qty': 1,
      'image':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    },
    {
      'id': 'qb3',
      'name': 'Organic Hass Avocados',
      'weight': '2 units (400g)',
      'price': 120,
      'mrp': 150,
      'qty': 2,
      'image':
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&q=80',
    },
    {
      'id': 'qb4',
      'name': 'Farm Fresh Tomatoes',
      'weight': '500 g',
      'price': 24,
      'mrp': 30,
      'qty': 1,
      'image':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
    },
  ];

  int get _totalCartAmount {
    int sum = 0;
    for (var item in _items) {
      sum += (item['price'] as int) * (item['qty'] as int);
    }
    return sum;
  }

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
          'Quick Buy Essentials',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF006B23),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Staples',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Frequently bought weekly items ready for 1-tap reordering.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF3F4A3D),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Items Grid
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final qty = item['qty'] as int;

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] as String,
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['weight'] as String,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF3F4A3D),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${item['price']}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF006B23),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          if ((item['mrp'] as int) >
                                              (item['price'] as int))
                                            Text(
                                              '₹${item['mrp']}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: const Color(0xFF3F4A3D),
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Quantity Stepper
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCE5DD),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            size: 16, color: Color(0xFF006B23)),
                                        onPressed: () {
                                          if (qty > 0) {
                                            setState(() {
                                              item['qty'] = qty - 1;
                                            });
                                          }
                                        },
                                      ),
                                      Text(
                                        '$qty',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF006B23),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            size: 16, color: Color(0xFF006B23)),
                                        onPressed: () {
                                          setState(() {
                                            item['qty'] = qty + 1;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
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

          // Sticky Bottom Add All Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E2E5))),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006B23),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add All Essentials to Basket',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '₹$_totalCartAmount',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
