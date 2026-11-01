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
import 'package:daily_basket_mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:daily_basket_mobile/features/catalog/presentation/screens/product_details_screen.dart';
import 'package:daily_basket_mobile/features/wallet/providers/wallet_provider.dart';
import 'package:daily_basket_mobile/core/providers/wishlist_provider.dart';
import 'package:daily_basket_mobile/core/providers/favorites_provider.dart';
import 'package:daily_basket_mobile/core/providers/categories_provider.dart';
import 'package:daily_basket_mobile/core/providers/recently_viewed_provider.dart';
import 'package:daily_basket_mobile/core/providers/visual_search_provider.dart';
import 'package:daily_basket_mobile/core/providers/checkout_provider.dart';
import 'package:daily_basket_mobile/core/providers/auth_provider.dart';
import 'package:daily_basket_mobile/core/widgets/app_network_image.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('CartScreen displays product images and navigates to ProductDetailsScreen on click', (WidgetTester tester) async {
    final cartProvider = CartProvider();
    cartProvider.addItem(CartItem(
      id: 'ds_veg1',
      name: 'Fresh Hybrid Tomatoes (Tamatar)',
      subtitle: '500 g',
      price: 18.0,
      qty: 1,
      image: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
    ));
    cartProvider.addItem(CartItem(
      id: 'ds_ban1',
      name: 'Fresh Robusta Bananas (Kela)',
      subtitle: '500 g (3-4 pcs)',
      price: 24.0,
      qty: 1,
      image: 'assets/products/fresh-vegetables/2483b1e4-6b95-4777-82ba-9ea62a37f40d.png',
    ));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cartProvider),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        child: const MaterialApp(
          home: CartScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify that product names and items appear in Your Items
    expect(find.text('Fresh Hybrid Tomatoes (Tamatar)'), findsOneWidget);
    expect(find.text('Fresh Robusta Bananas (Kela)'), findsOneWidget);

    // 2. Verify AppNetworkImage widgets are used for the cart items
    expect(find.byType(AppNetworkImage), findsWidgets);

    // 3. Tap on 'Fresh Hybrid Tomatoes (Tamatar)' to open ProductDetailsScreen
    await tester.tap(find.text('Fresh Hybrid Tomatoes (Tamatar)'));
    await tester.pumpAndSettle();

    // 4. Verify that ProductDetailsScreen is now displayed
    expect(find.byType(ProductDetailsScreen), findsOneWidget);
    expect(find.text('Fresh Hybrid Tomatoes (Tamatar)'), findsWidgets);

    // 5. Navigate back to CartScreen
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.byType(ProductDetailsScreen), findsNothing);

    // 6. Test stepper '+' button increments quantity without opening ProductDetailsScreen
    final addButtons = find.byIcon(Icons.add_rounded);
    expect(addButtons, findsWidgets);
    await tester.tap(addButtons.first);
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsScreen), findsNothing);
    expect(cartProvider.items.first.qty, 2);
  });
}

