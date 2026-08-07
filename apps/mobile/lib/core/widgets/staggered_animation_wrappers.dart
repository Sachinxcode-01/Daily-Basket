import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

export 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Centralized Enterprise Motion Design System for Daily Basket
/// Powered exclusively by flutter_staggered_animations ^1.1.1

/// 1. Single Card Item Stagger Wrapper (ListView)
class AnimatedCardWrapper extends StatelessWidget {
  final int position;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final double verticalOffset;

  const AnimatedCardWrapper({
    super.key,
    required this.position,
    required this.child,
    this.duration,
    this.delay,
    this.verticalOffset = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: duration ?? const Duration(milliseconds: 375),
      delay: delay ?? const Duration(milliseconds: 40),
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          curve: Curves.easeOutCubic,
          child: ScaleAnimation(
            scale: 0.95,
            curve: Curves.easeOutCubic,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 2. Grid Item Stagger Wrapper (GridView)
class AnimatedGridItemWrapper extends StatelessWidget {
  final int position;
  final int columnCount;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final double verticalOffset;

  const AnimatedGridItemWrapper({
    super.key,
    required this.position,
    required this.columnCount,
    required this.child,
    this.duration,
    this.delay,
    this.verticalOffset = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: position,
      columnCount: columnCount,
      duration: duration ?? const Duration(milliseconds: 375),
      delay: delay ?? const Duration(milliseconds: 40),
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          curve: Curves.easeOutCubic,
          child: ScaleAnimation(
            scale: 0.95,
            curve: Curves.easeOutCubic,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 3. Section Block Wrapper (Hero banners, Cards, Forms)
class AnimatedSectionWrapper extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final double verticalOffset;

  const AnimatedSectionWrapper({
    super.key,
    required this.child,
    this.duration,
    this.verticalOffset = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: duration ?? const Duration(milliseconds: 400),
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          curve: Curves.easeOutCubic,
          child: child,
        ),
      ),
    );
  }
}

/// 4. List Limiter Wrapper Container
class AnimatedListWrapper extends StatelessWidget {
  final Widget child;

  const AnimatedListWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(child: child);
  }
}

/// 5. Bottom Sheet Entrance Stagger Wrapper
class AnimatedBottomSheetWrapper extends StatelessWidget {
  final Widget child;

  const AnimatedBottomSheetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 350),
      child: SlideAnimation(
        verticalOffset: 60.0,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          curve: Curves.easeOutCubic,
          child: child,
        ),
      ),
    );
  }
}

/// 6. Dialog Entrance Stagger Wrapper
class AnimatedDialogWrapper extends StatelessWidget {
  final Widget child;

  const AnimatedDialogWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 300),
      child: ScaleAnimation(
        scale: 0.9,
        curve: Curves.easeOutCubic,
        child: FadeInAnimation(
          curve: Curves.easeOutCubic,
          child: child,
        ),
      ),
    );
  }
}
