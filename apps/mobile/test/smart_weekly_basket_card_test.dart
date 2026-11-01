import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_mobile/core/providers/cart_provider.dart';
import 'package:daily_basket_mobile/core/widgets/app_network_image.dart';
import 'package:daily_basket_mobile/features/home/presentation/widgets/smart_weekly_basket_card.dart';

double _calculateLuminance(Color color) {
  double getComponentLuminance(int component) {
    final double c = component / 255.0;
    return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = getComponentLuminance((color.r * 255).round());
  final g = getComponentLuminance((color.g * 255).round());
  final b = getComponentLuminance((color.b * 255).round());
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _calculateContrastRatio(Color foreground, Color background) {
  final l1 = _calculateLuminance(foreground);
  final l2 = _calculateLuminance(background);
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  testWidgets(
      'SmartWeeklyBasketCard verifies image asset selections, badge constraint, and button contrast',
      (WidgetTester tester) async {
    final cartProvider = CartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<CartProvider>.value(
        value: cartProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SmartWeeklyBasketCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Card Header
    expect(find.text('Your Smart Weekly Basket'), findsOneWidget);

    // 2. Verify image asset selections for staples
    final appNetworkImages = tester
        .widgetList<AppNetworkImage>(find.byType(AppNetworkImage))
        .map((w) => w.imageUrl)
        .toList();

    expect(
      appNetworkImages,
      contains('assets/products/milk/1ded64a0-9f20-4a1d-8211-156f221b377b.png'),
      reason: 'Amul Milk should use a milk asset',
    );
    expect(
      appNetworkImages,
      contains(
          'assets/products/poha-daliya-grains/aashirvaad_chakki_atta_5kg.png'),
      reason: 'Aashirvaad Atta should use an atta asset, not dairy whitener',
    );
    expect(
      appNetworkImages,
      contains('assets/products/bread-pav/1200_1657599895699.png'),
      reason: 'Farm Fresh Eggs should use an eggs asset',
    );

    // 3. Verify reason badges are constrained inside Flexible
    final reasonTexts = [
      'Purchased every 2 days',
      'Reorder interval (14 days)',
      'Weekly staple prediction',
    ];

    for (final reason in reasonTexts) {
      final reasonFinder = find.text(reason);
      expect(reasonFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(reasonFinder);
      expect(textWidget.maxLines, 1);
      expect(textWidget.overflow, TextOverflow.ellipsis);

      // Verify it is wrapped in Flexible within a Row
      final flexibleAncestor = find.ancestor(
        of: reasonFinder,
        matching: find.byType(Flexible),
      );
      expect(flexibleAncestor, findsWidgets);
    }

    // 4. Verify 1-Tap Add All button styling & contrast
    final addAllButtonFinder = find.byType(ElevatedButton);
    expect(addAllButtonFinder, findsOneWidget);

    final addAllButton = tester.widget<ElevatedButton>(addAllButtonFinder);
    final buttonStyle = addAllButton.style;
    final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
    final foregroundColor = buttonStyle?.foregroundColor?.resolve({});

    expect(backgroundColor, isNotNull);
    expect(foregroundColor, Colors.white);

    // WCAG contrast ratio check: >= 4.5:1
    final contrastRatio =
        _calculateContrastRatio(Colors.white, backgroundColor!);
    expect(
      contrastRatio,
      greaterThanOrEqualTo(4.5),
      reason:
          'Button background color must achieve at least 4.5:1 contrast against white foreground',
    );

    // 5. Test 1-Tap Add All interaction and cart consistency
    await tester.tap(addAllButtonFinder);
    await tester.pumpAndSettle();

    expect(cartProvider.items.length, 3);
    final cartImages = cartProvider.items.map((i) => i.image).toList();
    expect(
      cartImages,
      contains(
          'assets/products/poha-daliya-grains/aashirvaad_chakki_atta_5kg.png'),
      reason: 'Atta image must be consistent in cart item',
    );
    expect(
      cartImages,
      contains('assets/products/bread-pav/1200_1657599895699.png'),
      reason: 'Egg image must be consistent in cart item',
    );
  });
}
