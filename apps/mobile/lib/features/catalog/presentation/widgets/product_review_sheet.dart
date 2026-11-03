import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/reviews_service.dart';
import '../../../../core/theme/app_theme.dart';

/// Product Review & Rating Bottom Sheet Modal
/// Conforms to design.md tokens:
/// - 24px top sheet radius
/// - Outfit headers & Inter body text
/// - Dynamic 1-5 star rating with sentiment labels
/// - Quick feedback tag pills (multi-select)
/// - Submits directly to NestJS POST /api/v1/reviews
/// - Complete Dark Mode & Light Mode support
class ProductReviewSheet extends StatefulWidget {
  final String productId;
  final String productName;
  final String? brand;
  final String? imageUrl;
  final ReviewsService? reviewsService;

  const ProductReviewSheet({
    super.key,
    required this.productId,
    required this.productName,
    this.brand,
    this.imageUrl,
    this.reviewsService,
  });

  /// Helper to display bottom sheet modal
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required String productId,
    required String productName,
    String? brand,
    String? imageUrl,
    ReviewsService? reviewsService,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProductReviewSheet(
        productId: productId,
        productName: productName,
        brand: brand,
        imageUrl: imageUrl,
        reviewsService: reviewsService,
      ),
    );
  }

  @override
  State<ProductReviewSheet> createState() => _ProductReviewSheetState();
}

class _ProductReviewSheetState extends State<ProductReviewSheet> {
  late final ReviewsService _service;
  int _rating = 5;
  final Set<String> _selectedTags = {};
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  static const List<String> _quickTags = [
    'Crisp & Fresh 🌿',
    'Lightning Fast ⚡',
    'Great Packaging 📦',
    'Super Sweet & Ripe 🥑',
    'Value for Money 💰',
    '100% Organic 🌾',
  ];

  static const Map<int, String> _ratingLabels = {
    1: 'Needs Improvement',
    2: 'Fair Quality',
    3: 'Good Product',
    4: 'Very Fresh & Good',
    5: 'Excellent! Loved It 🎉',
  };

  @override
  void initState() {
    super.initState();
    _service = widget.reviewsService ?? ReviewsService();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final res = await _service.submitReview(
      productId: widget.productId,
      rating: _rating,
      comment: _commentController.text.trim(),
      tags: _selectedTags.toList(),
    );

    if (!mounted) return;

    if (res['success'] == true) {
      Navigator.of(context).pop({
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'tags': _selectedTags.toList(),
        'review': res['review'],
      });
    } else {
      setState(() {
        _isSubmitting = false;
        _errorMessage =
            res['error']?.toString() ?? 'Could not submit review. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E2124) : Colors.white;
    final cardBg = isDark ? const Color(0xFF282B30) : const Color(0xFFF9F9FC);
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE2E2E5);
    final textPrimary = isDark ? Colors.white : const Color(0xFF191C1E);
    final textSecondary = isDark ? const Color(0xFFB0B3B8) : const Color(0xFF3F4A3D);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag pill
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : const Color(0xFFD0D3D6),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.rate_review_rounded,
                        color: Colors.amber,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate & Review',
                            style: GoogleFonts.outfit(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            widget.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      icon: Icon(Icons.close_rounded, color: textSecondary),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Star Rating Picker
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          final isSelected = star <= _rating;
                          return IconButton(
                            iconSize: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            icon: Icon(
                              isSelected
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: isSelected ? Colors.amber : Colors.grey.shade400,
                            ),
                            onPressed: () => setState(() => _rating = star),
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _ratingLabels[_rating] ?? 'Rating',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Quick Tag Chips
                Text(
                  'What did you like the most?',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(tag),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : textPrimary,
                      ),
                      backgroundColor: cardBg,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : borderColor,
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Detailed Comments
                Text(
                  'Your Experience',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                  decoration: InputDecoration(
                    hintText:
                        'Tell other shoppers about the freshness, taste, and packaging...',
                    hintStyle:
                        GoogleFonts.inter(fontSize: 12, color: textSecondary),
                    filled: true,
                    fillColor: cardBg,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFBA1A1A),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      _isSubmitting ? 'Submitting...' : 'Submit Verified Review',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
