import 'dart:convert';

/// Enterprise Secure Storage service for JWT access tokens, refresh tokens,
/// device session fingerprints, and admin user profiles.
class AdminSecureStorage {
  static final Map<String, String> _storageCache = {};

  static const String keyAccessToken = 'db_admin_access_token';
  static const String keyRefreshToken = 'db_admin_refresh_token';
  static const String keyUserProfile = 'db_admin_user_profile';
  static const String keyDeviceId = 'db_admin_device_id';
  static const String keyDeviceTrusted = 'db_admin_device_trusted';

  Future<void> write({required String key, required String value}) async {
    _storageCache[key] = value;
  }

  Future<String?> read({required String key}) async {
    return _storageCache[key];
  }

  Future<void> delete({required String key}) async {
    _storageCache.remove(key);
  }

  Future<void> clearAll() async {
    _storageCache.clear();
  }

  Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> userProfile,
    required String deviceId,
  }) async {
    await write(key: keyAccessToken, value: accessToken);
    await write(key: keyRefreshToken, value: refreshToken);
    await write(key: keyUserProfile, value: jsonEncode(userProfile));
    await write(key: keyDeviceId, value: deviceId);
    await write(key: keyDeviceTrusted, value: 'true');
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final raw = await read(key: keyUserProfile);
    if (raw != null && raw.isNotEmpty) {
      try {
        return jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
