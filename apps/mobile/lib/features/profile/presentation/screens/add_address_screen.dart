import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/address_provider.dart';

/// Add / Edit Delivery Address Screen
/// Google Stitch Screen ID: 2743ef4c5bb54d7294444b23f082597e
/// Source of Truth: Daily Basket Quick-Commerce Suite
class AddAddressScreen extends StatefulWidget {
  final LocationDataPayload? initialLocationPayload;
  final Map<String, dynamic>? editAddressData;

  const AddAddressScreen({
    super.key,
    this.initialLocationPayload,
    this.editAddressData,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _houseController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _addressType = 'Home';
  bool _isLocating = false;
  bool _isSaving = false;

  // Single Kirana Store Serviceable PINs
  final Set<String> _serviceablePins = {
    '560038', // Indiranagar
    '560008', // Ulsoor / Halasuru
    '560075', // CV Raman Nagar
    '560103', // Bellandur / ORR
    '560001', // MG Road
  };

  bool get _isPinValid => _pincodeController.text.trim().length == 6;
  bool get _isPinServiceable => _serviceablePins.contains(_pincodeController.text.trim());

  @override
  void initState() {
    super.initState();
    if (widget.editAddressData != null) {
      final d = widget.editAddressData!;
      _fullNameController.text = d['fullName'] ?? 'Rahul Sharma';
      _mobileController.text = d['phone'] ?? '9876543210';
      _pincodeController.text = d['pincode'] ?? '560038';
      _cityController.text = d['city'] ?? 'Bengaluru';
      _houseController.text = d['houseFlat'] ?? '';
      _areaController.text = d['streetArea'] ?? d['addressText'] ?? '';
      _landmarkController.text = d['landmark'] ?? '';
      _addressType = d['label'] ?? 'Home';
    } else if (widget.initialLocationPayload != null) {
      final p = widget.initialLocationPayload!;
      _houseController.text = p.houseFlat;
      _areaController.text = p.streetArea;
      _landmarkController.text = p.landmark;
      _pincodeController.text = p.pincode.isNotEmpty ? p.pincode : '560038';
      _cityController.text = p.city.isNotEmpty ? p.city : 'Bengaluru';
    } else {
      _fullNameController.text = 'Rahul Sharma';
      _mobileController.text = '9876543210';
      _pincodeController.text = '560038';
      _houseController.text = 'B-14, Ground Floor';
      _areaController.text = '100ft Road, Indiranagar';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _handleUseCurrentLocation() async {
    setState(() => _isLocating = true);
    final addressProvider = context.read<AddressProvider>();
    addressProvider.setPermissionState(LocationPermissionState.granted);

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isLocating = false;
        _pincodeController.text = '560038';
        _cityController.text = 'Bengaluru';
        _areaController.text = 'Indiranagar 100ft Road';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS Location verified: Indiranagar, Bengaluru 560038 (In Range)'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleSaveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isPinServiceable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN Code ${_pincodeController.text} is outside Daily Basket 10-Min Kirana delivery zone.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final newAddress = {
      'id': widget.editAddressData?['id'] ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
      'label': _addressType,
      'fullName': _fullNameController.text.trim(),
      'phone': '+91 ${_mobileController.text.trim()}',
      'houseFlat': _houseController.text.trim(),
      'streetArea': _areaController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'city': _cityController.text.trim(),
      'landmark': _landmarkController.text.trim(),
      'addressText': '${_houseController.text.trim()}, ${_areaController.text.trim()}, ${_cityController.text.trim()} - ${_pincodeController.text.trim()}',
      'inRange': true,
    };

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delivery address saved as $_addressType!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.editAddressData != null ? 'Edit Address' : 'Add Address',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Map Preview Section ─────────────────────────────
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceVariant),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              // Map style background
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: const Color(0xFFF1F8F4),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.2,
                                      child: GridView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                        ),
                                        itemCount: 18,
                                        itemBuilder: (_, __) => Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColors.primary, width: 0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: AppColors.primary,
                                          size: 36,
                                        ),
                                        Text(
                                          'Indiranagar, Bengaluru',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Use Current Location CTA button
                              Positioned(
                                bottom: 12,
                                left: 16,
                                right: 16,
                                child: InkWell(
                                  onTap: _isLocating ? null : _handleUseCurrentLocation,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.surfaceVariant),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _isLocating
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.my_location,
                                                size: 18,
                                                color: AppColors.primary,
                                              ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isLocating ? 'Locating...' : 'Use Current Location',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ─── Serviceability Status ───────────────────────────
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.secondaryContainer),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Within Delivery Range',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'This location is served by your local Daily Basket store.',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ─── Contact Details ─────────────────────────────────
                        Text(
                          'Contact Details',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'FULL NAME',
                          controller: _fullNameController,
                          placeholder: 'Rahul Sharma',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter full name' : null,
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'MOBILE NUMBER',
                          controller: _mobileController,
                          placeholder: '98765 43210',
                          prefixText: '+91 ',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter mobile number';
                            if (v.trim().length != 10) return 'Must be 10 digits';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // ─── Address Details ─────────────────────────────────
                        Text(
                          'Address',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildCardField(
                                label: 'PINCODE',
                                controller: _pincodeController,
                                placeholder: '560038',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                onChanged: (_) => setState(() {}),
                                suffixIcon: _isPinValid
                                    ? const Icon(Icons.check, size: 18, color: AppColors.primary)
                                    : null,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Required';
                                  if (v.trim().length != 6) return '6 digits';
                                  if (!_serviceablePins.contains(v.trim())) return 'Out of zone';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCardField(
                                label: 'CITY',
                                controller: _cityController,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'HOUSE / FLAT / BLOCK NO.',
                          controller: _houseController,
                          placeholder: 'e.g. B-14, Ground Floor',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter house/flat details' : null,
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'APARTMENT / ROAD / AREA',
                          controller: _areaController,
                          placeholder: 'e.g. Indiranagar 100ft Road',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter street / area' : null,
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'LANDMARK (OPTIONAL)',
                          controller: _landmarkController,
                          placeholder: 'e.g. Near Mother Dairy',
                        ),
                        const SizedBox(height: 24),

                        // ─── Save As Chips ───────────────────────────────────
                        Text(
                          'Save As',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: ['Home', 'Work', 'Other'].map((type) {
                            final isSelected = _addressType == type;
                            final IconData icon = type == 'Home'
                                ? Icons.home_rounded
                                : type == 'Work'
                                    ? Icons.work_rounded
                                    : Icons.location_on_rounded;

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () => setState(() => _addressType = type),
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.secondaryContainer : AppColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primaryContainer : AppColors.surfaceVariant,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        icon,
                                        size: 18,
                                        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        type,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Fixed Bottom Action ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.95),
                border: const Border(
                  top: BorderSide(color: AppColors.surfaceVariant),
                ),
              ),
              child: SafeArea(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSaveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                            )
                          : Text(
                              'Save Address',
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardField({
    required String label,
    required TextEditingController controller,
    String? placeholder,
    String? prefixText,
    Widget? suffixIcon,
    bool readOnly = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (prefixText != null)
                Text(
                  prefixText,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
                ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  validator: validator,
                  onChanged: onChanged,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.surfaceDim),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
        ],
      ),
    );
  }
}
