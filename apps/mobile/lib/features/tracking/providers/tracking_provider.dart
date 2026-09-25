import 'dart:async';
import 'package:flutter/material.dart';

enum DeliveryOrderStatus { placed, packed, outForDelivery, delivered }

class TrackingProvider extends ChangeNotifier {
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

  TrackingProvider() {
    _startLiveSimulation();
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
    _timer?.cancel();
    super.dispose();
  }
}
