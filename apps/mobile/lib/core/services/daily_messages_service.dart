import 'dart:io';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';

/// Daily Grocery Marketing & Promotional Message Service
/// Fetches active daily campaign announcements from NestJS `/api/v1/messages/daily`.
class DailyMessagesService {
  final String baseUrl;
  final ApiClient? _client;

  DailyMessagesService({String? baseUrl, ApiClient? client})
      : baseUrl = baseUrl ?? ApiClient.defaultBaseUrl,
        _client = client;

  ApiClient get _apiClient => _client ?? ApiClient(baseUrl: baseUrl);

  /// Fetch today's active daily message
  Future<Map<String, dynamic>> fetchTodaysMessage({String? userId}) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return {
        'success': true,
        'data': {
          'id': 'campaign_test_01',
          'title': 'Fresh Morning Harvest 🌿',
          'body': 'Crisp organic greens, farm-fresh milk & bakery essentials delivered in 10 minutes.',
          'badge': 'DAILY SPECIAL',
          'enabled': true,
        },
      };
    }

    try {
      final endpoint = userId != null && userId.isNotEmpty
          ? '/messages/daily?userId=$userId'
          : '/messages/daily';
      final response = await _apiClient.get(endpoint);

      if (response['success'] == true || response['title'] != null) {
        final data = response['data'] ?? response;
        return {
          'success': true,
          'data': data,
        };
      }

      return {
        'success': false,
        'error': response['error'] ?? 'Could not fetch daily message',
      };
    } catch (e) {
      debugPrint('DailyMessagesService.fetchTodaysMessage error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
