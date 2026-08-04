import 'package:flutter/material.dart';

/// State management provider for Notification Preferences
class NotificationProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _orderStatus = true;
  bool _deliveryTracking = true;
  bool _receipts = true;
  bool _flashDeals = false;
  bool _personalizedDiscounts = true;
  bool _newsletter = false;
  bool _walletUpdates = true;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get orderStatus => _orderStatus;
  bool get deliveryTracking => _deliveryTracking;
  bool get receipts => _receipts;
  bool get flashDeals => _flashDeals;
  bool get personalizedDiscounts => _personalizedDiscounts;
  bool get newsletter => _newsletter;
  bool get walletUpdates => _walletUpdates;

  void setNotificationsEnabled(bool val) {
    _notificationsEnabled = val;
    notifyListeners();
  }

  void setOrderStatus(bool val) {
    _orderStatus = val;
    notifyListeners();
  }

  void setDeliveryTracking(bool val) {
    _deliveryTracking = val;
    notifyListeners();
  }

  void setReceipts(bool val) {
    _receipts = val;
    notifyListeners();
  }

  void setFlashDeals(bool val) {
    _flashDeals = val;
    notifyListeners();
  }

  void setPersonalizedDiscounts(bool val) {
    _personalizedDiscounts = val;
    notifyListeners();
  }

  void setNewsletter(bool val) {
    _newsletter = val;
    notifyListeners();
  }

  void setWalletUpdates(bool val) {
    _walletUpdates = val;
    notifyListeners();
  }
}
