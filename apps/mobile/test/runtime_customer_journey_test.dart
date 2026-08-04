import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:daily_basket_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:daily_basket_mobile/features/catalog/presentation/screens/product_details_screen.dart';
import 'package:daily_basket_mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:daily_basket_mobile/features/cart/presentation/screens/checkout_screen.dart';
import 'package:daily_basket_mobile/features/cart/presentation/screens/payment_screen.dart';
import 'package:daily_basket_mobile/features/orders/presentation/screens/order_success_screen.dart';
import 'package:daily_basket_mobile/features/orders/presentation/screens/order_history_screen.dart';
import 'package:daily_basket_mobile/features/wallet/presentation/screens/wallet_transactions_screen.dart';
import 'package:daily_basket_mobile/features/profile/presentation/screens/profile_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Runtime Customer Journey Verification Suite', () {
    testWidgets('1. App Launch & Splash Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('2. Customer Home Screen & Bottom Navigation Bar Tabs Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Daily Basket'), findsWidgets);
      expect(find.text('Categories'), findsWidgets);
      expect(find.text('Best Sellers'), findsWidgets);

      // Tap Categories tab
      final categoriesTab = find.text('Categories').last;
      await tester.tap(categoriesTab);
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Search tab
      final searchTab = find.text('Search').last;
      await tester.tap(searchTab);
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Cart tab
      final cartTab = find.text('Cart').last;
      await tester.tap(cartTab);
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('3. Product Details Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ProductDetailsScreen(
          productId: 'prod_avocado',
          productName: 'Organic Hass Avocados',
          price: '₹120',
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Organic Hass Avocados'), findsWidgets);
    });

    testWidgets('4. Cart & Checkout Screens Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Cart'), findsWidgets);

      await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(const MaterialApp(home: PaymentScreen()));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(const MaterialApp(home: OrderSuccessScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Order Confirmed!'), findsWidgets);
    });

    testWidgets('5. Orders, Wallet & Profile Screens Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderHistoryScreen()));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(const MaterialApp(home: WalletTransactionsScreen()));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
