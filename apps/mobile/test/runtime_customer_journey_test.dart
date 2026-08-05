import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_basket_mobile/features/referral/providers/coupon_provider.dart';
import 'package:daily_basket_mobile/core/providers/user_provider.dart';
import 'package:daily_basket_mobile/core/providers/app_theme_provider.dart';
import 'package:daily_basket_mobile/core/providers/language_provider.dart';
import 'package:daily_basket_mobile/core/providers/notification_provider.dart';
import 'package:daily_basket_mobile/core/providers/cart_provider.dart';
import 'package:daily_basket_mobile/features/profile/providers/address_provider.dart';
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
import 'package:daily_basket_mobile/features/wallet/providers/wallet_provider.dart';
import 'package:daily_basket_mobile/core/providers/wishlist_provider.dart';
import 'package:daily_basket_mobile/core/providers/recently_viewed_provider.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => RecentlyViewedProvider()),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('Runtime Customer Journey Verification Suite', () {
    testWidgets('1. App Launch & Splash Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('2. Customer Home Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const CustomerHomeScreen()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Daily Basket'), findsWidgets);
    });

    testWidgets('3. Product Details Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const ProductDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Organic Hass Avocados'), findsWidgets);
    });

    testWidgets('4. Cart, Checkout & Payment Screens Test', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const CartScreen()));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(wrapWithProviders(const CheckoutScreen()));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(wrapWithProviders(const PaymentScreen()));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(wrapWithProviders(const OrderSuccessScreen()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Order Placed!'), findsWidgets);
    });

    testWidgets('5. Orders, Wallet & Profile Screens Test', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const OrderHistoryScreen()));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(wrapWithProviders(const WalletTransactionsScreen()));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(wrapWithProviders(const ProfileScreen()));
      await tester.pump(const Duration(milliseconds: 200));
    });
  });
}
