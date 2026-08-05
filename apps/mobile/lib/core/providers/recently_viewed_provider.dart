import 'package:flutter/material.dart';

/// State management provider for Recently Viewed products
class RecentlyViewedProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [
    {
      'id': 'c1',
      'name': 'Hass Avocados',
      'brand': 'Organic Produce',
      'unit': '2 pcs (approx. 400g)',
      'price': '₹180',
      'mrp': '₹200',
      'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200&q=80',
    },
    {
      'id': 'mlk1',
      'name': 'Full Cream Milk',
      'brand': 'Amul',
      'unit': '1 L Pouch',
      'price': '₹64',
      'mrp': '₹68',
      'imageUrl': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
    },
    {
      'id': 'att1',
      'name': 'Chakki Fresh Atta',
      'brand': 'Aashirvaad',
      'unit': '5 kg Bag',
      'price': '₹242',
      'mrp': '₹265',
      'imageUrl': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
    },
  ];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  void addRecentlyViewed(Map<String, dynamic> product) {
    final productId = product['id'];
    _items.removeWhere((item) => item['id'] == productId);
    _items.insert(0, product);
    if (_items.length > 10) {
      _items.removeLast();
    }
    notifyListeners();
  }

  void clearRecentlyViewed() {
    _items.clear();
    notifyListeners();
  }
}
