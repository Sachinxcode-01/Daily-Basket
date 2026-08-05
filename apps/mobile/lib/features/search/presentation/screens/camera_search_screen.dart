import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/permissions/app_permission_service.dart';
import '../../../../core/providers/permissions_provider.dart';
import '../../../../core/providers/visual_search_provider.dart';

class CameraSearchScreen extends StatefulWidget {
  const CameraSearchScreen({super.key});

  @override
  State<CameraSearchScreen> createState() => _CameraSearchScreenState();
}

class _CameraSearchScreenState extends State<CameraSearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  bool _isBarcodeMode = false;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onCapturePressed() async {
    HapticFeedback.mediumImpact();
    final permissionsProvider = context.read<PermissionsProvider>();

    final granted = await permissionsProvider.requestPermissionWithRationale(
      context: context,
      type: PermissionType.camera,
      title: 'Camera Permission Needed',
      icon: '📷',
      description: 'Daily Basket requires camera access to scan product packaging, food labels, and barcodes.',
      benefits: [
        'Recognize grocery packaging & brand logos',
        'Scan barcodes & QR codes instantly',
        'Auto-find items in stock near you',
      ],
      confirmText: 'Allow Camera',
      cancelText: 'Cancel',
    );

    if (!granted || !mounted) return;

    final provider = context.read<VisualSearchProvider>();
    if (_isBarcodeMode) {
      await provider.searchBarcode('8901058002102');
    } else {
      await provider.analyzeImage('captured_camera_frame.jpg');
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/visual-search-results');
    }
  }

  void _onPickGalleryImage() async {
    HapticFeedback.lightImpact();
    final permissionsProvider = context.read<PermissionsProvider>();

    final granted = await permissionsProvider.requestPermissionWithRationale(
      context: context,
      type: PermissionType.gallery,
      title: 'Gallery Permission Needed',
      icon: '🖼️',
      description: 'Daily Basket needs gallery access to upload saved photos of product packaging.',
      benefits: ['Select saved grocery product photos', 'Search from screenshot or receipt'],
      confirmText: 'Allow Access',
      cancelText: 'Cancel',
    );

    if (!granted || !mounted) return;

    final provider = context.read<VisualSearchProvider>();
    await provider.analyzeImage('gallery_picked_image.jpg');

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/visual-search-results');
    }
  }

  void _showPermissionModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Camera Permission Needed',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Daily Basket needs camera access so you can scan grocery packages, food labels, and barcodes for instant search.',
          style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera permission granted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006B23),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Grant Access', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VisualSearchProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Live Camera Viewport Background
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1542838132-92c53300491e?w=1000&q=80',
              fit: BoxFit.cover,
            ),
          ),

          // Dark Overlay Vignette
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),

          // Central Scanning Frame & Animated Laser Line
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF006B23), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF006B23).withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated Scanning Laser Line
                  AnimatedBuilder(
                    animation: _scannerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: MediaQuery.of(context).size.height * 0.45 * _scannerAnimation.value,
                        left: 12,
                        right: 12,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, Color(0xFF00FF57), Colors.transparent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FF57).withValues(alpha: 0.8),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Framing Corner Accents
                  const Positioned(
                    top: 12,
                    left: 12,
                    child: Icon(Icons.crop_free_rounded, color: Color(0xFF00FF57), size: 28),
                  ),
                  const Positioned(
                    bottom: 12,
                    right: 12,
                    child: Icon(Icons.crop_free_rounded, color: Color(0xFF00FF57), size: 28),
                  ),

                  // Hint Text Badge
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          _isBarcodeMode
                              ? 'Align barcode inside frame'
                              : 'Point camera at product, box, or packet',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Navigation Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    'AI Visual Search',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        child: IconButton(
                          icon: Icon(
                            provider.flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                            color: provider.flashOn ? const Color(0xFFFFD700) : Colors.white,
                          ),
                          onPressed: () => provider.toggleFlash(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        child: IconButton(
                          icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Control Panel (Shutter & Gallery & Mode Selector)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.black.withValues(alpha: 0.0)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mode Toggle Chips (AI Vision vs Barcode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isBarcodeMode = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isBarcodeMode ? const Color(0xFF006B23) : Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Package & Item',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _isBarcodeMode = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isBarcodeMode ? const Color(0xFF006B23) : Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Barcode / QR',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Shutter Button & Gallery Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery Picker
                      GestureDetector(
                        onTap: _onPickGalleryImage,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gallery',
                              style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),

                      // Main Capture Shutter Button
                      GestureDetector(
                        onTap: _onCapturePressed,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00FF57), width: 4),
                          ),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.center_focus_strong_rounded, color: Color(0xFF006B23), size: 36),
                          ),
                        ),
                      ),

                      // Permission / Settings Trigger
                      GestureDetector(
                        onTap: _showPermissionModal,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.security_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Permissions',
                              style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Analysis Loading Overlay (when analyzing)
          if (provider.status == VisualSearchStatus.analyzing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.85),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFF00FF57), strokeWidth: 3),
                      const SizedBox(height: 20),
                      Text(
                        'Analyzing Product Packaging...',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Extracting brand logo, weight & searching Daily Basket catalog',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
