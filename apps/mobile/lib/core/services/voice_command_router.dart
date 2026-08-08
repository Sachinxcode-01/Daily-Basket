import 'package:flutter/material.dart';

class VoiceCommandRouter {
  static const Map<String, String> voiceRouteMap = {
    'NAVIGATE_CART': '/cart',
    'NAVIGATE_ORDERS': '/orders',
    'NAVIGATE_WALLET': '/wallet',
    'NAVIGATE_COUPONS': '/coupons',
    'NAVIGATE_PROFILE': '/profile',
    'NAVIGATE_TRACKING': '/tracking',
    'NAVIGATE_VOICE_SETTINGS': '/voice_settings',
  };

  /// Evaluates action string and performs navigation on Navigator.
  static bool handleVoiceNavigation(BuildContext context, String actionOrRoute) {
    final String route = voiceRouteMap[actionOrRoute] ?? actionOrRoute;

    if (route.startsWith('/')) {
      try {
        Navigator.of(context).pushNamed(route);
        return true;
      } catch (e) {
        debugPrint('VoiceNavigation failed for route $route: $e');
      }
    }
    return false;
  }
}
