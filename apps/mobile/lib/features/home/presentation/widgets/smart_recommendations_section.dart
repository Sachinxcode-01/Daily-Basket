import 'package:flutter/material.dart';

class SmartRecommendationsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>)? onItemTap;
  final Function(Map<String, dynamic>)? onAddToCart;

  const SmartRecommendationsSection({
    super.key,
    this.title = 'AI Smart Recommendations',
    this.subtitle = 'Personalized for your daily household needs',
    required this.items,
    this.onItemTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF059669), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final String name = item['name'] ?? 'Fresh Product';
              final double price = (item['price'] ?? 49).toDouble();
              final double mrp = (item['mrp'] ?? price * 1.2).toDouble();
              final String unit = item['unit'] ?? '1 pack';
              final String imageUrl = item['imageUrl'] ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400';
              final bool isOrganic = item['isOrganic'] ?? false;

              return GestureDetector(
                onTap: () => onItemTap?.call(item),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image & Organic Tag
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 90,
                                color: const Color(0xFFF1F5F9),
                                child: const Icon(Icons.shopping_basket, color: Color(0xFF94A3B8)),
                              ),
                            ),
                          ),
                          if (isOrganic)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF059669),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'ORGANIC',
                                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        unit,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                      const Spacer(),
                      // Price & Add button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹${price.toInt()}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              if (mrp > price)
                                Text(
                                  '₹${mrp.toInt()}',
                                  style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough),
                                ),
                            ],
                          ),
                          InkWell(
                            onTap: () => onAddToCart?.call(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
