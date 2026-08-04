import 'package:flutter/material.dart';

class WalletTransaction {
  final String id;
  final String title;
  final String date;
  final double amount;
  final bool isCredit;
  final String type; // 'RECHARGE', 'REFERRAL', 'CASHBACK', 'ORDER_PAYMENT'
  final String status;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.type,
    this.status = 'COMPLETED',
  });
}

class WalletProvider extends ChangeNotifier {
  double _balance = 150.0;
  bool _useWalletForPayment = false;

  final List<WalletTransaction> _transactions = [
    WalletTransaction(
      id: 'tx_101',
      title: 'Added Money to Wallet',
      date: 'Today, 02:15 PM',
      amount: 100.0,
      isCredit: true,
      type: 'RECHARGE',
    ),
    WalletTransaction(
      id: 'tx_102',
      title: 'Referral Bonus Reward',
      date: 'Yesterday, 06:40 PM',
      amount: 20.0,
      isCredit: true,
      type: 'REFERRAL',
    ),
    WalletTransaction(
      id: 'tx_103',
      title: 'Order Payment #ORD-8912',
      date: 'Oct 28, 2023',
      amount: 45.0,
      isCredit: false,
      type: 'ORDER_PAYMENT',
    ),
    WalletTransaction(
      id: 'tx_104',
      title: 'Weekly Organic Cashback',
      date: 'Oct 24, 2023',
      amount: 15.0,
      isCredit: true,
      type: 'CASHBACK',
    ),
  ];

  double get balance => _balance;
  bool get useWalletForPayment => _useWalletForPayment;
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  void toggleWalletPayment(bool value) {
    _useWalletForPayment = value;
    notifyListeners();
  }

  void addFunds(double amount, String method) {
    if (amount <= 0) return;
    _balance += amount;
    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Recharge via $method',
        date: 'Just now',
        amount: amount,
        isCredit: true,
        type: 'RECHARGE',
      ),
    );
    notifyListeners();
  }

  double calculateWalletDeduction(double orderTotal) {
    if (!_useWalletForPayment || _balance <= 0) return 0.0;
    if (_balance >= orderTotal) return orderTotal;
    return _balance;
  }

  bool deductForOrder(double amount, String orderId) {
    if (_balance < amount) return false;
    _balance -= amount;
    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Order Payment #$orderId',
        date: 'Just now',
        amount: amount,
        isCredit: false,
        type: 'ORDER_PAYMENT',
      ),
    );
    notifyListeners();
    return true;
  }
}
