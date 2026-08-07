import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'cart_provider.dart';

export 'cart_provider.dart';

class PricingBreakdown {
  final double subtotal;
  final double itemDiscounts;
  final double couponDiscount;
  final double deliveryFee;
  final double platformFee;
  final double packagingFee;
  final double totalGst;
  final double grandTotal;
  final double walletDeducted;
  final double finalPayable;
  final String selectedPaymentMethod;
  final String? appliedCoupon;

  PricingBreakdown({
    required this.subtotal,
    required this.itemDiscounts,
    required this.couponDiscount,
    required this.deliveryFee,
    required this.platformFee,
    required this.packagingFee,
    required this.totalGst,
    required this.grandTotal,
    required this.walletDeducted,
    required this.finalPayable,
    required this.selectedPaymentMethod,
    this.appliedCoupon,
  });

  factory PricingBreakdown.fromMap(Map<String, dynamic> map) {
    return PricingBreakdown(
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      itemDiscounts: (map['itemDiscounts'] as num?)?.toDouble() ?? 0.0,
      couponDiscount: (map['couponDiscount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      platformFee: (map['platformFee'] as num?)?.toDouble() ?? 0.0,
      packagingFee: (map['packagingFee'] as num?)?.toDouble() ?? 0.0,
      totalGst: (map['totalGst'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (map['grandTotal'] as num?)?.toDouble() ?? 0.0,
      walletDeducted: (map['walletDeducted'] as num?)?.toDouble() ?? 0.0,
      finalPayable: (map['finalPayable'] as num?)?.toDouble() ?? 0.0,
      selectedPaymentMethod: (map['selectedPaymentMethod'] as String?) ?? 'UPI',
      appliedCoupon: map['appliedCoupon'] as String?,
    );
  }
}

/// CheckoutProvider — Global State Manager for Order Pricing & Payment Selection
class CheckoutProvider extends ChangeNotifier {
  final String baseUrl;

  String _selectedPaymentMethod = 'UPI';
  bool _useWallet = false;
  final double _userWalletBalance = 150.0;
  String? _appliedCouponCode;
  String _selectedSlot = 'Instant (10-15 mins)';
  String _selectedInstruction = 'Ring Bell';
  final bool _isProcessingPayment = false;

  PricingBreakdown? _pricing;

  CheckoutProvider({this.baseUrl = 'http://10.0.2.2:3000/api'});

  // Getters
  String get selectedPaymentMethod => _selectedPaymentMethod;
  bool get useWallet => _useWallet;
  double get userWalletBalance => _userWalletBalance;
  String? get appliedCouponCode => _appliedCouponCode;
  String get selectedSlot => _selectedSlot;
  String get selectedInstruction => _selectedInstruction;
  bool get isProcessingPayment => _isProcessingPayment;
  PricingBreakdown? get pricing => _pricing;

  // Set Payment Method (Instantly updates UI state & notifies listeners)
  void setPaymentMethod(String method) {
    if (_selectedPaymentMethod != method) {
      _selectedPaymentMethod = method;
      notifyListeners();
    }
  }

  // Toggle Wallet Usage
  void toggleWallet(bool value) {
    _useWallet = value;
    notifyListeners();
  }

  // Apply or Remove Coupon
  void setCoupon(String? code) {
    _appliedCouponCode = code;
    notifyListeners();
  }

  // Set Delivery Slot & Instructions
  void setDeliverySlot(String slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  void setInstruction(String inst) {
    _selectedInstruction = inst;
    notifyListeners();
  }

  // Recalculate Order Pricing (Calls Backend API `POST /orders/calculate` or instant client math)
  Future<PricingBreakdown> recalculatePricing({
    required List<CartItem> cartItems,
    String? couponOverride,
  }) async {
    final couponToUse = couponOverride ?? _appliedCouponCode;
    final itemsPayload = cartItems
        .map((item) => {
              'id': item.id,
              'productName': item.name,
              'price': item.price,
              'quantity': item.qty,
            })
        .toList();

    if (WidgetsBinding.instance.lifecycleState != null) {
      try {
        final client = HttpClient();
        final request = await client.postUrl(Uri.parse('$baseUrl/orders/calculate'));
        request.headers.set('content-type', 'application/json');
        request.write(jsonEncode({
          'items': itemsPayload,
          'couponCode': couponToUse,
          'useWallet': _useWallet || _selectedPaymentMethod == 'WALLET',
          'paymentMethod': _selectedPaymentMethod,
          'deliverySlot': _selectedSlot,
          'userWalletBalance': _userWalletBalance,
        }));
        final response = await request.close();

        if (response.statusCode == 200) {
          final bodyStr = await response.transform(utf8.decoder).join();
          final data = jsonDecode(bodyStr);
          _pricing = PricingBreakdown.fromMap(data);
          notifyListeners();
          return _pricing!;
        }
      } catch (_) {
        // Offline / Simulation Client Fallback Calculation
      }
    }

    // Client-side fallback calculation matching backend logic exactly
    double subtotal = 0.0;
    for (final item in cartItems) {
      subtotal += item.price * item.qty;
    }

    double couponDiscount = 0.0;
    if (couponToUse != null) {
      final code = couponToUse.toUpperCase().trim();
      if (code == 'DAILY50' && subtotal >= 199) {
        couponDiscount = 50.0;
      } else if (code == 'FRESH20' && subtotal >= 299) {
        couponDiscount = double.parse((subtotal * 0.2).toStringAsFixed(2));
      } else if (code == 'WELCOME100' && subtotal >= 499) {
        couponDiscount = 100.0;
      }
    }

    final deliveryFee = (subtotal >= 199 || subtotal == 0) ? 0.0 : 25.0;
    final platformFee = subtotal > 0 ? 3.0 : 0.0;
    final packagingFee = subtotal > 0 ? 5.0 : 0.0;

    final taxable = (subtotal - couponDiscount).clamp(0.0, double.infinity);
    final totalGst = double.parse((taxable * 0.05).toStringAsFixed(2));

    final grandTotal = (subtotal + deliveryFee + platformFee + packagingFee + totalGst - couponDiscount)
        .clamp(0.0, double.infinity);

    double walletDeducted = 0.0;
    if (_useWallet || _selectedPaymentMethod == 'WALLET') {
      walletDeducted = math.min(_userWalletBalance, grandTotal);
    }

    final finalPayable = math.max(0.0, grandTotal - walletDeducted);

    _pricing = PricingBreakdown(
      subtotal: subtotal,
      itemDiscounts: 0.0,
      couponDiscount: couponDiscount,
      deliveryFee: deliveryFee,
      platformFee: platformFee,
      packagingFee: packagingFee,
      totalGst: totalGst,
      grandTotal: grandTotal,
      walletDeducted: walletDeducted,
      finalPayable: finalPayable,
      selectedPaymentMethod: _selectedPaymentMethod,
      appliedCoupon: couponToUse,
    );

    notifyListeners();
    return _pricing!;
  }
}
