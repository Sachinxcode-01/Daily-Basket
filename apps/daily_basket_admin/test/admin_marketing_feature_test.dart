import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_admin/core/models/daily_message_campaign.dart';
import 'package:daily_basket_admin/core/models/admin_coupon.dart';
import 'package:daily_basket_admin/core/providers/admin_marketing_provider.dart';
import 'package:daily_basket_admin/features/marketing/presentation/screens/admin_marketing_screen.dart';

void main() {
  group('DailyMessageCampaign Model Tests', () {
    test('Correctly parses from JSON with Prisma relation count', () {
      final json = {
        'id': 'cmp_123',
        'title': 'Monsoon Organic Harvest 🌿',
        'body': 'Crisp organic greens delivered in 10 minutes.',
        'contentHash': 'hash_test_123',
        'audienceRole': 'CUSTOMER',
        'enabled': true,
        'createdAt': '2026-11-04T07:00:00.000Z',
        '_count': {'outboxRows': 4850},
      };

      final campaign = DailyMessageCampaign.fromJson(json);

      expect(campaign.id, 'cmp_123');
      expect(campaign.title, 'Monsoon Organic Harvest 🌿');
      expect(campaign.body, 'Crisp organic greens delivered in 10 minutes.');
      expect(campaign.audienceRole, 'CUSTOMER');
      expect(campaign.enabled, isTrue);
      expect(campaign.outboxCount, 4850);
      expect(campaign.isDefaultFallback, isFalse);
    });

    test('Serializes to JSON and supports copyWith', () {
      final campaign = DailyMessageCampaign(
        id: 'c1',
        title: 'Original Title',
        body: 'Original Body',
        contentHash: 'hash1',
        audienceRole: 'VIP',
        enabled: false,
        createdAt: DateTime(2026, 11, 4),
        outboxCount: 100,
      );

      final updated = campaign.copyWith(title: 'Updated Title', enabled: true);
      expect(updated.title, 'Updated Title');
      expect(updated.enabled, isTrue);
      expect(updated.id, 'c1');
      expect(updated.outboxCount, 100);

      final json = updated.toJson();
      expect(json['title'], 'Updated Title');
      expect(json['enabled'], isTrue);
    });
  });

  group('AdminCoupon Model Tests', () {
    test('Correctly parses percentage and flat discount coupons', () {
      final percentageJson = {
        'id': 'cp_1',
        'code': 'MEGA50',
        'description': '50% off on fresh produce',
        'discountType': 'PERCENTAGE',
        'discountValue': 50,
        'minOrderValue': 199,
        'usageCount': 240,
      };

      final coupon = AdminCoupon.fromJson(percentageJson);
      expect(coupon.code, 'MEGA50');
      expect(coupon.discountDisplay, '50% OFF');
      expect(coupon.minOrderValue, 199.0);
      expect(coupon.usageCount, 240);

      final flatJson = {
        'id': 'cp_2',
        'code': 'FLAT100',
        'description': 'Flat 100 discount',
        'discountType': 'FLAT',
        'discountValue': 100,
        'minOrderValue': 499,
      };

      final flatCoupon = AdminCoupon.fromJson(flatJson);
      expect(flatCoupon.code, 'FLAT100');
      expect(flatCoupon.discountDisplay, '₹100 OFF');
    });
  });

  group('AdminMarketingProvider State & Actions', () {
    test('Loads campaigns and coupons, computes totals and active campaign', () async {
      final provider = AdminMarketingProvider();
      await provider.loadMarketingData();

      expect(provider.isLoading, isFalse);
      expect(provider.campaigns.isNotEmpty, isTrue);
      expect(provider.coupons.isNotEmpty, isTrue);
      expect(provider.activeCampaign, isNotNull);
      expect(provider.totalDispatchedCount, greaterThan(0));
    });

    test('Can create a new campaign and set it as active', () async {
      final provider = AdminMarketingProvider();
      await provider.loadMarketingData();

      final initialCount = provider.campaigns.length;
      final success = await provider.createCampaign(
        title: 'Diwali Sweet Crunch 🪔',
        body: 'Artisanal ladoos & dry fruit boxes delivered instantly.',
        audienceRole: 'CUSTOMER',
        enabled: true,
      );

      expect(success, isTrue);
      expect(provider.campaigns.length, initialCount + 1);
      expect(provider.activeCampaign?.title, 'Diwali Sweet Crunch 🪔');
    });

    test('Can dispatch broadcast and record outbox counts', () async {
      final provider = AdminMarketingProvider();
      await provider.loadMarketingData();

      final active = provider.activeCampaign!;
      final initialOutbox = active.outboxCount;

      final res = await provider.dispatchBroadcast(active.id);
      expect(res['success'], isTrue);
      expect(res['deliveredCount'], greaterThan(0));

      final updated = provider.campaigns.firstWhere((c) => c.id == active.id);
      expect(updated.outboxCount, greaterThan(initialOutbox));
    });

    test('Can add and delete coupons', () async {
      final provider = AdminMarketingProvider();
      await provider.loadMarketingData();

      final initialCount = provider.coupons.length;
      final added = await provider.addCoupon({
        'code': 'TESTCODE',
        'description': 'Test coupon for testing',
        'discountType': 'FLAT',
        'discountValue': 50,
        'minOrderValue': 150,
      });

      expect(added, isTrue);
      expect(provider.coupons.length, initialCount + 1);

      final newCoupon = provider.coupons.firstWhere((c) => c.code == 'TESTCODE');
      final deleted = await provider.deleteCoupon(newCoupon.id);
      expect(deleted, isTrue);
      expect(provider.coupons.any((c) => c.code == 'TESTCODE'), isFalse);
    });
  });

  group('AdminMarketingScreen UI Rendering', () {
    testWidgets('Renders Marketing & Growth Hub with KPI cards and tabs', (WidgetTester tester) async {
      final provider = AdminMarketingProvider();
      await provider.loadMarketingData();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AdminMarketingProvider>.value(
            value: provider,
            child: const AdminMarketingScreen(),
          ),
        ),
      );

      await tester.pump();

      // Verify Header
      expect(find.text('Marketing & Growth Hub'), findsOneWidget);
      expect(find.text('Daily Messages'), findsOneWidget);
      expect(find.text('Coupons & Vouchers'), findsOneWidget);

      // Verify KPI Metrics
      expect(find.text('Outbox Dispatched'), findsOneWidget);
      expect(find.text('Active Daily Promo'), findsOneWidget);
      expect(find.text('Total Campaigns'), findsOneWidget);

      // Verify Broadcast Action Card
      expect(find.text('CURRENT ACTIVE MORNING MESSAGE'), findsOneWidget);
      expect(find.text('Broadcast Now ⚡'), findsOneWidget);

      // Switch to Coupons Tab
      await tester.tap(find.text('Coupons & Vouchers'));
      await tester.pumpAndSettle();

      expect(find.text('Add Coupon'), findsOneWidget);
      expect(find.text('WELCOME100'), findsOneWidget);
    });
  });
}
