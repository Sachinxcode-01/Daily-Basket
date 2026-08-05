import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_admin/main.dart';
import 'package:daily_basket_admin/core/providers/admin_auth_provider.dart';
import 'package:daily_basket_admin/core/providers/admin_dashboard_provider.dart';

void main() {
  testWidgets('Daily Basket Admin App initializes and renders Splash Screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
          ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
        ],
        child: const DailyBasketAdminApp(),
      ),
    );

    expect(find.text('DAILY BASKET'), findsOneWidget);
    expect(find.text('Enterprise Operations & Dark Store Suite'), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
