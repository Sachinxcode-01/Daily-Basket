import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Runtime Customer Journey Verification Suite', () {
    testWidgets('1. App Launch & Splash Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(DailyBasketApp), findsOneWidget);
    });

    testWidgets('2. Customer Home Screen & Bottom Navigation Bar Tabs Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pump(const Duration(milliseconds: 300));

      final navContext = tester.element(find.byType(Navigator));
      Navigator.pushReplacementNamed(navContext, '/customer/home');
      await tester.pump(const Duration(milliseconds: 500));

      // Verify Home Feed Header
      expect(find.text('Daily Basket'), findsWidgets);

      // Tap Categories Tab (Index 1)
      final categoriesTab = find.text('Categories').last;
      await tester.tap(categoriesTab);
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Search Tab (Index 2)
      final searchTab = find.text('Search').last;
      await tester.tap(searchTab);
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Cart Tab (Index 3)
      final cartTab = find.text('Cart').last;
      await tester.tap(cartTab);
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Orders Tab (Index 4)
      final ordersTab = find.text('Orders').last;
      await tester.tap(ordersTab);
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Profile Tab (Index 5)
      final profileTab = find.text('Profile').last;
      await tester.tap(profileTab);
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('3. Product Details Navigation & Cart Binding Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pump(const Duration(milliseconds: 300));

      final navContext = tester.element(find.byType(Navigator));
      Navigator.pushReplacementNamed(navContext, '/customer/home');
      await tester.pump(const Duration(milliseconds: 500));

      // Tap Organic Hass Avocados Product Card
      final productCard = find.text('Organic Hass Avocados');
      expect(productCard, findsOneWidget);
      await tester.tap(productCard);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Organic Hass Avocados'), findsWidgets);
    });

    testWidgets('4. Checkout & Payment Navigation Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pump(const Duration(milliseconds: 300));

      final navContext = tester.element(find.byType(Navigator));
      Navigator.pushNamed(navContext, '/cart');
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Cart'), findsWidgets);

      Navigator.pushNamed(navContext, '/checkout');
      await tester.pump(const Duration(milliseconds: 300));

      Navigator.pushNamed(navContext, '/payment');
      await tester.pump(const Duration(milliseconds: 300));

      Navigator.pushNamed(navContext, '/order-success');
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Order Confirmed!'), findsWidgets);
    });

    testWidgets('5. Delivery Tracking & Order History Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pump(const Duration(milliseconds: 300));

      final navContext = tester.element(find.byType(Navigator));

      Navigator.pushNamed(navContext, '/tracking');
      await tester.pump(const Duration(milliseconds: 300));

      Navigator.pushNamed(navContext, '/orders');
      await tester.pump(const Duration(milliseconds: 300));

      Navigator.pushNamed(navContext, '/wallet');
      await tester.pump(const Duration(milliseconds: 300));

      Navigator.pushNamed(navContext, '/loyalty');
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
