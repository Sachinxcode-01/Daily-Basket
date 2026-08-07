import 'package:flutter/foundation.dart';

/// Centralized Enterprise Analytics Service for Daily Basket
class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return instance;
  }

  AnalyticsService._internal();

  final List<Map<String, dynamic>> _eventLogs = [];

  List<Map<String, dynamic>> get eventLogs => List.unmodifiable(_eventLogs);

  /// Log an application event with optional context properties
  void logEvent(String eventName, [Map<String, dynamic>? properties]) {
    final payload = {
      'event': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'properties': properties ?? {},
    };

    _eventLogs.add(payload);

    if (kDebugMode) {
      debugPrint('📊 [ANALYTICS] $eventName: ${properties ?? {}}');
    }
  }

  /// Specific tracking shortcuts
  void trackScreenView(String screenName) {
    logEvent('screen_view', {'screen': screenName});
  }

  void trackSearch(String query, int resultCount) {
    logEvent('search_query', {'query': query, 'results_count': resultCount});
  }

  void trackAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) {
    logEvent('add_to_cart', {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
    });
  }

  void trackCheckoutStarted(double cartTotal, int itemCount) {
    logEvent('checkout_started', {
      'cart_total': cartTotal,
      'item_count': itemCount,
    });
  }

  void trackCouponApplied(String couponCode, double discountAmount) {
    logEvent('coupon_applied', {
      'coupon_code': couponCode,
      'discount': discountAmount,
    });
  }

  void trackOrderCompleted({
    required String orderId,
    required double totalAmount,
    required String paymentMethod,
  }) {
    logEvent('order_completed', {
      'order_id': orderId,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
    });
  }

  void trackAiRecommendationClicked(String recommendationType, String productId) {
    logEvent('ai_recommendation_clicked', {
      'type': recommendationType,
      'product_id': productId,
    });
  }

  void trackReferralShared(String referralCode) {
    logEvent('referral_shared', {'referral_code': referralCode});
  }
}
