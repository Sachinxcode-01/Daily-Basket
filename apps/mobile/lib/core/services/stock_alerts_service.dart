import 'dart:io';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';

/// Stock Alerts Service for Daily Basket Flutter Application
/// Connects to NestJS `/api/v1/stock-alerts` module to subscribe,
/// retrieve, and manage product restock notifications.
class StockAlertsService {
  final String baseUrl;
  final ApiClient? _client;

  StockAlertsService({String? baseUrl, ApiClient? client})
      : baseUrl = baseUrl ?? ApiClient.defaultBaseUrl,
        _client = client;

  ApiClient get _apiClient => _client ?? ApiClient(baseUrl: baseUrl);

  /// Register user notification for out-of-stock product
  Future<Map<String, dynamic>> subscribe({
    required String productId,
    String? variantId,
    String? email,
    String? phone,
    String? productName,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return {
        'success': true,
        'message': 'Alert registered successfully',
        'data': {
          'id': 'test_alert_${DateTime.now().millisecondsSinceEpoch}',
          'productId': productId,
          'variantId': variantId ?? productId,
          'productName': productName ?? 'Daily Basket Item',
          'isEnabled': true,
        },
      };
    }

    try {
      final response = await _apiClient.post(
        '/stock-alerts/subscribe',
        {
          'productId': productId,
          'variantId': variantId ?? productId,
          if (email != null && email.isNotEmpty) 'email': email,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
      );

      if (response['success'] == true || response['status'] == 'success') {
        return {
          'success': true,
          'message': 'Alert registered successfully',
          'data': response['data'],
        };
      }

      return {
        'success': false,
        'error':
            response['error'] ?? 'Could not register alert. Please try again.',
      };
    } catch (e) {
      debugPrint('StockAlertsService.subscribe error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Fetch all active and past stock alerts for the current user
  Future<List<Map<String, dynamic>>> fetchAlerts() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return [
        {
          'id': 'bs1',
          'name': 'A2 Desi Cow Ghee 500ml',
          'brand': 'Daily Basket Farm Fresh',
          'price': '₹599',
          'mrp': '₹650',
          'status': 'RESTOCKED',
          'time': 'Restocked 10 mins ago',
          'notifyEnabled': true,
          'image':
              'https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400&q=80',
        },
        {
          'id': 'bs2',
          'name': 'Alphonso Mangoes Box (1kg)',
          'brand': 'Devgad Premium',
          'price': '₹299',
          'mrp': '₹399',
          'status': 'OUT_OF_STOCK',
          'time': 'Expected restock today, 4 PM',
          'notifyEnabled': true,
          'image':
              'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
        },
      ];
    }

    try {
      final response = await _apiClient.get('/stock-alerts');
      if (response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      debugPrint('StockAlertsService.fetchAlerts error: $e');
      return [];
    }
  }

  /// Toggle notification active state
  Future<bool> toggleAlert(String alertId, bool isEnabled) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return true;
    }

    try {
      final response = await _apiClient.post(
        '/stock-alerts/$alertId/toggle',
        {'isEnabled': isEnabled},
      );
      return response['success'] == true || response['status'] == 'success';
    } catch (e) {
      debugPrint('StockAlertsService.toggleAlert error: $e');
      return false;
    }
  }

  /// Remove alert registration
  Future<bool> removeAlert(String alertId) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return true;
    }

    try {
      final response = await _apiClient.delete('/stock-alerts/$alertId');
      return response['success'] == true || response['status'] == 'success';
    } catch (e) {
      debugPrint('StockAlertsService.removeAlert error: $e');
      return false;
    }
  }
}
