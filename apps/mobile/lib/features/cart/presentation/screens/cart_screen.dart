import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 10-Min Promise Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, color: Color(0xFF10B981)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('⚡ Instant 10-Minute Delivery', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Hub Store #01 Koramangala', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Cart Items List
              Expanded(
                child: ListView(
                  children: [
                    _buildCartTile('Organic Tomatoes', '500g', '₹24', '₹40'),
                    const SizedBox(height: 12),
                    _buildCartTile('Amul Toned Milk', '1 Litre', '₹54', '₹56'),
                  ],
                ),
              ),
              // Bill Summary Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        Text('₹102', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        Text('FREE', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color: Color(0xFF334155), height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To Pay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('₹102', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w800, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Checkout Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartTile(String name, String unit, String price, String mrp) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.shopping_bag, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(unit, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w800, fontSize: 14)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.remove, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.add, size: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
