import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Micro-Animation Canvas Celebration Widget for Successful Orders
class OrderSuccessCelebration extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const OrderSuccessCelebration({
    super.key,
    this.onAnimationComplete,
  });

  @override
  State<OrderSuccessCelebration> createState() => _OrderSuccessCelebrationState();
}

class _OrderSuccessCelebrationState extends State<OrderSuccessCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    );

    _controller.forward().then((_) {
      if (widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF006B23),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF006B23).withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ScaleTransition(
              scale: _checkAnimation,
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 56,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Order Placed Successfully!',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1C1E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Your kirana items are being packed & prepared for delivery.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6E7A6C),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
