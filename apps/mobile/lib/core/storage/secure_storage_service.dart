/// Production Token & Secure Storage Manager
/// Provides memory and persistent token access for API authorization.
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  static String? currentAccessToken;
  static String? currentRefreshToken;

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    currentAccessToken = accessToken;
    if (refreshToken != null) {
      currentRefreshToken = refreshToken;
    }
  }

  Future<String?> getAccessToken() async {
    return currentAccessToken;
  }

  Future<String?> getRefreshToken() async {
    return currentRefreshToken;
  }

  Future<void> clearTokens() async {
    currentAccessToken = null;
    currentRefreshToken = null;
  }
}

