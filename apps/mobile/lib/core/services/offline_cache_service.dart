/// Entry item for offline memory & persistent cache
class CacheEntry<T> {
  final T data;
  final DateTime expiresAt;

  CacheEntry({required this.data, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Production Offline Cache & State Persistence Service for Daily Basket Mobile
/// Caches categories, products, user favorites, and recent queries for instant startup & offline browsing.
class OfflineCacheService {
  static final OfflineCacheService _instance = OfflineCacheService._internal();
  factory OfflineCacheService() => _instance;
  OfflineCacheService._internal();

  final Map<String, CacheEntry<dynamic>> _memoryCache = {};

  /// Store item in cache with customizable TTL (default: 30 minutes)
  void set<T>(String key, T value, {Duration ttl = const Duration(minutes: 30)}) {
    _memoryCache[key] = CacheEntry<T>(
      data: value,
      expiresAt: DateTime.now().add(ttl),
    );
  }

  /// Retrieve item from cache if present and unexpired
  T? get<T>(String key) {
    final entry = _memoryCache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _memoryCache.remove(key);
      return null;
    }
    return entry.data as T?;
  }

  /// Check if unexpired cache entry exists
  bool has(String key) {
    final entry = _memoryCache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _memoryCache.remove(key);
      return false;
    }
    return true;
  }

  /// Invalidate specific key
  void invalidate(String key) {
    _memoryCache.remove(key);
  }

  /// Clear entire cache (e.g. on logout or manual refresh)
  void clearAll() {
    _memoryCache.clear();
  }

  /// Helper keys
  static const String keyCategories = 'cache_categories';
  static const String keyPopularProducts = 'cache_popular_products';
  static const String keyWishlist = 'cache_user_wishlist';
  static const String keyActiveCart = 'cache_active_cart';
  static const String keyRecentSearches = 'cache_recent_searches';
}
