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
import 'package:daily_basket_mobile/core/providers/favorites_provider.dart';
import 'package:daily_basket_mobile/core/providers/categories_provider.dart';
import 'package:daily_basket_mobile/core/providers/recently_viewed_provider.dart';
import 'package:daily_basket_mobile/core/providers/visual_search_provider.dart';
import 'package:daily_basket_mobile/features/catalog/presentation/screens/favorites_screen.dart';
import 'package:daily_basket_mobile/core/providers/checkout_provider.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => RecentlyViewedProvider()),
        ChangeNotifierProvider(create: (_) => VisualSearchProvider()),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('Runtime Customer Journey Verification Suite', () {
    testWidgets('1. App Launch & Splash Screen Test', (WidgetTester tester) async {
      // Wrap with providers so SplashScreen → WelcomeScreen navigation succeeds
      await tester.pumpWidget(wrapWithProviders(const SplashScreen()));
      // Let splash animations play (1.5s)
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.byType(SplashScreen), findsOneWidget);
      // Advance past the 3s navigation timer
      await tester.pump(const Duration(milliseconds: 1600));
      // Let the navigator push complete
      await tester.pump(const Duration(milliseconds: 400));
      // Drain WelcomeScreen sequence timers (900ms subtitle delay)
      await tester.pump(const Duration(milliseconds: 900));
      // Drain TypewriterText character timers (23 chars × 55ms = ~1265ms)
      await tester.pump(const Duration(milliseconds: 1300));
      // Drain buttons delay + cursor blink timer
      await tester.pump(const Duration(milliseconds: 1000));
      // Final settle — let all animations complete
      await tester.pumpAndSettle(const Duration(seconds: 2));
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
    testWidgets('6. Favorites Screen Test', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const FavoritesScreen()));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('My Favorites ❤️'), findsWidgets);
    });
  });
}
