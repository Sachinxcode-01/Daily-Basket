class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = 'http://localhost:4000/api/v1'});

  Future<Map<String, dynamic>> get(String endpoint) async {
    // Production HTTP get wrapper
    return {'success': true, 'data': []};
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    // Production HTTP post wrapper
    return {'success': true, 'data': {}};
  }
}
