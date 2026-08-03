import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Coupon Details Modal Bottom Sheet — Google Stitch Design System Exact Replica
class CouponDetailsSheet extends StatefulWidget {
  final String title;
  final String discountTag;
  final String code;
  final String description;
  final String heroImageUrl;
  final List<String> steps;

  const CouponDetailsSheet({
    super.key,
    this.title = 'Organic Staples Promo',
    this.discountTag = '15% OFF',
    this.code = 'ORGANIC15',
    this.description = 'Valid on all organic pulses and grains above \$50. Maximum discount up to \$15.',
    this.heroImageUrl = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&q=80',
    this.steps = const [
      'Add eligible organic items totaling over \$50 to your cart.',
      'Go to the checkout screen to review your order summary.',
      'The code will be auto-applied or you can enter it manually.',
    ],
  });

  @override
  State<CouponDetailsSheet> createState() => _CouponDetailsSheetState();
}

class _CouponDetailsSheetState extends State<CouponDetailsSheet> {
  bool _isCopied = false;

  void _copyCode() {
    setState(() {
      _isCopied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon code ${widget.code} copied to clipboard!'),
        backgroundColor: const Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Top Drag Handle Indicator
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE5DD),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── 1. Header (Logo + Title + Discount Badge + Close) ─────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Basket Logo Container
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                    ),
                    child: Image.asset(
                      'assets/images/daily_basket_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.shopping_basket_rounded,
                        color: Color(0xFF006B23),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & High-Visibility Discount Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8CFA93),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            widget.discountTag,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF00531A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Icon Button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF1A1C1E), size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ─── 2. Visual Context Hero Image Banner ───────────────────────
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          widget.heroImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFE8F5E9),
                            child: const Icon(Icons.eco_rounded, size: 64, color: Color(0xFF006B23)),
                          ),
                        ),
                      ),

                      // Gradient Overlay with Description Copy
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.75),
                              ],
                            ),
                          ),
                          child: Text(
                            widget.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 18 / 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── 3. Copy-to-Clipboard Coupon Code Card ─────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COUPON CODE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: const Color(0xFF6E7A6C),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.code,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _copyCode,
                      child: Row(
                        children: [
                          Icon(
                            _isCopied ? Icons.check_circle_rounded : Icons.copy_rounded,
                            color: const Color(0xFF006B23),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isCopied ? 'Copied!' : 'Copy Code',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF006B23),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ─── 4. Step-by-Step Guidance Section ("How to use") ───────────
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFF006B23), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'How to use',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1C1E),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Column(
                children: List.generate(widget.steps.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00531A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            widget.steps[index],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              height: 18 / 13,
                              color: const Color(0xFF3F4A3D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // ─── 5. Shop Now Primary CTA Button ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B23),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Shop Now',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to display the Coupon Details Bottom Sheet Modal
void showCouponDetailsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CouponDetailsSheet(),
  );
}
