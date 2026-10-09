import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';

enum DeliveryOrderStatus { placed, packed, outForDelivery, delivered }

class TrackingProvider extends ChangeNotifier {
  final String? orderId;
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  DeliveryOrderStatus _status = DeliveryOrderStatus.outForDelivery;
  int _remainingSeconds = 420; // 7 minutes initial ETA
  final int _initialSeconds = 420;
  double _driverLat = 12.9372;
  double _driverLng = 77.6210;
  String _currentStreet = '100 Feet Rd, Koramangala 4th Block';
  int _speedKmh = 24;
  final String _deliveryOtp = '4821';
  Timer? _timer;

  final Map<String, dynamic> driverInfo = {
    'name': 'Ramesh Kumar',
    'rating': 4.9,
    'totalDeliveries': '1,240+',
    'phone': '+91 98765 00112',
    'vehicleNumber': 'KA 01 EB 4821',
    'vehicleType': 'Electric Scooter (Eco-Friendly)',
    'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
  };

  final List<Map<String, dynamic>> orderItems = [
    {
      'name': 'Organic Cow Milk (1L)',
      'qty': '2 Bags',
      'price': '₹136',
      'icon': '🥛',
    },
    {
      'name': 'Fresh Farm Eggs (12 pcs)',
      'qty': '1 Pack',
      'price': '₹95',
      'icon': '🥚',
    },
    {
      'name': 'Alphonso Mangoes (1kg)',
      'qty': '1 Box',
      'price': '₹89',
      'icon': '🥭',
    },
  ];

  DeliveryOrderStatus get status => _status;
  int get remainingSeconds => _remainingSeconds;
  double get driverLat => _driverLat;
  double get driverLng => _driverLng;
  String get currentStreet => _currentStreet;
  int get speedKmh => _speedKmh;
  String get deliveryOtp => _deliveryOtp;

  double get progressRatio {
    if (_status == DeliveryOrderStatus.delivered) return 1.0;
    if (_status == DeliveryOrderStatus.placed) return 0.1;
    if (_status == DeliveryOrderStatus.packed) return 0.25;
    final ratio = 0.3 + 0.65 * (1.0 - (_remainingSeconds / _initialSeconds));
    return ratio.clamp(0.1, 0.95);
  }

  String get etaDisplay {
    if (_status == DeliveryOrderStatus.delivered) return 'Delivered at Doorstep';
    if (_remainingSeconds <= 0) return 'Arrived at your doorstep';
    final mins = (_remainingSeconds / 60).ceil();
    return 'Arriving in $mins ${mins == 1 ? "Min" : "Mins"}';
  }

  TrackingProvider({this.orderId}) {
    _startLiveSimulation();
    if (orderId != null && orderId!.isNotEmpty) {
      _fetchOrderTracking();
    }
  }

  Future<void> _fetchOrderTracking() async {
    final cleanId = orderId!.replaceAll('#', '').trim();
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _apiClient.get('/orders/$cleanId/tracking');
      if (res['success'] == true && res['order'] != null) {
        final orderData = res['order'];
        final stepStatus = res['stepStatus'] ?? orderData['status'];
        if (stepStatus == 'DELIVERED') {
          _status = DeliveryOrderStatus.delivered;
        } else if (stepStatus == 'OUT_FOR_DELIVERY') {
          _status = DeliveryOrderStatus.outForDelivery;
        } else if (stepStatus == 'PACKING' || stepStatus == 'READY_FOR_PICKUP') {
          _status = DeliveryOrderStatus.packed;
        } else {
          _status = DeliveryOrderStatus.placed;
        }

        if (res['driverLocation'] is Map) {
          final lat = res['driverLocation']['lat'];
          final lng = res['driverLocation']['lng'];
          if (lat is num && lng is num) {
            _driverLat = lat.toDouble();
            _driverLng = lng.toDouble();
          }
        }

        if (res['estimatedEtaMins'] is num) {
          _remainingSeconds = (res['estimatedEtaMins'] as num).toInt() * 60;
        }

        if (orderData['deliveryPartner'] is Map) {
          final dp = orderData['deliveryPartner'];
          driverInfo['name'] = dp['fullName'] ?? driverInfo['name'];
          driverInfo['phone'] = dp['phoneNumber'] ?? driverInfo['phone'];
          if (dp['avatarUrl'] != null) {
            driverInfo['avatarUrl'] = dp['avatarUrl'];
          }
        }

        if (orderData['items'] is List && (orderData['items'] as List).isNotEmpty) {
          orderItems.clear();
          for (var it in (orderData['items'] as List)) {
            final variant = it['variant'] ?? {};
            final product = variant['product'] ?? {};
            orderItems.add({
              'name': product['name'] ?? 'Grocery Item',
              'qty': '${it['quantity'] ?? 1} Pack',
              'price': '₹${it['totalPrice'] ?? it['price'] ?? 0}',
              'icon': '🛒',
            });
          }
        }
      }
    } catch (_) {
      // Graceful fallback to default simulation
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  void _startLiveSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_remainingSeconds > 0 && _status != DeliveryOrderStatus.delivered) {
        _remainingSeconds -= 15; // Smooth ETA reduction for live demo feel
        _driverLat += 0.0003;
        _driverLng -= 0.0002;

        if (_remainingSeconds <= 120) {
          _currentStreet = 'Near Sony World Signal, 100 Feet Rd';
          _speedKmh = 18;
        }
        if (_remainingSeconds <= 40) {
          _currentStreet = 'Entering Customer Gate (#42)';
          _speedKmh = 10;
        }
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _speedKmh = 0;
          _status = DeliveryOrderStatus.delivered;
          _currentStreet = 'Delivered at Customer Doorstep';
          _timer?.cancel();
        }
        notifyListeners();
      }
    });
  }

  void updateStatus(DeliveryOrderStatus newStatus) {
    _status = newStatus;
    if (newStatus == DeliveryOrderStatus.delivered) {
      _remainingSeconds = 0;
      _speedKmh = 0;
      _timer?.cancel();
    }
    notifyListeners();
  }

  void setDriverLocation(double lat, double lng) {
    _driverLat = lat;
    _driverLng = lng;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
