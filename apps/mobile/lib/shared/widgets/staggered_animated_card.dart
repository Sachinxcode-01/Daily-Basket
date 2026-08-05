import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Reusable Staggered Animated Card for Customer App
class StaggeredAnimatedCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final double verticalOffset;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool enableHoverEffect;

  const StaggeredAnimatedCard({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 375),
    this.verticalOffset = 40.0,
    this.margin,
    this.onTap,
    this.enableHoverEffect = true,
  });

  @override
  State<StaggeredAnimatedCard> createState() => _StaggeredAnimatedCardState();
}

class _StaggeredAnimatedCardState extends State<StaggeredAnimatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget animatedContent = AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: widget.duration,
      child: SlideAnimation(
        verticalOffset: widget.verticalOffset,
        child: FadeInAnimation(
          child: ScaleAnimation(
            scale: 0.95,
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.enableHoverEffect || widget.onTap != null) {
      animatedContent = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: GestureDetector(
            onTap: widget.onTap,
            child: animatedContent,
          ),
        ),
      );
    }

    if (widget.margin != null) {
      return Padding(padding: widget.margin!, child: animatedContent);
    }

    return animatedContent;
  }
}
