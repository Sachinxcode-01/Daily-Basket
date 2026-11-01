import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/features/cart/presentation/screens/checkout_screen.dart';
import 'package:daily_basket_mobile/core/providers/checkout_provider.dart';
import 'package:daily_basket_mobile/features/referral/providers/coupon_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('CheckoutScreen renders correctly with providers', (tester) async {
    final cartProvider = CartProvider();
    final checkoutProvider = CheckoutProvider();
    final couponProvider = CouponProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cartProvider),
          ChangeNotifierProvider.value(value: checkoutProvider),
          ChangeNotifierProvider.value(value: couponProvider),
        ],
        child: const MaterialApp(
          home: CheckoutScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Checkout Summary'), findsOneWidget);
    expect(find.text('Delivery Slot'), findsOneWidget);
    expect(find.text('PROCEED TO PAY'), findsOneWidget);
  });
}

