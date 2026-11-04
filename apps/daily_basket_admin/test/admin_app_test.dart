import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_admin/main.dart';
import 'package:daily_basket_admin/core/providers/admin_auth_provider.dart';
import 'package:daily_basket_admin/core/providers/admin_dashboard_provider.dart';
import 'package:daily_basket_admin/core/providers/admin_products_provider.dart';
import 'package:daily_basket_admin/core/providers/admin_marketing_provider.dart';
import 'package:daily_basket_admin/core/providers/ai_health_provider.dart';
import 'package:daily_basket_admin/core/providers/theme_provider.dart';

void main() {
  testWidgets('Daily Basket Admin App initializes and renders Splash Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
          ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
          ChangeNotifierProvider(create: (_) => AdminProductsProvider()),
          ChangeNotifierProvider(create: (_) => AdminMarketingProvider()),
          ChangeNotifierProvider(create: (_) => AiHealthProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const DailyBasketAdminApp(),
      ),
    );

    expect(find.text('DAILY BASKET'), findsOneWidget);
    expect(
        find.text('Enterprise Operations & Dark Store Suite'), findsOneWidget);

    // Advance past the 2.2s splash navigation timer
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump();
  });
}
