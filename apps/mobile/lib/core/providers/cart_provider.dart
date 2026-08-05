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

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'subtitle': subtitle,
    'price': price,
    'qty': qty,
    'image': image,
  };
}

/// Centralized state provider for customer Cart / Basket management
/// — starts EMPTY. Items are added via product and home screens.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // ─── Saved For Later ─────────────────────────────────────────────────────
  final List<CartItem> _savedForLater = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<CartItem> get savedForLater => List.unmodifiable(_savedForLater);

  int get itemTotal =>
      _items.fold(0, (sum, item) => sum + (item.price * item.qty).round());
  double get itemTotalDouble =>
      _items.fold(0.0, (sum, item) => sum + (item.price * item.qty));
  int get totalCount => _items.fold(0, (sum, item) => sum + item.qty);
  bool get isEmpty => _items.isEmpty;

  int getQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) { return _items[index].qty; }
    return 0;
  }

  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) { return; }
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

  void removeItemById(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Move item from cart to Saved For Later list
  void saveForLater(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) { return; }
    final item = _items[index];
    _items.removeAt(index);
    final sflIndex = _savedForLater.indexWhere((i) => i.id == id);
    if (sflIndex != -1) {
      _savedForLater[sflIndex] = item;
    } else {
      _savedForLater.add(item);
    }
    notifyListeners();
  }

  /// Move item from Saved For Later back to cart
  void moveToCart(String id) {
    final index = _savedForLater.indexWhere((item) => item.id == id);
    if (index == -1) { return; }
    final item = _savedForLater[index];
    _savedForLater.removeAt(index);
    addItem(item);
  }

  /// Remove from Saved For Later entirely
  void removeSavedForLater(String id) {
    _savedForLater.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Bulk add — used by Reorder action
  void reorderItems(List<CartItem> items) {
    for (final item in items) {
      addItem(item);
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
