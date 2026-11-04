/// Admin Coupon & Promo Code Model
class AdminCoupon {
  final String id;
  final String code;
  final String description;
  final String discountType; // 'PERCENTAGE' or 'FLAT'
  final double discountValue;
  final double minOrderValue;
  final double? maxDiscount;
  final DateTime? validUntil;
  final bool isActive;
  final int usageCount;

  AdminCoupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    this.maxDiscount,
    this.validUntil,
    this.isActive = true,
    this.usageCount = 0,
  });

  factory AdminCoupon.fromJson(Map<String, dynamic> json) {
    return AdminCoupon(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      discountType: json['discountType']?.toString() ?? 'PERCENTAGE',
      discountValue: (json['discountValue'] as num?)?.toDouble() ??
          (json['value'] as num?)?.toDouble() ??
          0.0,
      minOrderValue: (json['minOrderValue'] as num?)?.toDouble() ??
          (json['minOrder'] as num?)?.toDouble() ??
          0.0,
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'].toString())
          : (json['expiresAt'] != null
              ? DateTime.tryParse(json['expiresAt'].toString())
              : null),
      isActive: json['isActive'] != false && json['status'] != 'EXPIRED',
      usageCount: (json['usageCount'] as num?)?.toInt() ??
          (json['redemptions'] as num?)?.toInt() ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'maxDiscount': maxDiscount,
      'validUntil': validUntil?.toIso8601String(),
      'isActive': isActive,
      'usageCount': usageCount,
    };
  }

  String get discountDisplay {
    if (discountType == 'PERCENTAGE') {
      return '${discountValue.toInt()}% OFF';
    }
    return '₹${discountValue.toInt()} OFF';
  }
}
