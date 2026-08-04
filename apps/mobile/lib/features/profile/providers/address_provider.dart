import 'package:flutter/material.dart';

/// Represents a location permission status enum/string
enum LocationPermissionState { prompt, granted, denied }

class LocationDataPayload {
  final double latitude;
  final double longitude;
  final String houseFlat;
  final String streetArea;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String formattedAddress;

  LocationDataPayload({
    required this.latitude,
    required this.longitude,
    required this.houseFlat,
    required this.streetArea,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.formattedAddress,
  });
}

/// AddressProvider manages customer delivery addresses & live GPS location detection
class AddressProvider extends ChangeNotifier {
  LocationPermissionState _permissionState = LocationPermissionState.prompt;
  bool _isFetchingLocation = false;
  String _fetchingProgressText = 'Initialising GPS positioning...';
  LocationDataPayload? _lastFetchedLocation;

  final List<Map<String, dynamic>> _addresses = [
    {
      'id': 'a1',
      'label': 'Home',
      'icon': Icons.home_outlined,
      'isDefault': true,
      'addressText': '123 Green Valley Lane, Apt 4B\nIndiranagar, Bengaluru 560038',
      'houseFlat': 'Apt 4B, 123 Green Valley',
      'streetArea': '100ft Road, Indiranagar',
      'landmark': 'Near Metro Station',
      'phone': '+91 98765 43210',
      'instruction': null,
    },
    {
      'id': 'a2',
      'label': 'Work',
      'icon': Icons.work_outline_rounded,
      'isDefault': false,
      'addressText': '880 Tech Park Blvd, Suite 200\nOuter Ring Road, Bengaluru 560103',
      'houseFlat': 'Suite 200, Building B',
      'streetArea': 'Ecovis Tech Park, ORR',
      'landmark': 'Opposite Intel Campus',
      'phone': null,
      'instruction': 'Leave at front desk reception',
    },
    {
      'id': 'a3',
      'label': 'Parents',
      'icon': Icons.favorite_border_rounded,
      'isDefault': false,
      'addressText': '45 Maple Street, 5th Sector\nHSR Layout, Bengaluru 560102',
      'houseFlat': '#45, 1st Floor',
      'streetArea': '5th Main, Sector 5, HSR Layout',
      'landmark': 'Near BDA Complex',
      'phone': null,
      'instruction': null,
    },
  ];

  // Mock preset locations for realistic simulation
  final List<LocationDataPayload> _mockLocations = [
    LocationDataPayload(
      latitude: 12.9716,
      longitude: 77.5946,
      houseFlat: '#742, 3rd Floor, Indiranagar Heights',
      streetArea: '12th Main Road, HAL 2nd Stage, Indiranagar',
      landmark: 'Near Club House & Metro Pillar 42',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560038',
      formattedAddress: '742 Indiranagar Heights, 12th Main Rd, Indiranagar, Bengaluru, KA 560038',
    ),
    LocationDataPayload(
      latitude: 12.9141,
      longitude: 77.6411,
      houseFlat: 'Flat 402, B-Block, Sunshine Palms',
      streetArea: '17th Cross, Sector 4, HSR Layout',
      landmark: 'Opposite Agara Lake Park',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560102',
      formattedAddress: 'Flat 402, Sunshine Palms, Sector 4, HSR Layout, Bengaluru, KA 560102',
    ),
    LocationDataPayload(
      latitude: 12.9352,
      longitude: 77.6245,
      houseFlat: '#105, Ground Floor, Royal Nest',
      streetArea: '8th Block, Koramangala',
      landmark: 'Behind Forum Mall',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560095',
      formattedAddress: '#105 Royal Nest, 8th Block, Koramangala, Bengaluru, KA 560095',
    ),
  ];

  int _mockIndex = 0;

  LocationPermissionState get permissionState => _permissionState;
  bool get isPermissionGranted => _permissionState == LocationPermissionState.granted;
  bool get isFetchingLocation => _isFetchingLocation;
  String get fetchingProgressText => _fetchingProgressText;
  LocationDataPayload? get lastFetchedLocation => _lastFetchedLocation;
  List<Map<String, dynamic>> get addresses => List.unmodifiable(_addresses);

  void setPermissionState(LocationPermissionState state) {
    _permissionState = state;
    notifyListeners();
  }

  /// Simulate step-by-step live location fetching from mobile GPS hardware
  Future<LocationDataPayload?> fetchLiveLocation() async {
    if (_permissionState != LocationPermissionState.granted) {
      return null;
    }

    _isFetchingLocation = true;
    _fetchingProgressText = 'Connecting to mobile GPS satellite...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _fetchingProgressText = 'Acquiring high-accuracy coordinates (12.9716° N, 77.5946° E)...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    _fetchingProgressText = 'Reverse geocoding address & verifying dark store coverage...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    // Rotate through realistic mock location payloads
    _lastFetchedLocation = _mockLocations[_mockIndex % _mockLocations.length];
    _mockIndex++;

    _isFetchingLocation = false;
    _fetchingProgressText = 'Location successfully fetched!';
    notifyListeners();

    return _lastFetchedLocation;
  }

  void addAddress(Map<String, dynamic> newAddress) {
    final bool isDefault = newAddress['isDefault'] ?? false;
    if (isDefault) {
      for (var addr in _addresses) {
        addr['isDefault'] = false;
      }
    }
    _addresses.insert(0, {
      'id': 'a_${DateTime.now().millisecondsSinceEpoch}',
      'label': newAddress['label'] ?? 'Home',
      'icon': newAddress['icon'] ?? Icons.location_on_outlined,
      'isDefault': isDefault || _addresses.isEmpty,
      'addressText': newAddress['addressText'] ?? '',
      'houseFlat': newAddress['houseFlat'] ?? '',
      'streetArea': newAddress['streetArea'] ?? '',
      'landmark': newAddress['landmark'] ?? '',
      'phone': newAddress['phone'],
      'instruction': newAddress['instruction'],
    });
    notifyListeners();
  }

  void deleteAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      final wasDefault = _addresses[index]['isDefault'] as bool;
      _addresses.removeAt(index);
      if (wasDefault && _addresses.isNotEmpty) {
        _addresses[0]['isDefault'] = true;
      }
      notifyListeners();
    }
  }

  void setDefaultAddress(String id) {
    for (var addr in _addresses) {
      addr['isDefault'] = (addr['id'] == id);
    }
    notifyListeners();
  }
}
