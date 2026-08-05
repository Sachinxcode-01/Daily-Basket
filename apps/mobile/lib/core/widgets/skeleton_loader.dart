import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Production-grade shimmer skeleton loader.
///
/// Usage:
/// ```dart
/// SkeletonLoader(width: 160, height: 220)                       // generic rect
/// SkeletonLoader.productCard()                                   // product card
/// SkeletonLoader.listTile()                                      // list item
/// SkeletonLoader.banner()                                        // hero banner
/// SkeletonLoader.circle(size: 44)                               // avatar/icon
/// ```
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.margin,
  });

  /// Pre-built product card skeleton (matches home/search card dimensions)
  factory SkeletonLoader.productCard({Key? key}) {
    return SkeletonLoader(
      key: key,
      width: 160,
      height: 220,
      borderRadius: 16,
      margin: const EdgeInsets.only(right: 12),
    );
  }

  /// Pre-built list tile skeleton
  factory SkeletonLoader.listTile({Key? key}) {
    return SkeletonLoader(
      key: key,
      width: double.infinity,
      height: 80,
      borderRadius: 12,
      margin: const EdgeInsets.only(bottom: 10),
    );
  }

  /// Pre-built hero banner skeleton
  factory SkeletonLoader.banner({Key? key}) {
    return SkeletonLoader(
      key: key,
      width: double.infinity,
      height: 180,
      borderRadius: 20,
    );
  }

  /// Pre-built circle avatar/icon skeleton
  factory SkeletonLoader.circle({Key? key, double size = 44}) {
    return SkeletonLoader(
      key: key,
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_anim.value - 1, 0),
              end: Alignment(_anim.value + 1, 0),
              colors: const [
                Color(0xFFE8EBE8),
                Color(0xFFF3F5F3),
                Color(0xFFE8EBE8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ─── Composite Skeletons ───────────────────────────────────────────────────────

/// A row of [count] product card skeletons in a horizontal ListView
class SkeletonProductRow extends StatelessWidget {
  final int count;
  const SkeletonProductRow({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 224,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        itemBuilder: (_, i) => SkeletonLoader.productCard(),
      ),
    );
  }
}

/// A column of [count] list tile skeletons
class SkeletonListTiles extends StatelessWidget {
  final int count;
  const SkeletonListTiles({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(count, (i) {
          // Vary widths slightly for realistic look
          final widthFactor = 0.6 + (math.sin(i * 1.7) * 0.2);
          return Row(
            children: [
              SkeletonLoader.circle(size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                      width: MediaQuery.of(context).size.width * widthFactor,
                      height: 14,
                      borderRadius: 6,
                    ),
                    const SizedBox(height: 6),
                    SkeletonLoader(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 11,
                      borderRadius: 5,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Full home feed skeleton (banner + section headers + product rows)
class SkeletonHomeFeed extends StatelessWidget {
  const SkeletonHomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader.banner(),
            const SizedBox(height: 20),
            const SkeletonLoader(width: 140, height: 18, borderRadius: 6),
            const SizedBox(height: 12),
            const SkeletonProductRow(count: 4),
            const SizedBox(height: 20),
            const SkeletonLoader(width: 120, height: 18, borderRadius: 6),
            const SizedBox(height: 12),
            const SkeletonProductRow(count: 4),
          ],
        ),
      ),
    );
  }
}
