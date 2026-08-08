import 'package:flutter/material.dart';

class AiProductInsightsCard extends StatelessWidget {
  final String productId;
  final String productName;
  final bool isOrganic;
  final Map<String, dynamic>? insightData;

  const AiProductInsightsCard({
    super.key,
    required this.productId,
    required this.productName,
    this.isOrganic = false,
    this.insightData,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = insightData ?? {
      'healthyChoice': isOrganic,
      'healthScore': isOrganic ? 9.6 : 8.8,
      'benefits': [
        '100% Farm Fresh Quality',
        'Rich in essential vitamins & minerals',
        'Zero artificial preservatives',
      ],
      'usage': 'Rinse thoroughly with clean water before cooking or raw consumption.',
      'storage': 'Store in refrigerator at 4°C to retain freshness.',
      'suitableAge': 'All ages (6+ months)',
      'servingSuggestions': 'Pair with fresh garden salad or whole wheat bread.',
      'nutritionalSummary': {
        'calories': '45 kcal',
        'protein': '2.5g',
        'fat': '0.3g',
        'carbs': '8.2g'
      },
      'comparisonPoints': {
        'vsStandard': '2x Higher Vitamin Retention',
        'deliverySpeed': '10-Minute Dark Store Delivery'
      }
    };

    final List<String> benefits = List<String>.from(data['benefits'] ?? []);
    final Map<String, dynamic> nutrition = Map<String, dynamic>.from(data['nutritionalSummary'] ?? {});

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'AI PRODUCT INSIGHTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Color(0xFF059669), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Health Score ${data['healthScore'] ?? '9.0'}/10',
                      style: const TextStyle(
                        color: Color(0xFF047857),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Benefits chips
          const Text(
            'Health & Dietary Benefits',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: benefits.map((b) => Chip(
              avatar: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 14),
              label: Text(b),
              backgroundColor: const Color(0xFFF1F5F9),
              labelStyle: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
          const SizedBox(height: 14),

          // Nutritional Summary Table
          if (nutrition.isNotEmpty) ...[
            const Text(
              'Nutritional Summary (per serving)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: nutrition.entries.map((e) => Column(
                  children: [
                    Text(
                      e.key.toUpperCase(),
                      style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.value.toString(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                )).toList(),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Storage & Usage
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usage & Storage Advice',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${data['storage'] ?? ''} ${data['usage'] ?? ''}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
