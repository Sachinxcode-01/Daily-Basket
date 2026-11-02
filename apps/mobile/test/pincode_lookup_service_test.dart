import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/core/services/pincode_lookup_service.dart';
import 'package:daily_basket_mobile/features/profile/providers/address_provider.dart';

void main() {
  group('PincodeLookupService format and validation', () {
    test('isValidPin correctly validates 6-digit Indian PIN codes', () {
      // Valid Indian PIN codes: 6 digits, non-zero first digit
      expect(PincodeLookupService.isValidPin('582103'), isTrue); // Gadag
      expect(PincodeLookupService.isValidPin('560038'), isTrue); // Indiranagar, Bengaluru
      expect(PincodeLookupService.isValidPin('110001'), isTrue); // Connaught Place, New Delhi
      expect(PincodeLookupService.isValidPin('400001'), isTrue); // Mumbai

      // Invalid: starts with 0
      expect(PincodeLookupService.isValidPin('012345'), isFalse);
      // Invalid: too short or too long
      expect(PincodeLookupService.isValidPin('58210'), isFalse);
      expect(PincodeLookupService.isValidPin('5821034'), isFalse);
      // Invalid: letters / characters
      expect(PincodeLookupService.isValidPin('58210A'), isFalse);
      expect(PincodeLookupService.isValidPin(''), isFalse);
      expect(PincodeLookupService.isValidPin(null), isFalse);
    });

    test('defaultServiceablePins distinguishes Bangalore clusters from other locations', () {
      // Default serviceable Bangalore PINs
      expect(PincodeLookupService.defaultServiceablePins.contains('560038'), isTrue);
      expect(PincodeLookupService.defaultServiceablePins.contains('560001'), isTrue);
      expect(PincodeLookupService.defaultServiceablePins.contains('560034'), isTrue);

      // Gadag is a valid postal location, but outside Daily Basket 10-Min Kirana delivery
      expect(PincodeLookupService.defaultServiceablePins.contains('582103'), isFalse);
      expect(PincodeLookupService.defaultServiceablePins.contains('110001'), isFalse);
    });

    test('PincodeLookupResult.invalid creates structured invalid result', () {
      final res = PincodeLookupResult.invalid('123', 'PIN code must be 6 digits.');
      expect(res.isValid, isFalse);
      expect(res.success, isFalse);
      expect(res.isServiceable, isFalse);
      expect(res.pincode, equals('123'));
      expect(res.errorMessage, equals('PIN code must be 6 digits.'));
    });

    test('PincodeLookupResult.fromMap parses API dictionary correctly', () {
      final mockData = {
        'success': true,
        'isValid': true,
        'pincode': '582103',
        'country': 'India',
        'state': 'Karnataka',
        'district': 'Gadag',
        'city': 'Gadag',
        'localities': ['Gadag City', 'Betageri', 'Advisomapur'],
        'isServiceable': false,
        'serviceabilityMessage': 'Currently outside 10-Min Kirana delivery zone.',
      };

      final res = PincodeLookupResult.fromMap(mockData, '582103');
      expect(res.isValid, isTrue);
      expect(res.state, equals('Karnataka'));
      expect(res.district, equals('Gadag'));
      expect(res.city, equals('Gadag'));
      expect(res.localities, contains('Gadag City'));
      expect(res.localities, contains('Betageri'));
      expect(res.isServiceable, isFalse);
    });
  });

  group('AddressProvider local state management', () {
    test('saveAddress adds entry and manages default selection', () async {
      final provider = AddressProvider();
      final initialCount = provider.addresses.length;

      await provider.saveAddress({
        'id': 'test_gadag',
        'label': 'HOME',
        'fullName': 'Aarav Kumar',
        'phone': '+91 98765 00000',
        'country': 'India',
        'state': 'Karnataka',
        'district': 'Gadag',
        'houseFlat': 'Plot 10',
        'streetArea': 'Station Road',
        'area': 'Gadag City',
        'city': 'Gadag',
        'pincode': '582103',
        'addressText': 'Plot 10, Station Road, Gadag City, Gadag, Karnataka - 582103',
        'isDefault': true,
        'isServiceable': false,
      });

      expect(provider.addresses.length, equals(initialCount + 1));
      final added = provider.addresses.firstWhere((a) => a['id'] == 'test_gadag');
      expect(added['pincode'], equals('582103'));
      expect(added['isDefault'], isTrue);
      expect(added['isServiceable'], isFalse);

      // Save a second address set as default
      await provider.saveAddress({
        'id': 'test_bengaluru',
        'label': 'WORK',
        'fullName': 'Aarav Kumar',
        'phone': '+91 98765 00000',
        'country': 'India',
        'state': 'Karnataka',
        'district': 'Bengaluru',
        'houseFlat': 'Tech Park 4B',
        'streetArea': '100ft Road',
        'area': 'Indiranagar',
        'city': 'Bengaluru',
        'pincode': '560038',
        'addressText': 'Tech Park 4B, 100ft Road, Indiranagar, Bengaluru, Karnataka - 560038',
        'isDefault': true,
        'isServiceable': true,
      });

      // First address should no longer be default
      final gadag = provider.addresses.firstWhere((a) => a['id'] == 'test_gadag');
      final blr = provider.addresses.firstWhere((a) => a['id'] == 'test_bengaluru');
      expect(gadag['isDefault'], isFalse);
      expect(blr['isDefault'], isTrue);
    });

    test('deleteAddress removes item from list', () async {
      final provider = AddressProvider();
      await provider.saveAddress({
        'id': 'addr_to_delete',
        'label': 'OTHER',
        'city': 'Gadag',
        'pincode': '582103',
        'isDefault': false,
      });

      expect(provider.addresses.any((a) => a['id'] == 'addr_to_delete'), isTrue);
      provider.deleteAddress('addr_to_delete');
      expect(provider.addresses.any((a) => a['id'] == 'addr_to_delete'), isFalse);
    });

    test('setDefaultAddress sets chosen address to default and unsets others', () async {
      final provider = AddressProvider();
      await provider.saveAddress({
        'id': 'addr_a',
        'label': 'HOME',
        'pincode': '582103',
        'isDefault': true,
      });
      await provider.saveAddress({
        'id': 'addr_b',
        'label': 'OFFICE',
        'pincode': '560038',
        'isDefault': false,
      });

      provider.setDefaultAddress('addr_b');
      expect(provider.addresses.firstWhere((a) => a['id'] == 'addr_b')['isDefault'], isTrue);
      expect(provider.addresses.firstWhere((a) => a['id'] == 'addr_a')['isDefault'], isFalse);
    });
  });
}
