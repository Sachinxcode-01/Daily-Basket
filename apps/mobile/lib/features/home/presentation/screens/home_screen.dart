import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final Map<String, int> _cartItems = {};

  void _updateQuantity(String id, int delta) {
    setState(() {
      final current = _cartItems[id] ?? 0;
      final updated = current + delta;
      if (updated <= 0) {
        _cartItems.remove(id);
      } else {
        _cartItems[id] = updated;
      }
    });
  }

  int get _totalCartCount => _cartItems.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Top Header with Delivery Badge & Address
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.bolt, color: Color(0xFF10B981), size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '10 MINS',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFF1E293B),
                              child: Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Text(
                              'Delivery to ',
                              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                            ),
                            Icon(Icons.location_on, color: Color(0xFF10B981), size: 14),
                            SizedBox(width: 2),
                            Text(
                              'Koramangala 4th Block',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Search "tomatoes", "milk", "bread"...',
                                    hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Icon(Icons.mic, color: Color(0xFF10B981), size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero Banner
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF047857), Color(0xFF065F46)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF047857).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA3E635),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'FLASH SALE 40% OFF',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Farm Fresh Vegetables',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Delivered to your kitchen in 10 minutes.',
                          style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // Flash Deals Header
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      '⚡ 10-Min Flash Deals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Flash Deals Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildProductCard('p1', 'Organic Farm Tomatoes', '500g', '₹24', '₹40'),
                      _buildProductCard('p2', 'Amul Fresh Toned Milk', '1 Litre', '₹54', '₹56'),
                      _buildProductCard('p3', 'Brown Sandwich Bread', '400g', '₹45', '₹50'),
                      _buildProductCard('p4', 'Alphonso Mangoes', '1 kg', '₹299', '₹450'),
                    ]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // Floating Cart Summary Bar
            if (_totalCartCount > 0)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF059669).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFF10B981),
                            child: Text(
                              '$_totalCartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Items Added',
                                style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 11),
                              ),
                              Text(
                                'Instant 10-Min Delivery',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('View Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String id, String title, String unit, String price, String mrp) {
    final qty = _cartItems[id] ?? 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.shopping_bag, size: 44, color: Color(0xFF10B981)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(unit, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w800, fontSize: 14),
              ),
              if (qty == 0)
                InkWell(
                  onTap: () => _updateQuantity(id, 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      border: Border.all(color: const Color(0xFF10B981)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '+ ADD',
                      style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                      onPressed: () => _updateQuantity(id, -1),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    Text('$qty', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      onPressed: () => _updateQuantity(id, 1),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
