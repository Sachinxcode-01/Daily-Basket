import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final int qty;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.qty,
    required this.image,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? subtitle,
    double? price,
    int? qty,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      image: image ?? this.image,
    );
  }
}

/// Centralized state provider for customer Cart / Basket management
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(
      id: 'c1',
      name: 'Hass Avocados',
      subtitle: '2 pcs (approx. 400g)',
      price: 180.0,
      qty: 1,
      image: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=200&q=80',
    ),
    CartItem(
      id: 'c2',
      name: 'Farm Fresh Milk',
      subtitle: '1 Litre',
      price: 70.0,
      qty: 2,
      image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&q=80',
    ),
    CartItem(
      id: 'c3',
      name: 'Whole Wheat Bread',
      subtitle: '400g',
      price: 50.0,
      qty: 1,
      image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80',
    ),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemTotal => _items.fold(0, (sum, item) => sum + (item.price * item.qty).round());
  double get itemTotalDouble => _items.fold(0.0, (sum, item) => sum + (item.price * item.qty));
  int get totalCount => _items.fold(0, (sum, item) => sum + item.qty);

  int getQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      return _items[index].qty;
    }
    return 0;
  }

  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) return;
    final newQty = _items[index].qty + delta;
    if (newQty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(qty: newQty);
    }
    notifyListeners();
  }

  void updateQuantityById({
    required String id,
    required String name,
    required String subtitle,
    required double price,
    required String image,
    required int delta,
  }) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      updateQuantity(index, delta);
    } else if (delta > 0) {
      addItem(CartItem(
        id: id,
        name: name,
        subtitle: subtitle,
        price: price,
        qty: delta,
        image: image,
      ));
    }
  }

  void addItem(CartItem newItem) {
    final index = _items.indexWhere((item) => item.id == newItem.id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(qty: _items[index].qty + newItem.qty);
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
