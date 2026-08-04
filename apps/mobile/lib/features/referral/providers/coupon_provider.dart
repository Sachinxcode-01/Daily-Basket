import 'package:flutter/material.dart';

class Coupon {
  final String id;
  final String code;
  final String title;
  final String subtitle;
  final String discountDisplay;
  final String discountSub;
  final Color discountBg;
  final Color discountColor;
  final String expiry;
  final IconData icon;
  final String category;
  final double minOrderAmount;
  final double? percentage;
  final double? flatDiscount;
  final bool isFreeDelivery;

  Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.discountDisplay,
    required this.discountSub,
    required this.discountBg,
    required this.discountColor,
    required this.expiry,
    required this.icon,
    required this.category,
    this.minOrderAmount = 0.0,
    this.percentage,
    this.flatDiscount,
    this.isFreeDelivery = false,
  });
}

class ApplyCouponResult {
  final bool success;
  final String message;

  ApplyCouponResult(this.success, this.message);
}

class CouponProvider extends ChangeNotifier {
  Coupon? _appliedCoupon;
  Coupon? get appliedCoupon => _appliedCoupon;

  // Available coupons registry
  final List<Coupon> _allCoupons = [
    Coupon(
      id: 'c1',
      code: 'ORGANIC15',
      title: 'Organic Staples Promo',
      subtitle: 'Valid on all organic pulses and grains above \$50 / ₹50.',
      discountDisplay: '15%',
      discountSub: 'OFF',
      discountBg: const Color(0xFFE8F5E9),
      discountColor: const Color(0xFF006B23),
      expiry: 'EXPIRES IN 3 DAYS',
      icon: Icons.verified_user_outlined,
      category: 'Grocery',
      minOrderAmount: 50.0,
      percentage: 0.15,
    ),
    Coupon(
      id: 'c2',
      code: 'DAIRY10',
      title: 'Dairy Delights',
      subtitle: 'Get flat \$10 / ₹10 cashback on milk & cheese orders over \$30 / ₹30.',
      discountDisplay: '\$10',
      discountSub: 'CASHBACK',
      discountBg: const Color(0xFFF3F3F6),
      discountColor: const Color(0xFF1A1C1E),
      expiry: 'VALID TILL 30 SEP',
      icon: Icons.star_outline_rounded,
      category: 'Dairy',
      minOrderAmount: 30.0,
      flatDiscount: 10.0,
    ),
    Coupon(
      id: 'c3',
      code: 'SHIPFREE',
      title: 'Weekend Special',
      subtitle: 'Free delivery on all orders above \$20 / ₹20 this weekend.',
      discountDisplay: 'Free',
      discountSub: 'DELIVERY',
      discountBg: const Color(0xFFFFEBEE),
      discountColor: const Color(0xFFD32F2F),
      expiry: 'VALID THIS WEEKEND',
      icon: Icons.local_shipping_outlined,
      category: 'Grocery',
      minOrderAmount: 20.0,
      isFreeDelivery: true,
    ),
    Coupon(
      id: 'c4',
      code: 'DAILY100',
      title: 'Mega Saver Coupon',
      subtitle: 'Flat \$100 / ₹100 discount on orders above \$300 / ₹300.',
      discountDisplay: '\$100',
      discountSub: 'OFF',
      discountBg: const Color(0xFFE3F2FD),
      discountColor: const Color(0xFF1E88E5),
      expiry: 'EXPIRES IN 7 DAYS',
      icon: Icons.card_giftcard_rounded,
      category: 'Grocery',
      minOrderAmount: 300.0,
      flatDiscount: 100.0,
    ),
    Coupon(
      id: 'c5',
      code: 'DAILY20-USER',
      title: 'Referral Special Bonus',
      subtitle: 'Special referral bonus coupon applied from your friend!',
      discountDisplay: '\$20',
      discountSub: 'BONUS',
      discountBg: const Color(0xFFFFF3E0),
      discountColor: const Color(0xFFE65100),
      expiry: 'ALWAYS VALID',
      icon: Icons.celebration_rounded,
      category: 'All Offers',
      minOrderAmount: 0.0,
      flatDiscount: 20.0,
    ),
  ];

  List<Coupon> get availableCoupons => List.unmodifiable(_allCoupons);

  // Referral metrics & state
  final String referralCode = 'DAILY20-USER';
  final double _referralEarnings = 60.0;
  double get referralEarnings => _referralEarnings;

  final List<Map<String, dynamic>> _referrals = [
    {
      'id': 'r1',
      'name': 'Sarah Jenkins',
      'date': 'Oct 24, 2023',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'amount': '+\$20',
      'hint': 'Reward credited to wallet',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
      'canClaim': false,
    },
    {
      'id': 'r2',
      'name': 'Marcus Chen',
      'date': 'Nov 02, 2023',
      'status': 'JOINED',
      'statusColor': const Color(0xFF1E88E5),
      'statusBg': const Color(0xFFE3F2FD),
      'amount': '+\$20',
      'hint': 'Waiting for first order',
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
      'canClaim': false,
    },
    {
      'id': 'r3',
      'name': 'Elena Rodriguez',
      'date': 'Oct 18, 2023',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'amount': '+\$20',
      'hint': 'Reward credited to wallet',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
      'canClaim': false,
    },
    {
      'id': 'r4',
      'name': 'David Wu',
      'date': 'Nov 05, 2023',
      'status': 'PENDING',
      'statusColor': const Color(0xFFE65100),
      'statusBg': const Color(0xFFFFF3E0),
      'amount': '+\$20',
      'hint': 'Invitation sent via SMS',
      'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80',
      'canClaim': false,
    },
    {
      'id': 'r5',
      'name': 'Aisha Khan',
      'date': 'Oct 12, 2023',
      'status': 'COMPLETED',
      'statusColor': const Color(0xFF006B23),
      'statusBg': const Color(0xFFE8F5E9),
      'amount': '+\$20',
      'hint': 'Reward credited to wallet',
      'avatarUrl': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80',
      'canClaim': false,
    },
  ];

