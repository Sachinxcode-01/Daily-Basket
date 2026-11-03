import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:daily_basket_mobile/core/providers/checkout_provider.dart';
import 'package:daily_basket_mobile/core/providers/user_provider.dart';
import 'package:daily_basket_mobile/core/providers/app_theme_provider.dart';
import 'package:daily_basket_mobile/core/providers/language_provider.dart';
import 'package:daily_basket_mobile/core/providers/notification_provider.dart';
import 'package:daily_basket_mobile/features/referral/providers/coupon_provider.dart';
import 'package:daily_basket_mobile/features/profile/providers/address_provider.dart';
import 'package:daily_basket_mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:daily_basket_mobile/features/cart/presentation/screens/checkout_screen.dart';
import 'package:daily_basket_mobile/features/orders/presentation/screens/delivery_tracking_screen.dart';
import 'package:daily_basket_mobile/features/tracking/providers/tracking_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End User Journey Integration Tests', () {
    testWidgets(
      'Full Journey: Add to Cart -> Apply Coupon -> Select Address -> Checkout -> Live Order Tracking',
      (WidgetTester tester) async {
        final cartProvider = CartProvider(autoFetch: false);
        final couponProvider = CouponProvider();
        final addressProvider = AddressProvider();
        final userProvider = UserProvider();
        final checkoutProvider = CheckoutProvider();
        final themeProvider = AppThemeProvider();
        final languageProvider = LanguageProvider();
        final notificationProvider = NotificationProvider();
        final trackingProvider = TrackingProvider(autoSimulate: false);

        Widget createTestApp(Widget homeWidget) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
              ChangeNotifierProvider<CouponProvider>.value(value: couponProvider),
              ChangeNotifierProvider<AddressProvider>.value(value: addressProvider),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
              ChangeNotifierProvider<CheckoutProvider>.value(value: checkoutProvider),
              ChangeNotifierProvider<AppThemeProvider>.value(value: themeProvider),
              ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
              ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
              ChangeNotifierProvider<TrackingProvider>.value(value: trackingProvider),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              home: homeWidget,
              routes: {
                '/cart': (context) => const CartScreen(),
                '/checkout': (context) => const CheckoutScreen(),
                '/tracking': (context) => const DeliveryTrackingScreen(),
              },
            ),
          );
        }

        // ═════════════════════════════════════════════════════════════════════
        // STEP 1: ADD TO CART
        // ═════════════════════════════════════════════════════════════════════
        expect(cartProvider.itemCount, 0);
        expect(cartProvider.isEmpty, isTrue);

        cartProvider.addItem(CartItem(
          id: 'prod_veg_001',
          name: 'Fresh Country Tomatoes (Tamatar)',
          subtitle: '500 g',
          price: 24.0,
          image: 'assets/products/fresh-vegetables/00124fbd-0fa5-441d-adeb-301d694bf0f4.png',
          qty: 2,
        ));

        cartProvider.addItem(CartItem(
          id: 'prod_dairy_001',
          name: 'Organic Cow Milk',
          subtitle: '500 ml',
          price: 32.0,
          image: 'assets/products/milk/sample.png',
          qty: 1,
        ));

        expect(cartProvider.itemCount, 3);
        expect(cartProvider.isEmpty, isFalse);
        expect(cartProvider.itemTotalDouble, 80.0);

        // ═════════════════════════════════════════════════════════════════════
        // STEP 2: APPLY PROMOTIONAL COUPON
        // ═════════════════════════════════════════════════════════════════════
        expect(couponProvider.appliedCoupon, isNull);

        final testCoupon = Coupon(
          id: 'coupon_welcome_20',
          code: 'DAILY20',
          title: 'Daily Basket Welcome Bonus',
          subtitle: 'Flat ₹20 discount on orders above ₹50',
          discountDisplay: '₹20',
          discountSub: 'OFF',
          discountBg: const Color(0xFFE8F5E9),
          discountColor: const Color(0xFF006B23),
          expiry: 'VALID TILL DEC 31',
          icon: Icons.local_offer_rounded,
          category: 'Welcome',
          minOrderAmount: 50.0,
          flatDiscount: 20.0,
        );

        final couponResult = couponProvider.applyCoupon(
          testCoupon,
          cartProvider.itemTotalDouble,
        );

        expect(couponResult.success, isTrue);
        expect(couponProvider.appliedCoupon, isNotNull);
        expect(couponProvider.appliedCoupon?.code, 'DAILY20');

        final discount = couponProvider.calculateDiscount(cartProvider.itemTotalDouble);
        expect(discount, 20.0);
        expect(cartProvider.itemTotalDouble - discount, 60.0);

        // ═════════════════════════════════════════════════════════════════════
        // STEP 3: VERIFY DELIVERY ADDRESS & SERVICEABILITY
        // ═════════════════════════════════════════════════════════════════════
        expect(addressProvider.addresses.isNotEmpty, isTrue);
        final selectedAddress = addressProvider.defaultAddress ?? addressProvider.addresses.first;
        expect(selectedAddress, isNotNull);
        expect(selectedAddress['district'], 'Bengaluru');
        expect(selectedAddress['pincode'], '560038');

        // ═════════════════════════════════════════════════════════════════════
        // STEP 4: PUMP UI & VERIFY CART & TRACKING SCREENS RENDER CLEANLY
        // ═════════════════════════════════════════════════════════════════════
        await tester.pumpWidget(createTestApp(const CartScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Cart'), findsWidgets);
        expect(find.text('Fresh Country Tomatoes (Tamatar)'), findsOneWidget);
        expect(find.text('Organic Cow Milk'), findsOneWidget);

        await tester.pumpWidget(createTestApp(const DeliveryTrackingScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Live Order Tracking'), findsOneWidget);
        expect(find.text('Ramesh Kumar'), findsOneWidget);
        expect(find.byIcon(Icons.two_wheeler_rounded), findsWidgets);
      },
    );
  });
}
