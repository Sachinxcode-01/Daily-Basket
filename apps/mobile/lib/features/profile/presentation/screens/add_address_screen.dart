import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/address_provider.dart';
import '../widgets/location_permission_dialog.dart';

/// Add Address Screen — Google Stitch Design System Exact Replica
class AddAddressScreen extends StatefulWidget {
  final LocationDataPayload? initialLocationPayload;

  const AddAddressScreen({
    super.key,
    this.initialLocationPayload,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _flatController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _selectedLabel = 'Home';
  String _selectedLocationTitle = '123 Fresh Market St.';
  bool _isLocating = false;

  final List<Map<String, dynamic>> _labelOptions = [
    {'label': 'Home', 'icon': Icons.home_outlined},
    {'label': 'Work', 'icon': Icons.work_outline_rounded},
    {'label': 'Other', 'icon': Icons.location_on_outlined},
    {'label': 'Friends', 'icon': Icons.favorite_border_rounded},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialLocationPayload != null) {
      _applyLocationPayload(widget.initialLocationPayload!);
    } else {
      _streetController.text = '123 Fresh Market St., Sector 4';
    }
  }

  void _applyLocationPayload(LocationDataPayload payload) {
    setState(() {
      _flatController.text = payload.houseFlat;
      _streetController.text = payload.streetArea;
      _landmarkController.text = payload.landmark;
      _selectedLocationTitle = payload.formattedAddress;
    });
  }

  @override
  void dispose() {
    _flatController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _fetchLiveLocationWithPermission() async {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);

    // Step 1: Check / Request Mobile Permission first
    if (!addressProvider.isPermissionGranted) {
      final result = await LocationPermissionDialog.show(context);
      if (result == LocationPermissionState.granted) {
        addressProvider.setPermissionState(LocationPermissionState.granted);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied. You can enter details manually.'),
              backgroundColor: Color(0xFFBA1A1A),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
    }

    // Step 2: Fetch Live Location
    setState(() => _isLocating = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetching live GPS location & reverse geocoding address...'),
          backgroundColor: Color(0xFF006B23),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    final payload = await addressProvider.fetchLiveLocation();
    if (mounted) {
      setState(() => _isLocating = false);
      if (payload != null) {
        _applyLocationPayload(payload);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Live location fetched: ${payload.city}!'),
            backgroundColor: const Color(0xFF006B23),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _saveAddress() {
    if (_streetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter street or area name'),
          backgroundColor: Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final selectedIcon = _labelOptions.firstWhere(
      (opt) => opt['label'] == _selectedLabel,
      orElse: () => _labelOptions.first,
    )['icon'] as IconData;

    final String combinedAddressText = _flatController.text.isNotEmpty
        ? '${_flatController.text.trim()}\n${_streetController.text.trim()}'
        : _streetController.text.trim();

    addressProvider.addAddress({
      'label': _selectedLabel,
      'icon': selectedIcon,
      'isDefault': addressProvider.addresses.isEmpty,
      'addressText': combinedAddressText,
      'houseFlat': _flatController.text.trim(),
      'streetArea': _streetController.text.trim(),
      'landmark': _landmarkController.text.trim(),
    });

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
                      child: CustomPaint(
                        painter: _FullMapPainter(isLocating: _isLocating),
                        child: const SizedBox.expand(),
                      ),
                    ),

                    // Live Location Pill Header Chip
                    Positioned(
                      top: 14,
                      right: 14,
                      child: GestureDetector(
                        onTap: _fetchLiveLocationWithPermission,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF006B23),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isLocating)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                const Icon(Icons.gps_fixed_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _isLocating ? 'Locating...' : 'Use Live GPS',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Center Location Green Pin Marker
                    Center(
                      child: Container(
                        width: 42,
                        height: 42,
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
                            width: 14,
                            height: 14,
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
                                    _selectedLocationTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _fetchLiveLocationWithPermission,
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              icon: const Icon(Icons.my_location_rounded, size: 16, color: Color(0xFF006B23)),
                              label: Text(
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

                        const SizedBox(height: 16),

                        // Save Address As (Label Selection)
                        _buildInputLabel('Save Address As'),
                        const SizedBox(height: 8),
                        Row(
                          children: _labelOptions.map((opt) {
                            final String label = opt['label'] as String;
                            final IconData icon = opt['icon'] as IconData;
                            final bool isSelected = label == _selectedLabel;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(label),
                                avatar: Icon(
                                  icon,
                                  size: 16,
                                  color: isSelected ? Colors.white : const Color(0xFF006B23),
                                ),
                                selected: isSelected,
                                selectedColor: const Color(0xFF006B23),
                                backgroundColor: const Color(0xFFF3F3F6),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide.none,
                                ),
                                onSelected: (_) {
                                  setState(() => _selectedLabel = label);
                                },
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 18),

                        // Field 1: House / Flat / Block No.
                        _buildInputLabel('House / Flat / Block No.'),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _flatController,
                          hintText: 'e.g. Apt 4B, 3rd Floor',
                        ),

                        const SizedBox(height: 18),

                        // Field 2: Street / Area
                        _buildInputLabel('Street / Area'),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _streetController,
                          hintText: 'Enter street or area name',
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
                          hintText: 'e.g. Near Metro Station / Central Park',
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
  final bool isLocating;
  const _FullMapPainter({this.isLocating = false});

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

    if (isLocating) {
      final pulsePaint = Paint()
        ..color = const Color(0xFF006B23).withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 40, pulsePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FullMapPainter oldDelegate) => oldDelegate.isLocating != isLocating;
}
