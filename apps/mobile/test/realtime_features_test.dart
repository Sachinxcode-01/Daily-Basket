import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_mobile/core/providers/cart_provider.dart';
import 'package:daily_basket_mobile/core/providers/recently_viewed_provider.dart';
import 'package:daily_basket_mobile/core/services/daily_messages_service.dart';
import 'package:daily_basket_mobile/core/services/reviews_service.dart';
import 'package:daily_basket_mobile/core/services/ai_copilot_service.dart';
import 'package:daily_basket_mobile/features/home/presentation/widgets/daily_message_banner.dart';
import 'package:daily_basket_mobile/features/catalog/presentation/widgets/product_review_sheet.dart';
import 'package:daily_basket_mobile/features/home/presentation/widgets/ai_copilot_overlay.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  group('Option B: Daily Messages Feed Tests', () {
    test('DailyMessagesService returns todays message in test env', () async {
      final service = DailyMessagesService();
      final res = await service.fetchTodaysMessage();

      expect(res['success'], isTrue);
      expect(res['data']['title'], contains('Harvest'));
    });

    testWidgets('DailyMessageBanner renders announcement, title, and handles dismiss',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyMessageBanner(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LIVE ANNOUNCEMENT'), findsOneWidget);
      expect(find.text('Fresh Morning Harvest 🌿'), findsOneWidget);
      expect(find.byIcon(Icons.campaign_rounded), findsOneWidget);

      // Dismiss
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('LIVE ANNOUNCEMENT'), findsNothing);
    });
  });

  group('Option C: Product Reviews Modal Tests', () {
    test('ReviewsService submitReview, fetchProductReviews, voteHelpful',
        () async {
      final service = ReviewsService();

      final subRes = await service.submitReview(
        productId: 'prod_avocado',
        rating: 5,
        comment: 'Fresh Hass Avocados were creamy and perfectly ripe!',
        tags: ['Crisp & Fresh 🌿', 'Super Fast ⚡'],
      );
      expect(subRes['success'], isTrue);
      expect(subRes['message'], contains('review has been published'));

      final listRes = await service.fetchProductReviews('prod_avocado');
      expect(listRes['success'], isTrue);
      expect(listRes['reviews'], isNotEmpty);

      final voteRes = await service.voteHelpful('test_rev_1');
      expect(voteRes, isTrue);
    });

    testWidgets('ProductReviewSheet renders stars, tag chips, and submits review',
        (tester) async {
      Map<String, dynamic>? submittedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  submittedResult = await ProductReviewSheet.show(
                    ctx,
                    productId: 'prod_avocado',
                    productName: 'Organic Hass Avocados',
                  );
                },
                child: const Text('Open Review Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Review Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Rate & Review'), findsOneWidget);
      expect(find.text('Organic Hass Avocados'), findsOneWidget);
      expect(find.text('Crisp & Fresh 🌿'), findsOneWidget);

      // Tap a quick tag chip
      await tester.tap(find.text('Crisp & Fresh 🌿'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Submit Verified Review'));
      await tester.pumpAndSettle();

      expect(submittedResult, isNotNull);
      expect(submittedResult!['rating'], equals(5));
      expect(submittedResult!['tags'], contains('Crisp & Fresh 🌿'));
    });
  });

  group('Option D: AI Copilot Live History Tests', () {
    test('AICopilotService returns recommendations personalized by viewed IDs',
        () async {
      final service = AICopilotService();
      final res = await service.buildProductSuggestions(
        recentlyViewedIds: ['c1', 'mlk1'],
      );

      expect(res['success'], isTrue);
      expect(res['reason'], contains('recent exploration'));
      expect((res['items'] as List).length, greaterThan(0));
    });

    testWidgets('AICopilotOverlay responds to RecentlyViewedProvider and adds to cart',
        (tester) async {
      final rvProvider = RecentlyViewedProvider();
      final cartProvider = CartProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<RecentlyViewedProvider>.value(value: rvProvider),
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: AICopilotOverlay(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('AI Copilot Suggestions'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('Organic Hass Avocados (2 pcs)'), findsOneWidget);

      // Add item to cart from AI suggestion rail
      final addFinder = find.byIcon(Icons.add_rounded);
      expect(addFinder, findsWidgets);

      await tester.tap(addFinder.first);
      await tester.pumpAndSettle();

      expect(cartProvider.totalCount, greaterThan(0));
    });
  });
}
