import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Runtime Customer Journey Verification Suite', () {
    testWidgets('1. App Launch & Splash Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pumpAndSettle();
      expect(find.byType(DailyBasketApp), findsOneWidget);
    });

    testWidgets('2. Customer Home Screen & Bottom Navigation Bar Tabs Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pumpAndSettle();

      // Navigate to Home using Navigator descendant context
      final navContext = tester.element(find.byType(Navigator));
      Navigator.pushReplacementNamed(navContext, '/customer/home');
      await tester.pumpAndSettle();

      // Verify Home Feed
      expect(find.text('Daily Basket'), findsWidgets);
      expect(find.text('Categories'), findsWidgets);
      expect(find.text('Best Sellers'), findsWidgets);

      // Tap Categories Tab (Index 1)
      final categoriesTab = find.text('Categories').last;
      await tester.tap(categoriesTab);
      await tester.pumpAndSettle();

      // Tap Search Tab (Index 2)
      final searchTab = find.text('Search').last;
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      // Tap Cart Tab (Index 3)
      final cartTab = find.text('Cart').last;
      await tester.tap(cartTab);
      await tester.pumpAndSettle();

      // Tap Orders Tab (Index 4)
      final ordersTab = find.text('Orders').last;
      await tester.tap(ordersTab);
      await tester.pumpAndSettle();

      // Tap Profile Tab (Index 5)
      final profileTab = find.text('Profile').last;
      await tester.tap(profileTab);
      await tester.pumpAndSettle();
    });

    testWidgets('3. Product Details Navigation & Cart Binding Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Navigator));
      Navigator.pushReplacementNamed(navContext, '/customer/home');
      await tester.pumpAndSettle();

      // Tap first Best Seller Product Card
      final productCard = find.text('Organic Hass Avocados');
      expect(productCard, findsOneWidget);
      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // Verify Product Details Screen loaded
      expect(find.text('Organic Hass Avocados'), findsWidgets);
    });

    testWidgets('4. Checkout & Payment Navigation Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Navigator));
      Navigator.pushNamed(navContext, '/cart');
      await tester.pumpAndSettle();

      // Verify Cart Screen
      expect(find.text('Basket'), findsWidgets);

      // Navigate to Checkout
      Navigator.pushNamed(navContext, '/checkout');
      await tester.pumpAndSettle();

      // Navigate to Payment
      Navigator.pushNamed(navContext, '/payment');
      await tester.pumpAndSettle();

      // Navigate to Order Success
      Navigator.pushNamed(navContext, '/order-success');
      await tester.pumpAndSettle();
      expect(find.text('Order Confirmed!'), findsWidgets);
    });

    testWidgets('5. Delivery Tracking & Order History Test', (WidgetTester tester) async {
      await tester.pumpWidget(const DailyBasketApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Navigator));

      // Navigate to Tracking
      Navigator.pushNamed(navContext, '/tracking');
      await tester.pumpAndSettle();

      // Navigate to Orders
      Navigator.pushNamed(navContext, '/orders');
      await tester.pumpAndSettle();

      // Navigate to Wallet
      Navigator.pushNamed(navContext, '/wallet');
      await tester.pumpAndSettle();

      // Navigate to Loyalty / Daily Basket Plus
      Navigator.pushNamed(navContext, '/loyalty');
      await tester.pumpAndSettle();
    });
  });
}
