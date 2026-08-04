import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Rate Your Delivery Screen — Exact Google Stitch Specification
/// Matches:
/// - Rider avatar card (Ramesh Kumar, 5-star interactive rating)
/// - Compliment chips (Fast Delivery, Polite Rider, Fresh Packing)
/// - Tip selection pills (₹20, ₹30, ₹50, ₹100)
/// - Feedback text area & Submit button
class RateDeliveryScreen extends StatefulWidget {
  const RateDeliveryScreen({super.key});

  @override
  State<RateDeliveryScreen> createState() => _RateDeliveryScreenState();
}

class _RateDeliveryScreenState extends State<RateDeliveryScreen> {
  int _rating = 5;
  int? _selectedTip = 30;
  final List<String> _selectedCompliments = ['Fast Delivery', 'Fresh Packing'];
  final TextEditingController _feedbackCtrl = TextEditingController();

  final List<String> _compliments = const [
    'Fast Delivery',
    'Polite Rider',
    'Fresh Packing',
    'Good Communication',
    'Followed Instructions',
  ];

  final List<int> _tips = const [20, 30, 50, 100];

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _toggleCompliment(String comp) {
    setState(() {
      if (_selectedCompliments.contains(comp)) {
        _selectedCompliments.remove(comp);
      } else {
        _selectedCompliments.add(comp);
      }
    });
  }

  void _handleSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you for your rating!',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.of(context).pop();
  }

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
          'Rate Your Delivery',
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
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.20),
                  ),
                ),
                child: Column(
                  children: [
                    // Rider Info Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'RK',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ramesh Kumar',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  'Delivered Order #ORD-9824 in 8 Mins',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'HOW WAS YOUR EXPERIENCE?',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Interactive Star Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          iconSize: 36,
                          icon: Icon(
                            star <= _rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber.shade700,
                          ),
                          onPressed: () => setState(() => _rating = star),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Compliments
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ADD A COMPLIMENT',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _compliments.map((comp) {
                        final isSelected =
                            _selectedCompliments.contains(comp);
                        return FilterChip(
                          label: Text(comp),
                          selected: isSelected,
                          labelStyle: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                          ),
                          backgroundColor: const Color(0xFFF3F3F6),
                          selectedColor: AppColors.primary,
                          shape: const StadiumBorder(),
                          side: BorderSide.none,
                          onSelected: (selected) => _toggleCompliment(comp),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Tipping Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TIP YOUR RIDER',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '100% goes to rider',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: _tips.map((tip) {
                        final isSelected = _selectedTip == tip;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Center(child: Text('₹$tip')),
                              selected: isSelected,
                              labelStyle: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              ),
                              backgroundColor: Colors.white,
                              selectedColor: const Color(0xFFE8F5E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedTip = selected ? tip : null;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit Feedback',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
