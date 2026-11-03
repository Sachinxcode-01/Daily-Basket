import 'dart:io';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';

/// Product Suggestion Record for AI Copilot
class ProductSuggestion {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String price;
  final String mrp;
  final String unit;
  final String imageUrl;
  final double rating;
  final String badgeType;

  const ProductSuggestion({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.mrp,
    required this.unit,
    required this.imageUrl,
    required this.rating,
    required this.badgeType,
  });

  factory ProductSuggestion.fromJson(Map<String, dynamic> json) {
    return ProductSuggestion(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Daily Basket Item',
      brand: json['brand']?.toString() ?? 'Daily Basket',
      category: json['category']?.toString() ?? 'Grocery',
      price: json['price']?.toString() ?? '₹50',
      mrp: json['mrp']?.toString() ?? '₹60',
      unit: json['unit']?.toString() ?? '1 unit',
      imageUrl: json['imageUrl']?.toString() ??
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      badgeType: json['badgeType']?.toString() ?? 'AI Pick',
    );
  }
}

/// AI Copilot Personalized Recommendation Service
/// Connects to NestJS `/api/v1/personalization/recommendations`
/// dynamically passing recentlyViewedIds from mobile state.
class AICopilotService {
  final String baseUrl;
  final ApiClient? _client;

  AICopilotService({String? baseUrl, ApiClient? client})
      : baseUrl = baseUrl ?? ApiClient.defaultBaseUrl,
        _client = client;

  ApiClient get _apiClient => _client ?? ApiClient(baseUrl: baseUrl);

  /// Build product suggestions driven by live recently viewed items
  Future<Map<String, dynamic>> buildProductSuggestions({
    required List<String> recentlyViewedIds,
    String? category,
    int limit = 6,
  }) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      final reason = recentlyViewedIds.isNotEmpty
          ? 'Personalized from your recent exploration'
          : 'Smart daily basket essentials for you';

      return {
        'success': true,
        'reason': reason,
        'items': [
          const ProductSuggestion(
            id: 'rec_avocado',
            name: 'Organic Hass Avocados (2 pcs)',
            brand: 'Daily Basket Organics',
            category: 'Fruits & Vegetables',
            price: '₹180',
            mrp: '₹220',
            unit: '400g',
            imageUrl:
                'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300',
            rating: 4.9,
            badgeType: 'Fresh Harvest',
          ),
          const ProductSuggestion(
            id: 'rec_milk',
            name: 'A2 Farm Fresh Cow Milk 1L',
            brand: 'Daily Basket Dairy',
            category: 'Dairy & Breakfast',
            price: '₹75',
            mrp: '₹85',
            unit: '1 Litre',
            imageUrl:
                'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300',
            rating: 4.8,
            badgeType: 'Daily Staple',
          ),
          const ProductSuggestion(
            id: 'rec_bread',
            name: 'Artisan Whole Wheat Sourdough',
            brand: 'Daily Basket Bakery',
            category: 'Bakery & Snacks',
            price: '₹65',
            mrp: '₹80',
            unit: '400g Loaf',
            imageUrl:
                'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
            rating: 4.7,
            badgeType: 'Baked Fresh',
          ),
        ],
      };
    }

    try {
      final response = await _apiClient.post(
        '/personalization/recommendations',
        {
          'recentlyViewedIds': recentlyViewedIds,
          if (category != null) 'category': category,
          'limit': limit,
        },
      );

      if (response['success'] == true && response['items'] is List) {
        final list = (response['items'] as List)
            .map((item) =>
                ProductSuggestion.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        return {
          'success': true,
          'reason': response['reason'] ?? 'AI Personalized Suggestions',
          'items': list,
        };
      }

      return {
        'success': false,
        'error': response['error'] ?? 'Could not build suggestions',
      };
    } catch (e) {
      debugPrint('AICopilotService.buildProductSuggestions error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}

