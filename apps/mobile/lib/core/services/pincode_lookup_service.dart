import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../network/api_client.dart';

/// Structured postal information and serviceability status
class PincodeLookupResult {
  final bool success;
  final bool isValid;
  final String pincode;
  final String country;
  final String state;
  final String district;
  final String city;
  final List<String> localities;
  final bool isServiceable;
  final String serviceabilityMessage;
  final String? errorMessage;

  const PincodeLookupResult({
    required this.success,
    required this.isValid,
    required this.pincode,
    this.country = 'India',
    this.state = '',
    this.district = '',
    this.city = '',
    this.localities = const [],
    this.isServiceable = false,
    this.serviceabilityMessage = '',
    this.errorMessage,
  });

  factory PincodeLookupResult.invalid(String pincode, [String? message]) {
    return PincodeLookupResult(
      success: false,
      isValid: false,
      pincode: pincode,
      country: 'India',
      isServiceable: false,
      serviceabilityMessage: 'Please enter a valid 6-digit Indian PIN code.',
      errorMessage: message ?? 'Invalid PIN code format. Must be 6 digits.',
    );
  }

  factory PincodeLookupResult.fromMap(Map<String, dynamic> map, String requestedPin) {
    final rawLocalities = map['localities'];
    final List<String> localitiesList = [];
    if (rawLocalities is List) {
      for (final item in rawLocalities) {
        if (item != null && item.toString().trim().isNotEmpty) {
          localitiesList.add(item.toString().trim());
        }
      }
    }

    return PincodeLookupResult(
      success: map['success'] == true || map['isValid'] == true,
      isValid: map['isValid'] ?? true,
      pincode: map['pincode']?.toString() ?? requestedPin,
      country: map['country']?.toString() ?? 'India',
      state: map['state']?.toString() ?? '',
      district: map['district']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      localities: localitiesList,
      isServiceable: map['isServiceable'] == true,
      serviceabilityMessage: map['serviceabilityMessage']?.toString() ??
          (map['isServiceable'] == true
              ? '10-Minute Kirana Delivery Available in this area!'
              : 'Currently outside Daily Basket 10-Minute Kirana delivery zone.'),
      errorMessage: map['error']?.toString(),
    );
  }
}

/// Service to lookup postal details and delivery serviceability for Indian PIN codes
class PincodeLookupService {
  final ApiClient _apiClient;
  final http.Client _httpClient;

  // In-memory cache for lookup results
  static final Map<String, PincodeLookupResult> _cache = {};

  // Default Kirana Serviceable PINs (Bengaluru cluster)
  static final Set<String> defaultServiceablePins = {
    '560001', // MG Road
    '560008', // Ulsoor / Halasuru
    '560025', // Richmond Town
    '560034', // Koramangala
    '560038', // Indiranagar
    '560075', // CV Raman Nagar
    '560095', // Koramangala Extension
    '560102', // HSR Layout Sector 2
    '560103', // Bellandur / ORR
  };

  PincodeLookupService({ApiClient? apiClient, http.Client? httpClient})
      : _apiClient = apiClient ?? ApiClient(),
        _httpClient = httpClient ?? http.Client();

  /// Validates standard 6-digit Indian PIN code format
  static bool isValidPin(String? pin) {
    if (pin == null) return false;
    final clean = pin.trim();
    return RegExp(r'^[1-9][0-9]{5}$').hasMatch(clean);
  }

  /// Looks up postal info and serviceability with caching and resilient fallback
  Future<PincodeLookupResult> lookup(String rawPincode) async {
    final pincode = rawPincode.trim();

    if (!isValidPin(pincode)) {
      return PincodeLookupResult.invalid(pincode);
    }

    // Check cache first
    if (_cache.containsKey(pincode)) {
      return _cache[pincode]!;
    }

    // 1. Try Backend API first
    try {
      final res = await _apiClient.get(
        '/delivery/pincode/$pincode',
        timeout: const Duration(seconds: 8),
      );

      if (res['success'] == true || (res['isValid'] == true && res['district'] != null)) {
        final result = PincodeLookupResult.fromMap(res, pincode);
        if (result.isValid && result.state.isNotEmpty) {
          _cache[pincode] = result;
          return result;
        }
      }
    } catch (e) {
      debugPrint('Backend PIN lookup fallback for $pincode: $e');
    }

    // 2. Resilient fallback to reliable direct Postal API
    try {
      final uri = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
      final response = await _httpClient.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          final first = jsonList[0] as Map<String, dynamic>;
          if (first['Status'] == 'Success' && first['PostOffice'] is List) {
            final List<dynamic> poList = first['PostOffice'];
            if (poList.isNotEmpty) {
              final firstPo = poList[0] as Map<String, dynamic>;
              final state = firstPo['State']?.toString() ?? '';
              final district = firstPo['District']?.toString() ?? '';
              final country = firstPo['Country']?.toString() ?? 'India';

              // Determine primary city/town/village
              final mainPo = poList.firstWhere(
                (po) =>
                    (po['BranchType']?.toString().contains('Head') ?? false) ||
                    (po['BranchType']?.toString().contains('Sub') ?? false),
                orElse: () => firstPo,
              );
              final city = mainPo['District']?.toString() ??
                  mainPo['Division']?.toString() ??
                  mainPo['Block']?.toString() ??
                  mainPo['Name']?.toString() ??
                  '';

              final localities = poList
                  .map((po) => po['Name']?.toString().trim() ?? '')
                  .where((name) => name.isNotEmpty)
                  .toSet()
                  .toList();

              final isServiceable = defaultServiceablePins.contains(pincode);

              final result = PincodeLookupResult(
                success: true,
                isValid: true,
                pincode: pincode,
                country: country,
                state: state,
                district: district,
                city: city,
                localities: localities,
                isServiceable: isServiceable,
                serviceabilityMessage: isServiceable
                  ? '10-Minute Kirana Delivery Available in this area!'
                  : 'Currently outside Daily Basket 10-Minute Kirana delivery zone.',
              );

              _cache[pincode] = result;
              return result;
            }
          } else {
            return PincodeLookupResult(
              success: false,
              isValid: false,
              pincode: pincode,
              country: 'India',
              isServiceable: false,
              serviceabilityMessage: first['Message']?.toString() ?? 'No postal records found.',
              errorMessage: first['Message']?.toString() ?? 'No postal records found for this PIN code.',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Postal fallback error for $pincode: $e');
    }

    // 3. Graceful offline/timeout fallback
    final isServiceable = defaultServiceablePins.contains(pincode);
    return PincodeLookupResult(
      success: false,
      isValid: true,
      pincode: pincode,
      country: 'India',
      isServiceable: isServiceable,
      serviceabilityMessage: isServiceable
          ? 'PIN is within Daily Basket delivery zone. Please enter remaining address details.'
          : 'Could not fetch postal details automatically. You can enter address details manually.',
      errorMessage: 'Network timeout during postal lookup. Manual entry enabled.',
    );
  }
}
