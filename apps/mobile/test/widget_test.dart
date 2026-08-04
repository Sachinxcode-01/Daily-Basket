import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/main.dart';

void main() {
  testWidgets('Daily Basket App launches cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyBasketApp());
    expect(find.byType(DailyBasketApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });
}
