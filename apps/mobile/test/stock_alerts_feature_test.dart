import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/core/services/stock_alerts_service.dart';
import 'package:daily_basket_mobile/features/catalog/presentation/widgets/notify_stock_sheet.dart';
import 'package:daily_basket_mobile/features/notifications/presentation/screens/back_to_stock_alerts_screen.dart';


class _MockHttpOverrides extends HttpOverrides {}

class _FakeStockAlertsService extends StockAlertsService {
  final List<Map<String, dynamic>> mockAlerts;
  bool subscribeCalled = false;
  bool toggleCalled = false;
  String? lastSubscribedProductId;

  _FakeStockAlertsService({List<Map<String, dynamic>>? alerts})
      : mockAlerts = alerts ??
            [
              {
                'id': 'bs1',
                'name': 'A2 Desi Cow Ghee 500ml',
                'brand': 'Daily Basket Farm Fresh',
                'price': '₹599',
                'mrp': '₹650',
                'status': 'RESTOCKED',
                'time': 'Restocked 10 mins ago',
                'notifyEnabled': true,
                'image': '',
              },
              {
                'id': 'bs2',
                'name': 'Alphonso Mangoes Box (1kg)',
                'brand': 'Devgad Premium',
                'price': '₹299',
                'mrp': '₹399',
                'status': 'OUT_OF_STOCK',
                'time': 'Expected restock today, 4 PM',
                'notifyEnabled': false,
                'image': '',
              },
            ];

  @override
  Future<Map<String, dynamic>> subscribe({
    required String productId,
    String? variantId,
    String? email,
    String? phone,
    String? productName,
  }) async {
    subscribeCalled = true;
    lastSubscribedProductId = productId;
    return {
      'success': true,
      'message': 'Alert registered successfully',
      'data': {
        'id': 'alert_123',
        'productId': productId,
      },
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAlerts() async {
    return List<Map<String, dynamic>>.from(mockAlerts);
  }

  @override
  Future<bool> toggleAlert(String alertId, bool isEnabled) async {
    toggleCalled = true;
    for (final item in mockAlerts) {
      if (item['id'] == alertId) {
        item['notifyEnabled'] = isEnabled;
      }
    }
    return true;
  }

  @override
  Future<bool> removeAlert(String alertId) async {
    mockAlerts.removeWhere((item) => item['id'] == alertId);
    return true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  group('StockAlertsService Unit Tests', () {
    test('subscribe returns success in test environment', () async {
      final service = StockAlertsService();
      final res = await service.subscribe(
        productId: 'prod_avocado',
        productName: 'Organic Hass Avocados',
      );
      expect(res['success'], isTrue);
      expect(res['message'], contains('Alert registered'));
    });

    test('fetchAlerts returns list in test environment', () async {
      final service = StockAlertsService();
      final list = await service.fetchAlerts();
      expect(list, isNotEmpty);
      expect(list.first['name'], contains('A2 Desi Cow Ghee'));
    });

    test('toggleAlert returns true', () async {
      final service = StockAlertsService();
      final success = await service.toggleAlert('bs1', false);
      expect(success, isTrue);
    });

    test('removeAlert returns true', () async {
      final service = StockAlertsService();
      final success = await service.removeAlert('bs1');
      expect(success, isTrue);
    });
  });

  group('NotifyStockSheet Widget Tests', () {
    testWidgets('renders product info, sold out badge, and restock banner',
        (tester) async {
      final fakeService = _FakeStockAlertsService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotifyStockSheet(
              productId: 'prod_alphonso',
              productName: 'Alphonso Mangoes 1kg',
              brand: 'Devgad Premium',
              unit: '1 kg',
              alertsService: fakeService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Notify When in Stock'), findsOneWidget);
      expect(find.text('Alphonso Mangoes 1kg'), findsOneWidget);
      expect(find.text('Devgad Premium'), findsOneWidget);
      expect(find.text('Sold Out'), findsOneWidget);
      expect(find.text('1 kg'), findsOneWidget);
      expect(find.text('Expected restock in 2–4 hours today'), findsOneWidget);
      expect(find.text('In-App & Push Notification'), findsOneWidget);
      expect(find.text('WhatsApp or SMS Alert'), findsOneWidget);
      expect(find.text('Email Alert'), findsOneWidget);
      expect(find.text('Notify Me When In Stock'), findsOneWidget);
    });

    testWidgets('submitting calls service and pops with true', (tester) async {
      final fakeService = _FakeStockAlertsService();
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await NotifyStockSheet.show(
                    ctx,
                    productId: 'prod_mango',
                    productName: 'Devgad Mangoes',
                    alertsService: fakeService,
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Notify When in Stock'), findsOneWidget);

      await tester.tap(find.text('Notify Me When In Stock'));
      await tester.pumpAndSettle();

      expect(fakeService.subscribeCalled, isTrue);
      expect(fakeService.lastSubscribedProductId, equals('prod_mango'));
      expect(result, isTrue);
    });
  });

  group('BackToStockAlertsScreen Widget Tests', () {
    testWidgets('displays restocked and out of stock items', (tester) async {
      final fakeService = _FakeStockAlertsService();

      await tester.pumpWidget(
        MaterialApp(
          home: BackToStockAlertsScreen(alertsService: fakeService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Track Favorite Restocks'), findsOneWidget);
      expect(find.text('A2 Desi Cow Ghee 500ml'), findsOneWidget);
      expect(find.text('RESTOCKED'), findsOneWidget);
      expect(find.text('Alphonso Mangoes Box (1kg)'), findsOneWidget);
      expect(find.text('OUT OF STOCK'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.text('Push Alert'), findsOneWidget);
    });

    testWidgets('toggling switch triggers toggleAlert on service',
        (tester) async {
      final fakeService = _FakeStockAlertsService();

      await tester.pumpWidget(
        MaterialApp(
          home: BackToStockAlertsScreen(alertsService: fakeService),
        ),
      );

      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(fakeService.toggleCalled, isTrue);
    });

    testWidgets('renders empty state when alerts list is empty',
        (tester) async {
      final fakeService = _FakeStockAlertsService(alerts: []);

      await tester.pumpWidget(
        MaterialApp(
          home: BackToStockAlertsScreen(alertsService: fakeService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No Stock Alerts Yet'), findsOneWidget);
      expect(
          find.text(
              'Items you set restock notifications for will appear here.'),
          findsOneWidget);
    });
  });
}
