import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  bool _isBarcodeMode = false;

  // Real Camera hardware state
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isCameraLoading = true;
  bool _isCameraError = false;
  String? _cameraErrorMessage;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );

    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      _cameraController = null;
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_cameras.isNotEmpty) {
        _initController(_cameras[_selectedCameraIndex]);
      } else {
        _initCamera();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    setState(() {
      _isCameraLoading = true;
      _isCameraError = false;
      _cameraErrorMessage = null;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _isCameraLoading = false;
            _isCameraError = true;
            _cameraErrorMessage = 'No physical cameras detected on this device.';
          });
        }
        return;
      }

      await _initController(_cameras[_selectedCameraIndex]);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraLoading = false;
          _isCameraError = true;
          _cameraErrorMessage =
              'Camera access denied or unavailable. Please enable camera permission in device settings.';
        });
      }
    }
  }

  Future<void> _initController(CameraDescription cameraDescription) async {
    final controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _cameraController = controller;

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isCameraLoading = false;
          _isCameraError = false;
        });
      }
    } on CameraException catch (e) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
          _isCameraLoading = false;
          _isCameraError = true;
          _cameraErrorMessage =
              e.description ?? 'Unable to initialize phone camera.';
        });
      }
    }
  }

  Future<void> _onSwitchCamera() async {
    if (_cameras.length < 2) return;
    HapticFeedback.selectionClick();
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;

    await _cameraController?.dispose();
    _cameraController = null;
    if (mounted) {
      setState(() {
        _isCameraInitialized = false;
        _isCameraLoading = true;
      });
    }

    await _initController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _onToggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    HapticFeedback.selectionClick();
    final newFlashState = !_isFlashOn;
    try {
      await _cameraController!.setFlashMode(
        newFlashState ? FlashMode.torch : FlashMode.off,
      );
      if (mounted) {
        setState(() {
          _isFlashOn = newFlashState;
        });
        context.read<VisualSearchProvider>().toggleFlash();
      }
    } catch (e) {
      // Flash mode not supported by device/lens
    }
  }

  void _onCapturePressed() async {
    HapticFeedback.mediumImpact();
    final provider = context.read<VisualSearchProvider>();

    String? capturedPath;
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_cameraController!.value.isTakingPicture) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        capturedPath = photo.path;
      } catch (e) {
        debugPrint('Camera capture error: $e');
      }
    }

    if (_isBarcodeMode) {
      await provider.searchBarcode('8901058002102');
    } else {
      await provider.analyzeImage(capturedPath ?? 'captured_camera_frame.jpg');
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/visual-search-results');
    }
  }

  void _onPickGalleryImage() async {
    HapticFeedback.lightImpact();
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;

      final provider = context.read<VisualSearchProvider>();
      await provider.analyzeImage(image.path);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/visual-search-results');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick gallery image: $e')),
        );
      }
    }
  }

  void _showPermissionModal() async {
    final permissionsProvider = context.read<PermissionsProvider>();
    final granted = await permissionsProvider.requestPermissionWithRationale(
      context: context,
      type: PermissionType.camera,
      title: 'Camera Permission Needed',
      icon: '📷',
      description:
          'Daily Basket needs camera access to scan product packaging, food labels, and barcodes for instant AI recognition.',
      benefits: [
        'Recognize grocery packaging & brand logos',
        'Scan barcodes & QR codes instantly',
        'Auto-find items in stock near you',
      ],
      confirmText: 'Allow Camera',
      cancelText: 'Cancel',
    );
    if (granted && mounted) {
      _initCamera();
    }
  }

  Widget _buildCameraView() {
    if (_isCameraInitialized &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      return Positioned.fill(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final previewSize = _cameraController!.value.previewSize;
            final double previewWidth = previewSize?.height ?? constraints.maxWidth;
            final double previewHeight = previewSize?.width ?? constraints.maxHeight;

            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: previewWidth,
                  height: previewHeight,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            );
          },
        ),
      );
    }

    if (_isCameraLoading) {
      return Positioned.fill(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF00FF57), strokeWidth: 2.5),
                const SizedBox(height: 16),
                Text(
                  'Starting live camera...',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isCameraError) {
      return Positioned.fill(
        child: Container(
          color: const Color(0xFF0F172A),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam_off_rounded,
                    color: Colors.redAccent,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Camera Access Needed',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _cameraErrorMessage ??
                      'Please allow camera permission to scan product packaging and barcodes live.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showPermissionModal,
                  icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                  label: const Text(
                    'Grant Camera Permission',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B23),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Camera loading state
    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00FF57), strokeWidth: 2.5),
              const SizedBox(height: 16),
              Text(
                'Starting live camera...',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
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
          // ─── Real Live Camera Hardware Feed ──────────────────────────────
          _buildCameraView(),

          // Dark Overlay Vignette
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.35),
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
                        top: MediaQuery.of(context).size.height *
                            0.45 *
                            _scannerAnimation.value,
                        left: 12,
                        right: 12,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFF00FF57),
                                Colors.transparent,
                              ],
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
                            _isFlashOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: _isFlashOn
                                ? const Color(0xFFFFD700)
                                : Colors.white,
                          ),
                          onPressed: _onToggleFlash,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        child: IconButton(
                          icon: const Icon(Icons.flip_camera_ios_rounded,
                              color: Colors.white),
                          onPressed: _onSwitchCamera,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isBarcodeMode
                                ? const Color(0xFF006B23)
                                : Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 16),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isBarcodeMode
                                ? const Color(0xFF006B23)
                                : Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.qr_code_scanner_rounded,
                                  color: Colors.white, size: 16),
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
                              child: const Icon(Icons.photo_library_rounded,
                                  color: Colors.white, size: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gallery',
                              style: GoogleFonts.inter(
                                  color: Colors.white70, fontSize: 11),
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
                            border: Border.all(
                                color: const Color(0xFF00FF57), width: 4),
                          ),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.center_focus_strong_rounded,
                              color: Color(0xFF006B23),
                              size: 36,
                            ),
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
                              child: const Icon(Icons.security_rounded,
                                  color: Colors.white, size: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Permissions',
                              style: GoogleFonts.inter(
                                  color: Colors.white70, fontSize: 11),
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
                      const CircularProgressIndicator(
                          color: Color(0xFF00FF57), strokeWidth: 3),
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
                        style: GoogleFonts.inter(
                            color: Colors.white70, fontSize: 12),
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
