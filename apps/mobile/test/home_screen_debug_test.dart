import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_mobile/main.dart';
import 'package:daily_basket_mobile/core/providers/language_provider.dart';
import 'package:daily_basket_mobile/core/providers/user_provider.dart';
import 'package:daily_basket_mobile/core/providers/app_theme_provider.dart';
import 'package:daily_basket_mobile/core/providers/notification_provider.dart';
import 'package:daily_basket_mobile/core/providers/favorites_provider.dart';
import 'package:daily_basket_mobile/core/providers/wishlist_provider.dart';
import 'package:daily_basket_mobile/core/providers/categories_provider.dart';
import 'package:daily_basket_mobile/core/providers/recently_viewed_provider.dart';
import 'package:daily_basket_mobile/core/providers/search_history_provider.dart';
import 'package:daily_basket_mobile/core/providers/visual_search_provider.dart';
import 'package:daily_basket_mobile/core/providers/permissions_provider.dart';
import 'package:daily_basket_mobile/core/providers/checkout_provider.dart';
import 'package:daily_basket_mobile/core/providers/auth_provider.dart';
import 'package:daily_basket_mobile/features/wallet/providers/wallet_provider.dart';
import 'package:daily_basket_mobile/features/profile/providers/address_provider.dart';
import 'package:daily_basket_mobile/features/tracking/providers/tracking_provider.dart';
import 'package:daily_basket_mobile/core/providers/ai_chat_provider.dart';
import 'package:daily_basket_mobile/features/referral/providers/coupon_provider.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Debug Home Screen Render in DailyBasketApp with Full Providers', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1220, 2712);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => CheckoutProvider()),
          ChangeNotifierProvider(create: (_) => CouponProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => WalletProvider()),
          ChangeNotifierProvider(create: (_) => AddressProvider()),
          ChangeNotifierProvider(create: (_) => TrackingProvider()),
          ChangeNotifierProvider(create: (_) => AiChatProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => CategoriesProvider()),
          ChangeNotifierProvider(create: (_) => RecentlyViewedProvider()),
          ChangeNotifierProvider(create: (_) => SearchHistoryProvider()),
          ChangeNotifierProvider(create: (_) => VisualSearchProvider()),
          ChangeNotifierProvider(create: (_) => PermissionsProvider()),
        ],
        child: const DailyBasketApp(),
      ),
    );
    await tester.pump();
    
    // Navigate directly to /customer/home
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushReplacementNamed('/customer/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Daily Basket'), findsWidgets);
    expect(find.text('Flash Deals'), findsOneWidget);
    expect(find.text('Deal of the Day'), findsOneWidget);
    expect(find.text('Daily Selling'), findsOneWidget);
    expect(find.text('Kirana Essentials'), findsOneWidget);
  });
}
