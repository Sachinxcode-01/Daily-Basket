import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated Checkout Progress Bar Component
class AnimatedCheckoutProgress extends StatelessWidget {
  final int currentStep; // 0: Basket, 1: Address, 2: Payment, 3: Confirmation

  const AnimatedCheckoutProgress({
    super.key,
    required this.currentStep,
  });

  static const _steps = [
    ('Basket', Icons.shopping_basket_outlined),
    ('Address', Icons.location_on_outlined),
    ('Payment', Icons.payment_outlined),
    ('Done', Icons.check_circle_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          final step = _steps[index];

          final color = isCompleted
              ? const Color(0xFF006B23)
              : isCurrent
                  ? const Color(0xFF006B23)
                  : const Color(0xFF94A3B8);

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFF006B23)
                              : isCurrent
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF006B23)
                                : isCompleted
                                    ? const Color(0xFF006B23)
                                    : const Color(0xFFCBD5E1),
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          isCompleted ? Icons.check_rounded : step.$2,
                          size: 18,
                          color: isCompleted
                              ? Colors.white
                              : isCurrent
                                  ? const Color(0xFF006B23)
                                  : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.$1,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isCurrent || isCompleted ? FontWeight.w600 : FontWeight.w400,
                          color: color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < _steps.length - 1)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        color: index < currentStep
                            ? const Color(0xFF006B23)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
