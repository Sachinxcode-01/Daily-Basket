import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../storage/secure_storage_service.dart';

/// Production Enterprise ApiClient for Daily Basket Flutter Application
/// Manages standard HTTP requests, auth headers, timeout guards, and environment URLs.
class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  /// Default API Base URL resolving automatically for Android Emulator vs Web/iOS/Desktop
  static String get defaultBaseUrl {
    if (kIsWeb) return 'http://localhost:4000/api/v1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:4000/api/v1';
    }
    return 'http://localhost:4000/api/v1';
  }

  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? defaultBaseUrl,
        _httpClient = client ?? http.Client();

  Map<String, String> _headers([String? token]) {
    final effectiveToken = token ?? SecureStorageService.currentAccessToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (effectiveToken != null && effectiveToken.isNotEmpty) 'Authorization': 'Bearer $effectiveToken',
    };
  }

  Uri _resolveUri(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return Uri.parse(endpoint);
    }
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return Uri.parse('$cleanBase/$cleanEndpoint');
  }

  Future<Map<String, dynamic>> get(String endpoint, {String? token, Duration timeout = const Duration(seconds: 15)}) async {
    try {
      final response = await _httpClient.get(_resolveUri(endpoint), headers: _headers(token)).timeout(timeout);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('ApiClient GET $endpoint error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {String? token, Duration timeout = const Duration(seconds: 15)}) async {
    try {
      final response = await _httpClient.post(
        _resolveUri(endpoint),
        headers: _headers(token),
        body: jsonEncode(body),
      ).timeout(timeout);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('ApiClient POST $endpoint error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body, {String? token, Duration timeout = const Duration(seconds: 15)}) async {
    try {
      final response = await _httpClient.patch(
        _resolveUri(endpoint),
        headers: _headers(token),
        body: jsonEncode(body),
      ).timeout(timeout);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('ApiClient PATCH $endpoint error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {String? token, Duration timeout = const Duration(seconds: 15)}) async {
    try {
      final response = await _httpClient.delete(_resolveUri(endpoint), headers: _headers(token)).timeout(timeout);
      return _parseResponse(response);
    } catch (e) {
      debugPrint('ApiClient DELETE $endpoint error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    final isOk = response.statusCode >= 200 && response.statusCode < 300;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (!decoded.containsKey('success')) {
          decoded['success'] = isOk;
        }
        if (!isOk && !decoded.containsKey('error') && decoded.containsKey('message')) {
          final msg = decoded['message'];
          decoded['error'] = msg is List ? msg.join(', ') : msg.toString();
        }
        return decoded;
      }
      return {'success': isOk, 'data': decoded};
    } catch (_) {
      return {
        'success': isOk,
        'statusCode': response.statusCode,
        'error': isOk ? null : 'Server returned status ${response.statusCode}',
        'body': response.body,
      };
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
