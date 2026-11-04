import 'package:flutter/material.dart';
import '../models/daily_message_campaign.dart';
import '../models/admin_coupon.dart';
import '../services/admin_marketing_service.dart';

/// State management provider for Marketing & Daily Announcements
class AdminMarketingProvider extends ChangeNotifier {
  final AdminMarketingService _service;

  AdminMarketingProvider({AdminMarketingService? service})
      : _service = service ?? AdminMarketingService();

  List<DailyMessageCampaign> _campaigns = [];
  List<AdminCoupon> _coupons = [];
  bool _isLoading = false;
  bool _isDispatching = false;
  String? _errorMessage;
  Map<String, dynamic>? _lastDispatchResult;
  String _audienceFilter = 'ALL';

  List<DailyMessageCampaign> get campaigns => _audienceFilter == 'ALL'
      ? List.unmodifiable(_campaigns)
      : _campaigns.where((c) => c.audienceRole == _audienceFilter).toList();

  List<DailyMessageCampaign> get allCampaigns => List.unmodifiable(_campaigns);
  List<AdminCoupon> get coupons => List.unmodifiable(_coupons);
  bool get isLoading => _isLoading;
  bool get isDispatching => _isDispatching;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get lastDispatchResult => _lastDispatchResult;
  String get audienceFilter => _audienceFilter;

  DailyMessageCampaign? get activeCampaign {
    try {
      return _campaigns.firstWhere((c) => c.enabled);
    } catch (_) {
      return _campaigns.isNotEmpty ? _campaigns.first : null;
    }
  }

  int get totalDispatchedCount {
    return _campaigns.fold(0, (sum, c) => sum + c.outboxCount);
  }

  void setAudienceFilter(String filter) {
    _audienceFilter = filter;
    notifyListeners();
  }

  /// Load campaigns and coupons from API
  Future<void> loadMarketingData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchCampaigns(),
        _service.fetchCoupons(),
      ]);

      _campaigns = results[0] as List<DailyMessageCampaign>;
      _coupons = results[1] as List<AdminCoupon>;
    } catch (e) {
      _errorMessage = 'Failed to load marketing data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new campaign and prepend to list
  Future<bool> createCampaign({
    required String title,
    required String body,
    String audienceRole = 'CUSTOMER',
    bool enabled = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _service.createCampaign(
        title: title,
        body: body,
        audienceRole: audienceRole,
        enabled: enabled,
      );

      if (res['success'] == true) {
        final newCampaign = DailyMessageCampaign(
          id: res['campaign']?['id']?.toString() ??
              res['id']?.toString() ??
              'cmp_${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          body: body,
          contentHash: 'hash_${DateTime.now().millisecondsSinceEpoch}',
          audienceRole: audienceRole,
          enabled: enabled,
          createdAt: DateTime.now(),
          outboxCount: 0,
        );

        if (enabled) {
          // If this one is enabled, disable others if single active mode
          _campaigns = _campaigns.map((c) => c.copyWith(enabled: false)).toList();
        }

        _campaigns.insert(0, newCampaign);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = res['error'] ?? 'Could not create campaign';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Dispatch campaign broadcast to target user cohorts
  Future<Map<String, dynamic>> dispatchBroadcast([String? campaignId]) async {
    _isDispatching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final targetId = campaignId ?? activeCampaign?.id;
      final res = await _service.dispatchCampaign(targetId);

      _lastDispatchResult = res;

      // Update outbox count optimistically for the dispatched campaign
      if (res['success'] == true && targetId != null) {
        final index = _campaigns.indexWhere((c) => c.id == targetId);
        if (index != -1) {
          final current = _campaigns[index];
          final delivered = (res['deliveredCount'] as num?)?.toInt() ?? 500;
          _campaigns[index] = current.copyWith(
            outboxCount: current.outboxCount + delivered,
          );
        }
      }

      _isDispatching = false;
      notifyListeners();
      return res;
    } catch (e) {
      _errorMessage = e.toString();
      _isDispatching = false;
      notifyListeners();
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Toggle campaign active state
  void toggleCampaignEnabled(String campaignId) {
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      final isCurrentlyActive = _campaigns[index].enabled;
      if (!isCurrentlyActive) {
        // Deactivate others to have single active
        _campaigns = _campaigns.map((c) => c.copyWith(enabled: false)).toList();
      }
      _campaigns[index] = _campaigns[index].copyWith(enabled: !isCurrentlyActive);
      notifyListeners();
    }
  }

  /// Add a coupon code
  Future<bool> addCoupon(Map<String, dynamic> data) async {
    try {
      final res = await _service.createCoupon(data);
      if (res['success'] == true) {
        final coupon = AdminCoupon(
          id: res['coupon']?['id']?.toString() ??
              res['id']?.toString() ??
              'c_${DateTime.now().millisecondsSinceEpoch}',
          code: data['code']?.toString() ?? 'PROMO',
          description: data['description']?.toString() ?? '',
          discountType: data['discountType']?.toString() ?? 'FLAT',
          discountValue: (data['discountValue'] as num?)?.toDouble() ?? 50.0,
          minOrderValue: (data['minOrderValue'] as num?)?.toDouble() ?? 199.0,
          maxDiscount: (data['maxDiscount'] as num?)?.toDouble(),
          isActive: true,
          usageCount: 0,
        );
        _coupons.insert(0, coupon);
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Delete a coupon code
  Future<bool> deleteCoupon(String id) async {
    try {
      final success = await _service.deleteCoupon(id);
      if (success) {
        _coupons.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

