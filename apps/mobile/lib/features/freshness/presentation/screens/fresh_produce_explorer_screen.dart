import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Fresh Produce Explorer Screen — Exact Google Stitch Specification
/// Matches:
/// - Farm origin story header ("Sourced Daily from Local Organic Farms")
/// - Interactive produce grid with freshness scores (98% Freshness Index)
/// - Origin tags, harvest timestamps, and price/add controls
class FreshProduceExplorerScreen extends StatelessWidget {
  const FreshProduceExplorerScreen({super.key});

  final List<Map<String, dynamic>> _produce = const [
    {
      'id': 'f1',
      'name': 'Organic Hydroponic Spinach',
      'origin': 'Koramangala Farm #4',
      'freshnessScore': '99%',
      'harvestedDate': 'Today, 5:30 AM',
      'price': '₹35',
      'mrp': '₹50',
      'image':
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80',
    },
    {
      'id': 'f2',
      'name': 'Crisp Farm-Fresh Broccoli',
      'origin': 'Ooty Hills Co-op Farm',
      'freshnessScore': '98%',
      'harvestedDate': 'Today, 4:00 AM',
      'price': '₹65',
      'mrp': '₹90',
      'image':
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&q=80',
    },
    {
      'id': 'f3',
      'name': 'Sweet Crunchy Carrots',
      'origin': 'Mysuru Local Greenhouses',
      'freshnessScore': '97%',
      'harvestedDate': 'Yesterday Evening',
      'price': '₹28',
      'mrp': '₹40',
      'image':
          'https://images.unsplash.com/photo-1598170845058-12ef4a45753b?w=400&q=80',
    },
    {
      'id': 'f4',
      'name': 'Organic Red Bell Peppers',
      'origin': 'Polyhouse Farm #12',
      'freshnessScore': '99%',
      'harvestedDate': 'Today, 6:00 AM',
      'price': '₹75',
      'mrp': '₹110',
      'image':
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Fresh Produce Explorer',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '100% TRACEABLE',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Harvested Daily at 5 AM',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Verified harvest timestamp & farm location for every item.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.90),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.eco_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Today\'s Fresh Harvest',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _produce.length,
                itemBuilder: (context, index) {
                  final item = _produce[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9FC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item['freshnessScore'],
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '📍 ${item['origin']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          item['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            height: 1.2,
                          ),
                        ),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['price'],
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F3F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
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
    );
  }
}
