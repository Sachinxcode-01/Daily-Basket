import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApiClient {
  static String get baseUrl {
    const customApiUrl = String.fromEnvironment('API_BASE_URL');
    if (customApiUrl.isNotEmpty) return customApiUrl;
    return 'https://produced-fed-supervisors-mounted.trycloudflare.com/api/v1';
  }

  static String? authToken;

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
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
      return {
        'success': false,
        'message': 'Network offline or server unreachable.'
      };
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
      return {
        'success': false,
        'message': 'Network offline or server unreachable.'
      };
    }
  }
}
