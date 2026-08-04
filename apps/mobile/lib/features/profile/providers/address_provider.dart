import 'package:flutter/material.dart';

enum LocationPermissionState { granted, denied, prompt }

class LocationDataPayload {
  final double latitude;
  final double longitude;
  final String houseFlat;
  final String streetArea;
  final String landmark;
  final String formattedAddress;
  final String city;
  final String state;
  final String pincode;

  LocationDataPayload({
    required this.latitude,
    required this.longitude,
    required this.houseFlat,
    required this.streetArea,
    required this.landmark,
    required this.formattedAddress,
    required this.city,
    required this.state,
    required this.pincode,
  });
}

class AddressProvider extends ChangeNotifier {
  LocationPermissionState _permissionState = LocationPermissionState.prompt;
  String _fetchingProgressText = 'Detecting GPS Location...';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'label': 'Home',
      'fullAddress': 'Flat 402, Green Valley Apartments, Indiranagar, Bengaluru, 560038',
      'isDefault': true,
      'type': 'HOME',
    },
    {
      'id': '2',
      'label': 'Work',
      'fullAddress': 'Tech Park, Tower B, 5th Floor, Outer Ring Road, Bengaluru, 560103',
      'isDefault': false,
      'type': 'WORK',
    },
  ];

  bool get isPermissionGranted => _permissionState == LocationPermissionState.granted;
  LocationPermissionState get permissionState => _permissionState;
  String get fetchingProgressText => _fetchingProgressText;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get addresses => List.unmodifiable(_addresses);
  List<Map<String, dynamic>> get savedAddresses => List.unmodifiable(_addresses);

  void setPermissionState(LocationPermissionState state) {
    _permissionState = state;
    notifyListeners();
  }

  void updateFetchingProgress(String text) {
    _fetchingProgressText = text;
    notifyListeners();
  }

  Future<LocationDataPayload?> fetchLiveLocation() async {
    _isLoading = true;
    _fetchingProgressText = 'Accessing GPS hardware...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));
    _fetchingProgressText = 'Resolving geocode & street address...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));
    _fetchingProgressText = 'Finalizing address details...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _isLoading = false;
    notifyListeners();

    return LocationDataPayload(
      latitude: 12.9716,
      longitude: 77.5946,
      houseFlat: 'Flat 402, Green Valley Apts',
      streetArea: 'Indiranagar 100ft Road',
      landmark: 'Near Metro Station',
      formattedAddress: 'Flat 402, Green Valley Apts, Indiranagar 100ft Road, Bengaluru 560038',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560038',
    );
  }

  Future<Map<String, dynamic>?> fetchLiveLocationAndSave() async {
    final payload = await fetchLiveLocation();
    if (payload == null) return null;

    final newAddr = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'label': 'Current Location',
      'fullAddress': payload.formattedAddress,
      'isDefault': true,
      'type': 'OTHER',
    };

    _addresses.add(newAddr);
    setDefaultAddress(newAddr['id'] as String);
    return newAddr;
  }

  void addAddress(Map<String, dynamic> newAddress) {
    _addresses.add(newAddress);
    notifyListeners();
  }

  void deleteAddress(dynamic idOrIndex) {
    if (idOrIndex is int) {
      if (idOrIndex >= 0 && idOrIndex < _addresses.length) {
        _addresses.removeAt(idOrIndex);
      }
    } else {
      _addresses.removeWhere((a) => a['id'] == idOrIndex);
    }
    notifyListeners();
  }

  void setDefaultAddress(dynamic idOrIndex) {
    if (idOrIndex is int) {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i]['isDefault'] = (i == idOrIndex);
      }
    } else {
      for (var addr in _addresses) {
        addr['isDefault'] = (addr['id'] == idOrIndex.toString());
      }
    }
    notifyListeners();
  }
}
