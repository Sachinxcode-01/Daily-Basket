import 'package:flutter/material.dart';

/// State management provider for Customer Wishlist & Favorites
class WishlistProvider extends ChangeNotifier {
  final Set<String> _wishlistIds = {'mlk4', 'crd1', 'chc1', 'stn3'};
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      'id': 'mlk4',
      'name': 'Organic Cow Milk',
      'brand': 'Akshayakalpa',
      'unit': '500 ml',
      'price': '₹46',
      'mrp': '₹50',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',
      'category': 'Dairy',
    },
    {
      'id': 'crd1',
      'name': 'Set Curd',
      'brand': 'Amul',
      'unit': '400 g Cup',
      'price': '₹42',
      'mrp': '₹45',
      'rating': 4.6,
      'imageUrl': 'https://images.unsplash.com/photo-1571512599285-9b05c2b06e99?w=400',
      'category': 'Dairy',
    },
    {
      'id': 'chc1',
      'name': 'Dairy Milk Silk',
      'brand': 'Cadbury',
      'unit': '150 g Bar',
      'price': '₹155',
      'mrp': '₹170',
      'rating': 4.8,
      'imageUrl': 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400',
      'category': 'Confectionery',
    },
  ];

  Set<String> get wishlistIds => Set.unmodifiable(_wishlistIds);
  List<Map<String, dynamic>> get wishlistItems => List.unmodifiable(_wishlistItems);
  int get count => _wishlistIds.length;

  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  void toggleWishlist(String productId, [Map<String, dynamic>? productData]) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
      _wishlistItems.removeWhere((item) => item['id'] == productId);
    } else {
      _wishlistIds.add(productId);
      if (productData != null) {
        _wishlistItems.insert(0, productData);
      } else {
        _wishlistItems.insert(0, {
          'id': productId,
          'name': 'Organic Hass Avocado',
          'brand': 'Fresh Farm',
          'unit': '2 pcs',
          'price': '₹180',
          'mrp': '₹200',
          'rating': 4.7,
          'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400',
          'category': 'Fresh Produce',
        });
      }
    }
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
      _wishlistItems.removeWhere((item) => item['id'] == productId);
      notifyListeners();
    }
  }

  void clearWishlist() {
    _wishlistIds.clear();
    _wishlistItems.clear();
    notifyListeners();
  }
}
