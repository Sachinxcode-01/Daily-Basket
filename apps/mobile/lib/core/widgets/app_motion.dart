import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppPageTransitions — Daily Basket Material Motion System
/// Provides consistent, premium page transitions across the app.
///
/// Usage:
///   Navigator.of(context).push(AppPageTransitions.fadeThrough(TargetScreen()));
///   Navigator.of(context).push(AppPageTransitions.sharedAxisX(TargetScreen()));
///   Navigator.of(context).push(AppPageTransitions.sharedAxisY(TargetScreen()));

class AppPageTransitions {
  AppPageTransitions._();

  /// Fade Through — for unrelated pages (e.g., bottom nav switches)
  static PageRouteBuilder fadeThrough(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
        );
        final fadeOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(fadeIn),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0.0).animate(fadeOut),
            child: child,
          ),
        );
      },
    );
  }

  /// Shared Axis X — horizontal slide (e.g., onboarding pages, wizard steps)
  static PageRouteBuilder sharedAxisX(Widget page, {bool reverse = false}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final enterCurve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final exitCurve = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);

        return SlideTransition(
          position: Tween<Offset>(
            begin: reverse ? const Offset(-0.08, 0) : const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(enterCurve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(enterCurve),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: reverse ? const Offset(0.05, 0) : const Offset(-0.05, 0),
              ).animate(exitCurve),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1, end: 0.0).animate(exitCurve),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shared Axis Y — vertical slide (e.g., bottom sheets, detail reveals)
  static PageRouteBuilder sharedAxisY(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final enterCurve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final exitCurve = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(enterCurve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(enterCurve),
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0.0).animate(exitCurve),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// AppPressable — Pressable button wrapper with scale tap feedback and haptics.
/// Wraps any widget to apply premium tap scale animation + haptic feedback.
///
/// Usage:
///   AppPressable(onTap: () {...}, child: Container(...))
class AppPressable extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final double scaleFactor;
  final bool enableHaptics;

  const AppPressable({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.96,
    this.enableHaptics = true,
  });

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    _ctrl.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// TypewriterText — reusable premium typewriter animation widget.
/// Animates text character by character with a blinking cursor.
///
/// Usage:
///   TypewriterText(
///     text: 'Daily Basket',
///     style: GoogleFonts.outfit(fontSize: 48),
///     cursorColor: Color(0xFF34D399),
///   )
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Color? cursorColor;
  final Duration charDuration;
  final Duration cursorBlinkDuration;
  final bool showCursor;

  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.center,
    this.cursorColor,
    this.charDuration = const Duration(milliseconds: 65),
    this.cursorBlinkDuration = const Duration(milliseconds: 530),
    this.showCursor = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  String _displayedText = '';
  bool _typingDone = false;
  late AnimationController _cursorCtrl;

  @override
  void initState() {
    super.initState();
    _cursorCtrl = AnimationController(
      vsync: this,
      duration: widget.cursorBlinkDuration,
    )..repeat(reverse: true);

    _typeText();
  }

  Future<void> _typeText() async {
    for (int i = 0; i <= widget.text.length; i++) {
      if (!mounted) return;
      setState(() => _displayedText = widget.text.substring(0, i));
      await Future.delayed(widget.charDuration);
    }
    if (!mounted) return;
    setState(() => _typingDone = true);
    // Fade cursor out after a short pause
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) _cursorCtrl.stop();
  }

  @override
  void dispose() {
    _cursorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = widget.cursorColor ?? widget.style.color ?? const Color(0xFF059669);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _mainAxisForAlign(widget.textAlign),
      children: [
        Flexible(
          child: Text(
            _displayedText,
            style: widget.style,
            textAlign: widget.textAlign,
          ),
        ),
        if (widget.showCursor && !_typingDone)
          FadeTransition(
            opacity: _cursorCtrl,
            child: Text(
              '|',
              style: widget.style.copyWith(color: cursorColor),
            ),
          ),
      ],
    );
  }

  MainAxisAlignment _mainAxisForAlign(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return MainAxisAlignment.center;
      case TextAlign.right:
      case TextAlign.end:
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.start;
    }
  }
}

/// StaggeredListItem — animates each list item with slide + fade.
/// Great for checklist items, onboarding features, product cards.
class StaggeredListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final int delayMs;

  const StaggeredListItem({
    super.key,
    required this.child,
    required this.index,
    this.delayMs = 120,
  });

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(
      Duration(milliseconds: widget.index * widget.delayMs),
      () { if (mounted) _ctrl.forward(); },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
