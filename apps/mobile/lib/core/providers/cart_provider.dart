import 'package:flutter/foundation.dart';
import '../network/api_client.dart';

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
/// — starts with instant 120 FPS optimistic local state and synchronizes
/// with the persistent backend database via ApiClient.
class CartProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final List<CartItem> _items = [];

  // ─── Saved For Later ─────────────────────────────────────────────────────
  final List<CartItem> _savedForLater = [];

  CartProvider() {
    fetchCartFromApi();
  }

  List<CartItem> get items => List.unmodifiable(_items);
  List<CartItem> get savedForLater => List.unmodifiable(_savedForLater);

  int get itemTotal =>
      _items.fold(0, (sum, item) => sum + (item.price * item.qty).round());
  double get itemTotalDouble =>
      _items.fold(0.0, (sum, item) => sum + (item.price * item.qty));
  int get totalCount => _items.fold(0, (sum, item) => sum + item.qty);
  bool get isEmpty => _items.isEmpty;

  /// Fetch remote persistent cart and merge on app start
  Future<void> fetchCartFromApi() async {
    try {
      final res = await _apiClient.get('/cart');
      if (res['success'] == true && res['activeItems'] is List) {
        final activeItems = res['activeItems'] as List;
        if (activeItems.isNotEmpty && _items.isEmpty) {
          for (final raw in activeItems) {
            _items.add(CartItem(
              id: raw['variantId'] ?? raw['id'] ?? 'item_${DateTime.now().millisecondsSinceEpoch}',
              name: raw['productName'] ?? 'Item',
              subtitle: raw['unitName'] ?? '1 pack',
              price: (raw['price'] as num?)?.toDouble() ?? 50.0,
              qty: (raw['quantity'] as num?)?.toInt() ?? 1,
              image: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
            ));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('CartProvider fetchCart error (ignorable offline): $e');
    }
  }

  int getQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) { return _items[index].qty; }
    return 0;
  }

  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) { return; }
    final target = _items[index];
    final newQty = target.qty + delta;
    if (newQty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = target.copyWith(qty: newQty);
    }
    notifyListeners();

    // Background sync to backend
    _syncUpdateQuantity(target.id, newQty);
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
      final updatedQty = _items[index].qty + newItem.qty;
      _items[index] = _items[index].copyWith(qty: updatedQty);
      _syncUpdateQuantity(newItem.id, updatedQty);
    } else {
      _items.add(newItem);
      _syncAddItem(newItem);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      final removed = _items.removeAt(index);
      notifyListeners();
      _syncUpdateQuantity(removed.id, 0);
    }
  }

  void removeItemById(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    _syncUpdateQuantity(id, 0);
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
    _syncClearCart();
  }

  // ─── Private Async Synchronization ───────────────────────────────────────
  void _syncAddItem(CartItem item) {
    _apiClient.post('/cart/add', {
      'variantId': item.id,
      'productName': item.name,
      'unitName': item.subtitle,
      'price': item.price,
      'quantity': item.qty,
    }).then((_) {}).catchError((e) {
      debugPrint('Sync cart add error (offline fallback): $e');
    });
  }

  void _syncUpdateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      _apiClient.delete('/cart/item/$id').then((_) {}).catchError((e) {
        debugPrint('Sync cart delete error: $e');
      });
    } else {
      _apiClient.patch('/cart/item/$id', {'quantity': quantity}).then((_) {}).catchError((e) {
        debugPrint('Sync cart patch error: $e');
      });
    }
  }

  void _syncClearCart() {
    _apiClient.delete('/cart/clear').then((_) {}).catchError((e) {
      debugPrint('Sync cart clear error: $e');
    });
  }
}

