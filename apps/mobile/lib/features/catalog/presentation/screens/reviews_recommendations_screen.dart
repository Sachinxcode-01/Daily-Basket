import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Reviews & Recommendations Screen — Google Stitch Specification (ID: c6a5b7dc5a8c45249003dc69571be238)
/// Features rating breakdown chart (4.8 rating), verified buyer photo gallery (+42 photos), review cards, and recommendations.
class ReviewsRecommendationsScreen extends StatelessWidget {
  const ReviewsRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reviews & Rating',
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Rating Overview & Breakdown Card (Stitch Spec)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Average Rating Summary
                    Column(
                      children: [
                        Text(
                          '4.8',
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1,284 Reviews',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 20),
                    const SizedBox(
                      height: 70,
                      child: VerticalDivider(color: Color(0xFFE2E8F0)),
                    ),
                    const SizedBox(width: 16),

                    // Star Breakdown Bar Chart
                    Expanded(
                      child: Column(
                        children: [
                          _buildStarRow(5, 0.85, '1,090'),
                          _buildStarRow(4, 0.10, '128'),
                          _buildStarRow(3, 0.03, '38'),
                          _buildStarRow(2, 0.01, '12'),
                          _buildStarRow(1, 0.01, '16'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Verified Buyer Photo Gallery ("+42" Media Overlay - Stitch Spec)
              Text(
                'Photos from Verified Buyers',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildGalleryThumb('https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300'),
                    _buildGalleryThumb('https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300'),
                    _buildGalleryThumb('https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=300'),
                    _buildGalleryThumb('https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300'),
                    // +42 Overlay Thumbnail
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '+42',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Customer Reviews List
              Text(
                'Customer Reviews (1,284)',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              _buildReviewCard(
                name: 'Jane Doe',
                verified: true,
                time: '2 days ago',
                rating: 5,
                title: 'Perfectly ripe upon arrival',
                body: 'These avocados were exactly what I was hoping for. Firm but yielded slightly to gentle pressure. Perfect for my morning toast!',
              ),

              const SizedBox(height: 12),

              _buildReviewCard(
                name: 'Rahul Sharma',
                verified: true,
                time: '4 days ago',
                rating: 5,
                title: 'Great quality organic produce',
                body: 'Super fresh, creamy texture and delivered in just 10 minutes. Will definitely reorder!',
              ),

              const SizedBox(height: 24),

              // 4. Frequently Bought Together / Recommendations Carousel
              Text(
                'Frequently Bought Together',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductCard(
                      name: 'Organic Lime (250g)',
                      price: '₹35',
                      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300',
                    ),
                    _buildProductCard(
                      name: 'Fresh Coriander (100g)',
                      price: '₹18',
                      imageUrl: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=300',
                    ),
                    _buildProductCard(
                      name: 'Extra Virgin Avocado Oil',
                      price: '₹380',
                      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRow(int stars, double pct, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text('$stars ★', style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant)),
          const SizedBox(width: 6),
          Expanded(
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: const Color(0xFFF1F5F9),
              color: Colors.amber,
              minHeight: 4,
            ),
          ),
          const SizedBox(width: 6),
          Text(count, style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildGalleryThumb(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AppNetworkImage(
          imageUrl: url,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required bool verified,
    required String time,
    required int rating,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  name[0],
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                      if (verified) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Verified Buyer',
                            style: GoogleFonts.inter(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(time, style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant)),
                ],
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  rating,
                  (_) => const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            body,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({required String name, required String price, required String imageUrl}) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: AppNetworkImage(
              imageUrl: imageUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
