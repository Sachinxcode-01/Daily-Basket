// Google Stitch Screen ID: d1d06e28e5634c7aa4af73eeddcb45cf
// Title: Three.js
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 3D Interactive Three.js Style Canvas Animation Screen
class ThreeJsExperienceScreen extends StatefulWidget {
  static const String stitchId = 'd1d06e28e5634c7aa4af73eeddcb45cf';
  static const String routeName = '/experience/three-js';

  const ThreeJsExperienceScreen({super.key});

  @override
  State<ThreeJsExperienceScreen> createState() => _ThreeJsExperienceScreenState();
}

class _ThreeJsExperienceScreenState extends State<ThreeJsExperienceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Three.js 3D Experience',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ThreeJsCanvasPainter(animationValue: _controller.value),
                child: Container(),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF8CFA93).withAlpha(76)),

                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.view_in_ar, size: 56, color: Color(0xFF8CFA93)),
                      const SizedBox(height: 12),
                      Text(
                        'Interactive 3D Product Canvas',
                        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '360° Hardware Accelerated WebGL/Three.js Renderer',
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeJsCanvasPainter extends CustomPainter {
  final double animationValue;
  _ThreeJsCanvasPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.35;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) + (animationValue * 2 * math.pi);
      final color = HSVColor.fromAHSV(0.6, (i * 30 + animationValue * 360) % 360, 0.8, 0.9).toColor();
      paint.color = color;

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 30 + math.sin(animationValue * math.pi * 2 + i) * 15, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ThreeJsCanvasPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}