  List<Map<String, dynamic>> get referrals => List.unmodifiable(_referrals);

  int get totalInvited => _referrals.length;
  int get successfulReferrals => _referrals.where((r) => r['status'] == 'COMPLETED').length;
  int get pendingReferrals => _referrals.where((r) => r['status'] != 'COMPLETED').length;

  // Real-time calculations
  double calculateDiscount(double itemTotal) {
    if (_appliedCoupon == null) return 0.0;
    if (itemTotal < _appliedCoupon!.minOrderAmount) return 0.0;

    if (_appliedCoupon!.percentage != null) {
      return itemTotal * _appliedCoupon!.percentage!;
    }
    if (_appliedCoupon!.flatDiscount != null) {
      return _appliedCoupon!.flatDiscount! > itemTotal
          ? itemTotal
          : _appliedCoupon!.flatDiscount!;
    }
    return 0.0;
  }

  double calculateDeliveryFee(double standardDeliveryFee, double itemTotal) {
    if (_appliedCoupon != null &&
        _appliedCoupon!.isFreeDelivery &&
        itemTotal >= _appliedCoupon!.minOrderAmount) {
      return 0.0;
    }
    return standardDeliveryFee;
  }

  ApplyCouponResult applyCoupon(Coupon coupon, double itemTotal) {
    if (itemTotal < coupon.minOrderAmount) {
      return ApplyCouponResult(
        false,
        'Add items worth \$${(coupon.minOrderAmount - itemTotal).toStringAsFixed(2)} / ₹${(coupon.minOrderAmount - itemTotal).toStringAsFixed(0)} more to apply "${coupon.code}"',
      );
    }

    _appliedCoupon = coupon;
    notifyListeners();
    return ApplyCouponResult(
      true,
      'Coupon "${coupon.code}" applied successfully!',
    );
  }

  ApplyCouponResult applyCouponByCode(String code, double itemTotal) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return ApplyCouponResult(false, 'Please enter a coupon code.');
    }

    final match = _allCoupons.firstWhere(
      (c) => c.code.toUpperCase() == cleanCode,
      orElse: () => Coupon(
        id: 'invalid',
        code: cleanCode,
        title: 'Custom Promo',
        subtitle: 'Promotional Code',
        discountDisplay: 'Discount',
        discountSub: 'APPLIED',
        discountBg: const Color(0xFFE8F5E9),
        discountColor: const Color(0xFF006B23),
        expiry: 'PROMO',
        icon: Icons.local_offer,
        category: 'Custom',
      ),
    );

    if (match.id == 'invalid') {
      final customCoupon = Coupon(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        code: cleanCode,
        title: 'Promo $cleanCode',
        subtitle: 'Exclusive user promo discount applied',
        discountDisplay: '10%',
        discountSub: 'OFF',
        discountBg: const Color(0xFFE8F5E9),
        discountColor: const Color(0xFF006B23),
        expiry: 'LIMITED TIME',
        icon: Icons.local_offer_rounded,
        category: 'Special',
        percentage: 0.10,
        minOrderAmount: 0.0,
      );
      _appliedCoupon = customCoupon;
      notifyListeners();
      return ApplyCouponResult(true, 'Promo Code "$cleanCode" applied! 10% OFF');
    }

    return applyCoupon(match, itemTotal);
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  ApplyCouponResult redeemReferralCode(String code, double itemTotal) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return ApplyCouponResult(false, 'Please enter a valid referral code.');
    }

    final referralCoupon = Coupon(
      id: 'ref_${DateTime.now().millisecondsSinceEpoch}',
      code: cleanCode,
      title: 'Referral Bonus ($cleanCode)',
      subtitle: 'Special friend referral code discount applied',
      discountDisplay: '\$20',
      discountSub: 'BONUS',
      discountBg: const Color(0xFFFFF3E0),
      discountColor: const Color(0xFFE65100),
      expiry: 'REFERRAL',
      icon: Icons.card_giftcard_rounded,
      category: 'Referral',
      flatDiscount: 20.0,
      minOrderAmount: 0.0,
    );

    _appliedCoupon = referralCoupon;
    notifyListeners();
    return ApplyCouponResult(
      true,
      'Referral code "$cleanCode" redeemed! \$20 / ₹20 discount applied to cart.',
    );
  }

  void addReferral(String name) {
    _referrals.insert(0, {
      'id': 'r_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'date': 'Just Now',
      'status': 'PENDING',
      'statusColor': const Color(0xFFE65100),
      'statusBg': const Color(0xFFFFF3E0),
      'amount': '+\$20',
      'hint': 'Invitation sent',
      'avatarUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
      'canClaim': false,
    });
    notifyListeners();
  }
}
