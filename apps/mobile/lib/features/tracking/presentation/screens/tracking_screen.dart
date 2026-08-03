import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, this.orderId = 'DB-892104'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text('Track Order #$orderId'),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Live ETA Card
              Container(
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bolt, color: Color(0xFF10B981), size: 16),
                            SizedBox(width: 4),
                            Text('INSTANT DELIVERY', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text('Arriving in 6 Mins', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('Driver Ramesh on the way', style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 12)),
                      ],
                    ),
                    Icon(Icons.timer, color: Colors.white, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Driver Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFF059669),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ramesh Kumar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('KA 01 EB 4821 • ⭐ 4.9', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone, color: Color(0xFF10B981)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.message, color: Color(0xFF94A3B8)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Timeline Steps
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: ListView(
                    children: [
                      const Text('Order Step Timeline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 16),
                      _buildTimelineTile('Order Confirmed', '10:02 PM', true),
                      _buildTimelineTile('Packing at Hub Store #01', '10:04 PM', true),
                      _buildTimelineTile('Out for Delivery', '10:06 PM', true, isCurrent: true),
                      _buildTimelineTile('Delivered at Doorstep', '10:12 PM', false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineTile(String title, String time, bool done, {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: done ? const Color(0xFF10B981) : const Color(0xFF334155),
            child: Icon(
              done ? Icons.check : Icons.circle,
              size: 14,
              color: done ? Colors.white : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isCurrent ? const Color(0xFF10B981) : (done ? Colors.white : const Color(0xFF64748B)),
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          Text(time, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        ],
      ),
    );
  }
}
