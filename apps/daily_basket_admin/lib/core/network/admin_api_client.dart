import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class AdminApiClient {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:4000/api/v1';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:4000/api/v1';
    } catch (_) {}
    return 'http://localhost:4000/api/v1';
  }
  static String? authToken;

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (_) {
      return {'success': false, 'message': 'Network offline or server unreachable.'};
    }
  }

  static Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );
      return jsonDecode(response.body);
    } catch (_) {
      return {'success': false, 'message': 'Network offline or server unreachable.'};
    }
  }
}
