import 'package:flutter/material.dart';

class AdminDashboardProvider extends ChangeNotifier {
  double _todayRevenue = 38450.0;
  int _todayOrders = 142;
  final int _pendingOrders = 12;
  final int _activeRiders = 42;
  final double _systemHealth = 99.98;


  double get todayRevenue => _todayRevenue;
  int get todayOrders => _todayOrders;
  int get pendingOrders => _pendingOrders;
  int get activeRiders => _activeRiders;
  double get systemHealth => _systemHealth;

  void refreshMetrics() {
    _todayRevenue += 240.0;
    _todayOrders += 1;
    notifyListeners();
  }
}
