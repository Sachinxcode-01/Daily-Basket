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
  bool get orderStatus => _notificationsEnabled && _orderStatus;
  bool get deliveryTracking => _notificationsEnabled && _deliveryTracking;
  bool get receipts => _notificationsEnabled && _receipts;
  bool get flashDeals => _notificationsEnabled && _flashDeals;
  bool get personalizedDiscounts => _notificationsEnabled && _personalizedDiscounts;
  bool get newsletter => _notificationsEnabled && _newsletter;
  bool get walletUpdates => _notificationsEnabled && _walletUpdates;

  bool get rawOrderStatus => _orderStatus;
  bool get rawDeliveryTracking => _deliveryTracking;
  bool get rawReceipts => _receipts;
  bool get rawFlashDeals => _flashDeals;
  bool get rawPersonalizedDiscounts => _personalizedDiscounts;
  bool get rawNewsletter => _newsletter;
  bool get rawWalletUpdates => _walletUpdates;

  void setNotificationsEnabled(bool val) {
    _notificationsEnabled = val;
    if (val) {
      _orderStatus = true;
      _deliveryTracking = true;
      _receipts = true;
      _personalizedDiscounts = true;
      _walletUpdates = true;
    } else {
      _orderStatus = false;
      _deliveryTracking = false;
      _receipts = false;
      _flashDeals = false;
      _personalizedDiscounts = false;
      _newsletter = false;
      _walletUpdates = false;
    }
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

  void toggleAllNotifications(bool val) {
    _notificationsEnabled = val;
    _orderStatus = val;
    _deliveryTracking = val;
    _receipts = val;
    _flashDeals = val;
    _personalizedDiscounts = val;
    _newsletter = val;
    _walletUpdates = val;
    notifyListeners();
  }
}
