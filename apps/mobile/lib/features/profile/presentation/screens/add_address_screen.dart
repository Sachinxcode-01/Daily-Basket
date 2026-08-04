import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Add Address Screen — Google Stitch Design System Exact Replica
class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _flatController = TextEditingController();
  final _streetController = TextEditingController(text: '123 Fresh Market St.');
  final _landmarkController = TextEditingController();

  @override
  void dispose() {
    _flatController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address saved successfully!'),
        backgroundColor: Color(0xFF006B23),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Add Address',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1C1E),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // ─── 1. Interactive Map Section (Top Half) ────────────────────
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Map Background View
                    Container(
                      color: const Color(0xFFE5ECE5),
                      child: const CustomPaint(
                        painter: _FullMapPainter(),
                        child: SizedBox.expand(),
                      ),
                    ),

                    // Center Location Green Pin Marker
                    Center(
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Color(0xFF006B23),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Selected Location Floating Banner Card
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Location',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF6E7A6C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '123 Fresh Market...',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Detecting current GPS location...')),
                                );
                              },
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: Text(
                                'Change',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF006B23),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── 2. Form Bottom Sheet Container ──────────────────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag Handle Pill Indicator
                        Center(
                          child: Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Field 1: House / Flat / Block No.
                        _buildInputLabel('House / Flat / Block No.'),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _flatController,
                          hintText: 'e.g. Apt 4B',
                        ),

                        const SizedBox(height: 18),

                        // Field 2: Street / Area
                        _buildInputLabel('Street / Area'),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _streetController,
                          hintText: 'Enter street name',
                        ),

                        const SizedBox(height: 18),

                        // Field 3: Landmark (Optional)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInputLabel('Landmark'),
                            Text(
                              'Optional',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF6E7A6C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _landmarkController,
                          hintText: 'e.g. Near Central Park',
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── 3. Fixed Bottom Primary CTA (Save Address) ─────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B23),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Save Address',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1C1E),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1A1C1E)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _FullMapPainter extends CustomPainter {
  const _FullMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final roadPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.45), streetPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.4, size.height), streetPaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
