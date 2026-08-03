class SecureStorageService {
  String? _authToken;
  String? _refreshToken;

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    _authToken = accessToken;
    if (refreshToken != null) {
      _refreshToken = refreshToken;
    }
  }

  Future<String?> getAccessToken() async {
    return _authToken;
  }

  Future<String?> getRefreshToken() async {
    return _refreshToken;
  }

  Future<void> clearTokens() async {
    _authToken = null;
    _refreshToken = null;
  }
}
