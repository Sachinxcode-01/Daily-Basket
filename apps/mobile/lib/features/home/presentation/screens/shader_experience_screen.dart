// Google Stitch Screen ID: f3d6281b6d924aec93f2059b04c17fe1
// Title: Shader
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// Fragment Shader & Fluid Dynamics Motion Shader Screen
class ShaderExperienceScreen extends StatefulWidget {
  static const String stitchId = 'f3d6281b6d924aec93f2059b04c17fe1';
  static const String routeName = '/experience/shader';

  const ShaderExperienceScreen({super.key});

  @override
  State<ShaderExperienceScreen> createState() => _ShaderExperienceScreenState();
}

class _ShaderExperienceScreenState extends State<ShaderExperienceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
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
          'Shader Motion Canvas',
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
                painter: _FluidShaderPainter(time: _controller.value),
                child: Container(),
              );
            },
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF006B23).withAlpha(216),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF8CFA93), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF006B23).withAlpha(102),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 48, color: Color(0xFF8CFA93)),
                  const SizedBox(height: 16),
                  Text(
                    'Fluid Fragment Shader Engine',
                    style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GPU Accelerated Custom Fragment Shaders for Dynamic Fluid Glows & Gradient Wave Animations.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withAlpha(230)),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FluidShaderPainter extends CustomPainter {
  final double time;
  _FluidShaderPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
      center: Alignment(math.sin(time * math.pi * 2) * 0.6, math.cos(time * math.pi * 2) * 0.6),
      radius: 1.2 + math.sin(time * math.pi) * 0.3,
      colors: const [
        Color(0xFF078730),
        Color(0xFF006B23),
        Color(0xFF1A1C1E),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _FluidShaderPainter oldDelegate) => oldDelegate.time != time;
}
