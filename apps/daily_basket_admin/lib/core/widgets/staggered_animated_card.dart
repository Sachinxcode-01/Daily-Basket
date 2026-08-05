import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Reusable Staggered Animated Card widget using `flutter_staggered_animations`
/// combined with interactive hover & tap micro-animations.
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
    this.verticalOffset = 50.0,
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

/// Reusable Staggered Animated Button with interactive tactile feedback.
class StaggeredAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final int index;
  final Duration duration;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;

  const StaggeredAnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.index = 0,
    this.duration = const Duration(milliseconds: 350),
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius,
    this.borderSide,
  });

  @override
  State<StaggeredAnimatedButton> createState() => _StaggeredAnimatedButtonState();
}

class _StaggeredAnimatedButtonState extends State<StaggeredAnimatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    return AnimationConfiguration.staggeredList(
      position: widget.index,
      duration: widget.duration,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                transform: Matrix4.identity()
                  ..scale(_isPressed ? 0.96 : (_isHovered ? 1.03 : 1.0)),
                transformAlignment: Alignment.center,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? const Color(0xFF0F766E),
                  borderRadius: effectiveBorderRadius,
                  border: widget.borderSide != null
                      ? Border.fromBorderSide(widget.borderSide!)
                      : null,
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: (widget.backgroundColor ?? const Color(0xFF0F766E))
                                .withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: widget.foregroundColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.foregroundColor ?? Colors.white,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper wrapper for lists using `AnimationLimiter`
class StaggeredListWrapper extends StatelessWidget {
  final Widget child;

  const StaggeredListWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(child: child);
  }
}
