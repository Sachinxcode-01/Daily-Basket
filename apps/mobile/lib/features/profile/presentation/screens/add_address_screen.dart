import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/pincode_lookup_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/address_provider.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

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

  // Contact Details
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();

  // Postal & Location Details
  final _pincodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');
  final _stateController = TextEditingController(text: 'Karnataka');
  final _districtController = TextEditingController(text: 'Bengaluru');
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _areaController = TextEditingController(text: 'Indiranagar');

  // House & Street Details
  final _houseController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();

  // Preferences & Status
  String _addressType = 'Home';
  bool _isDefault = true;
  bool _isLocating = false;
  bool _isSaving = false;

  // PIN lookup state
  bool _isFetchingPin = false;
  bool _pinFetched = false;
  String? _pinErrorMessage;
  bool _isServiceable = true;
  String _serviceabilityMessage = 'This location is served by your local Daily Basket store.';
  List<String> _availableLocalities = [];
  String? _lastLookupPin;

  @override
  void initState() {
    super.initState();
    if (widget.editAddressData != null) {
      final d = widget.editAddressData!;
      _fullNameController.text = d['fullName'] ?? 'Rahul Sharma';
      _mobileController.text = (d['phone'] ?? '9876543210').toString().replaceAll('+91', '').trim();
      _pincodeController.text = d['pincode'] ?? '560038';
      _countryController.text = d['country'] ?? 'India';
      _stateController.text = d['state'] ?? 'Karnataka';
      _districtController.text = d['district'] ?? 'Bengaluru';
      _cityController.text = d['city'] ?? 'Bengaluru';
      _areaController.text = d['area'] ?? d['streetArea'] ?? '';
      _houseController.text = d['houseFlat'] ?? d['houseNo'] ?? '';
      _streetController.text = d['street'] ?? d['streetArea'] ?? '';
      _landmarkController.text = d['landmark'] ?? '';
      _addressType = d['label'] ?? 'Home';
      _isDefault = d['isDefault'] ?? true;
      _isServiceable = d['isServiceable'] ?? d['inRange'] ?? true;
      _pinFetched = true;
    } else if (widget.initialLocationPayload != null) {
      final p = widget.initialLocationPayload!;
      _houseController.text = p.houseFlat;
      _streetController.text = p.streetArea;
      _areaController.text = p.streetArea;
      _landmarkController.text = p.landmark;
      _pincodeController.text = p.pincode.isNotEmpty ? p.pincode : '560038';
      _cityController.text = p.city.isNotEmpty ? p.city : 'Bengaluru';
      _stateController.text = p.state.isNotEmpty ? p.state : 'Karnataka';
      _districtController.text = p.city.isNotEmpty ? p.city : 'Bengaluru';
      _countryController.text = 'India';
      _isDefault = true;
      _pinFetched = true;
    } else {
      _fullNameController.text = 'Rahul Sharma';
      _mobileController.text = '9876543210';
      _pincodeController.text = '560038';
      _countryController.text = 'India';
      _stateController.text = 'Karnataka';
      _districtController.text = 'Bengaluru';
      _cityController.text = 'Bengaluru';
      _areaController.text = 'Indiranagar';
      _houseController.text = 'B-14, Ground Floor';
      _streetController.text = '100ft Road';
      _isDefault = true;
      _pinFetched = true;
    }

    _lastLookupPin = _pincodeController.text.trim();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _pincodeController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  /// Automatically fetches postal information and checks delivery serviceability
  Future<void> _handlePincodeChanged(String value) async {
    final cleanPin = value.trim();

    // If less than 6 digits, clear status
    if (cleanPin.length < 6) {
      setState(() {
        _isFetchingPin = false;
        _pinErrorMessage = null;
        _pinFetched = false;
      });
      return;
    }

    // Only fetch when exactly 6 digits and different from last queried PIN
    if (cleanPin.length == 6 && cleanPin != _lastLookupPin) {
      if (!PincodeLookupService.isValidPin(cleanPin)) {
        setState(() {
          _pinErrorMessage = 'Invalid PIN code. Must be 6 digits and cannot start with 0.';
          _isServiceable = false;
          _serviceabilityMessage = 'Delivery unavailable: Unrecognized PIN code.';
          _pinFetched = false;
        });
        return;
      }

      _lastLookupPin = cleanPin;
      setState(() {
        _isFetchingPin = true;
        _pinErrorMessage = null;
      });

      final addressProvider = context.read<AddressProvider>();
      final result = await addressProvider.lookupPincode(cleanPin);

      if (!mounted) return;

      if (result.isValid && result.state.isNotEmpty) {
        setState(() {
          _isFetchingPin = false;
          _pinFetched = true;
          _pinErrorMessage = null;
          _countryController.text = result.country.isNotEmpty ? result.country : 'India';
          _stateController.text = result.state;
          _districtController.text = result.district;
          _cityController.text = result.city.isNotEmpty ? result.city : result.district;

          _availableLocalities = result.localities;
          if (_availableLocalities.isNotEmpty) {
            // Select first locality if area is empty or matches previous post office
            _areaController.text = _availableLocalities.first;
          }

          _isServiceable = result.isServiceable;
          _serviceabilityMessage = result.serviceabilityMessage;
        });
      } else {
        setState(() {
          _isFetchingPin = false;
          _pinFetched = false;
          _pinErrorMessage = result.errorMessage ?? 'No postal records found for PIN $cleanPin.';
          _isServiceable = false;
          _serviceabilityMessage = 'Delivery unavailable for this location.';
        });
      }
    }
  }

  Future<void> _handleUseCurrentLocation() async {
    setState(() => _isLocating = true);
    final addressProvider = context.read<AddressProvider>();
    addressProvider.setPermissionState(LocationPermissionState.granted);
    final payload = await addressProvider.fetchLiveLocation();

    if (mounted) {
      setState(() {
        _isLocating = false;
        if (payload != null) {
          _pincodeController.text = payload.pincode;
          _cityController.text = payload.city;
          _stateController.text = payload.state;
          _districtController.text = payload.city;
          _areaController.text = payload.streetArea;
          _streetController.text = payload.streetArea;
          if (_houseController.text.isEmpty) {
            _houseController.text = payload.houseFlat;
          }
          if (_landmarkController.text.isEmpty) {
            _landmarkController.text = payload.landmark;
          }
          _isServiceable = true;
          _pinFetched = true;
          _pinErrorMessage = null;
          _lastLookupPin = payload.pincode;
        }
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

    if (!_isServiceable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN Code ${_pincodeController.text} is outside Daily Basket 10-Min Kirana delivery zone.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final addressProvider = context.read<AddressProvider>();

    final house = _houseController.text.trim();
    final street = _streetController.text.trim();
    final area = _areaController.text.trim();
    final city = _cityController.text.trim();
    final district = _districtController.text.trim();
    final state = _stateController.text.trim();
    final country = _countryController.text.trim();
    final pincode = _pincodeController.text.trim();

    final parts = [
      house,
      street,
      if (area.isNotEmpty && area != street) area,
      city,
      if (district.isNotEmpty && district != city) district,
      if (state.isNotEmpty) state,
      '$pincode, $country',
    ].where((s) => s.isNotEmpty).toList();

    final newAddress = {
      'id': widget.editAddressData?['id'] ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
      'label': _addressType,
      'fullName': _fullNameController.text.trim(),
      'phone': '+91 ${_mobileController.text.trim()}',
      'country': country,
      'state': state,
      'district': district,
      'city': city,
      'area': area,
      'pincode': pincode,
      'houseFlat': house,
      'houseNo': house,
      'streetArea': street,
      'street': street,
      'landmark': _landmarkController.text.trim(),
      'addressText': parts.join(', '),
      'inRange': _isServiceable,
      'isServiceable': _isServiceable,
      'isDefault': _isDefault,
    };

    if (widget.editAddressData != null && widget.editAddressData!['id'] != null) {
      await addressProvider.updateAddress(widget.editAddressData!['id'], newAddress);
    } else {
      await addressProvider.saveAddress(newAddress);
    }

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppNavigationDrawer(isDrawer: true),
      appBar: AppTopBar(
        title: widget.editAddressData != null ? 'Edit Address' : 'Add Address',
        showBack: true,
        showDrawerAction: true,
        showProfile: true,
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 5),
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
                          height: 140,
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
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: const Color(0xFFF1F8F4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_cityController.text.isNotEmpty ? _cityController.text : "Location"}, ${_stateController.text} ${_pincodeController.text}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 16,
                                right: 16,
                                child: InkWell(
                                  onTap: _isLocating ? null : _handleUseCurrentLocation,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                                                width: 14,
                                                height: 14,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.my_location,
                                                size: 16,
                                                color: AppColors.primary,
                                              ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isLocating ? 'Locating...' : 'Use Current Location',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
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

                        // ─── Serviceability Status Banner ────────────────────
                        _buildServiceabilityBanner(),
                        const SizedBox(height: 20),

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

                        // ─── Postal & Location Lookup ─────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Postal Details',
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            if (_isFetchingPin)
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Fetching postal info...',
                                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // PIN Code Field with Auto-Lookup
                        _buildCardField(
                          label: 'PIN CODE (INDIAN 6-DIGIT)',
                          controller: _pincodeController,
                          placeholder: 'e.g. 582103 or 560038',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          onChanged: _handlePincodeChanged,
                          suffixIcon: _isFetchingPin
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                  ),
                                )
                              : _pinFetched
                                  ? const Icon(Icons.check_circle, size: 18, color: AppColors.primary)
                                  : null,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter PIN code';
                            if (v.trim().length != 6) return 'Must be 6 digits';
                            if (!PincodeLookupService.isValidPin(v.trim())) return 'Invalid PIN code';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Country & State Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildCardField(
                                label: 'COUNTRY',
                                controller: _countryController,
                                placeholder: 'India',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCardField(
                                label: 'STATE',
                                controller: _stateController,
                                placeholder: 'Karnataka',
                                validator: (v) => v == null || v.trim().isEmpty ? 'State required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // District & City Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildCardField(
                                label: 'DISTRICT',
                                controller: _districtController,
                                placeholder: 'Gadag / Bengaluru',
                                validator: (v) => v == null || v.trim().isEmpty ? 'District required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCardField(
                                label: 'CITY / TOWN / VILLAGE',
                                controller: _cityController,
                                placeholder: 'Gadag / Bengaluru',
                                validator: (v) => v == null || v.trim().isEmpty ? 'City required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Area / Locality with Post Office Selection
                        _buildCardField(
                          label: 'AREA / LOCALITY',
                          controller: _areaController,
                          placeholder: 'e.g. Gadag City / Indiranagar',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter area / locality' : null,
                        ),

                        // Locality selector chips if multiple post offices are returned
                        if (_availableLocalities.length > 1) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_city_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'Select Locality / Post Office (${_availableLocalities.length} found):',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 34,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _availableLocalities.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, idx) {
                                final loc = _availableLocalities[idx];
                                final isSelected = _areaController.text == loc;
                                return ChoiceChip(
                                  label: Text(
                                    loc,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.surfaceContainerLow,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _areaController.text = loc;
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // ─── House & Street Details ───────────────────────────
                        Text(
                          'Street Address',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'HOUSE / FLAT / BUILDING NUMBER',
                          controller: _houseController,
                          placeholder: 'e.g. Flat 402, Sunrise Heights / #12',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter house/building details' : null,
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'STREET / ROAD NAME',
                          controller: _streetController,
                          placeholder: 'e.g. 100ft Road / Station Road',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter street / road name' : null,
                        ),
                        const SizedBox(height: 12),

                        _buildCardField(
                          label: 'LANDMARK (OPTIONAL)',
                          controller: _landmarkController,
                          placeholder: 'e.g. Near Mother Dairy / Bus Stand',
                        ),
                        const SizedBox(height: 24),

                        // ─── Save As Chips ───────────────────────────────────
                        Text(
                          'Address Type',
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
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                        const SizedBox(height: 20),

                        // ─── Set as Default Address Switch ────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.surfaceVariant),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Set as Default Address',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Use this address as primary for fast checkout',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isDefault,
                                activeThumbColor: AppColors.primary,
                                onChanged: (val) => setState(() => _isDefault = val),
                              ),
                            ],
                          ),
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
                        backgroundColor: _isServiceable ? AppColors.primary : const Color(0xFF6E7A6C),
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
                              _isServiceable ? 'Save Address' : 'Save Address (Outside Zone)',
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

  /// Builds the dynamic serviceability / error banner
  Widget _buildServiceabilityBanner() {
    if (_pinErrorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDAD6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFBA1A1A).withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline_rounded, size: 20, color: Color(0xFFBA1A1A)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invalid or Unrecognized PIN Code',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFBA1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _pinErrorMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF410002),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_isFetchingPin) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fetching postal details & checking delivery zone...',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isServiceable) {
      return Container(
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
                    _serviceabilityMessage,
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
      );
    }

    // Outside Delivery Zone banner
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_off_rounded,
            size: 20,
            color: Color(0xFFB45309),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outside Delivery Zone',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _serviceabilityMessage,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF78350F),
                  ),
                ),
              ],
            ),
          ),
        ],
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
