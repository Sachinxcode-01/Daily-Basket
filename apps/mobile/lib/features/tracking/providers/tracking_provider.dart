import 'dart:async';
import 'package:flutter/material.dart';

enum DeliveryOrderStatus { placed, packed, outForDelivery, delivered }

class TrackingProvider extends ChangeNotifier {
  DeliveryOrderStatus _status = DeliveryOrderStatus.outForDelivery;
  int _remainingSeconds = 480; // 8 minutes initial ETA
  double _driverLat = 12.9716;
  double _driverLng = 77.5946;
  Timer? _timer;

  final Map<String, dynamic> driverInfo = {
    'name': 'Ramesh Kumar',
    'rating': 4.9,
    'totalDeliveries': '1,240+',
    'phone': '+91 98765 43210',
    'vehicleNumber': 'KA-01-EV-4829',
    'vehicleType': 'Electric Scooter',
    'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
  };

  final List<Map<String, dynamic>> orderItems = [
    {
      'name': 'Organic Whole Milk',
      'qty': '2 Bags (1L)',
      'price': '₹120',
      'icon': '🥛',
    },
    {
      'name': 'Fresh Farm Eggs',
      'qty': '1 Pack (12 Pcs)',
      'price': '₹95',
      'icon': '🥚',
    },
    {
      'name': 'Alphonso Mangoes',
      'qty': '1 kg',
      'price': '₹350',
      'icon': '🥭',
    },
  ];

  DeliveryOrderStatus get status => _status;
  int get remainingSeconds => _remainingSeconds;
  double get driverLat => _driverLat;
  double get driverLng => _driverLng;

  String get etaDisplay {
    if (_remainingSeconds <= 0) return 'Arrived at your doorstep';
    final mins = (_remainingSeconds / 60).ceil();
    return 'Arriving in $mins ${mins == 1 ? "Min" : "Mins"}';
  }

  TrackingProvider() {
    _startLiveSimulation();
  }

  void _startLiveSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds -= 5; // accelerate ETA for live preview feel
        _driverLat += 0.0001;
        _driverLng += 0.0001;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _status = DeliveryOrderStatus.delivered;
          _timer?.cancel();
        }
        notifyListeners();
      }
    });
  }

  void updateStatus(DeliveryOrderStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
