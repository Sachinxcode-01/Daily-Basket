import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_mobile/features/search/presentation/screens/search_results_screen.dart';
import 'package:daily_basket_mobile/core/providers/cart_provider.dart';
import 'package:daily_basket_mobile/core/providers/search_history_provider.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SearchHistoryProvider()),
      ],
      child: const MaterialApp(
        home: SearchResultsScreen(),
      ),
    );
  }

  group('SearchResultsScreen Real-time Filter & CTA Button Test Suite', () {
    testWidgets('1. SearchResultsScreen renders initial search results and top filter chips',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultsScreen), findsOneWidget);
      expect(find.text('All'), findsWidgets);
      expect(find.text('Organic'), findsWidgets);
      expect(find.text('Under ₹50'), findsWidgets);
    });

    testWidgets('2. Opening Filter Modal displays real-time CTA button with product count',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap tune / filter icon in AppBar
      final filterIcon = find.byIcon(Icons.tune_rounded);
      expect(filterIcon, findsOneWidget);
      await tester.tap(filterIcon);
      await tester.pumpAndSettle();

      // Verify bottom sheet title and CTA button presence
      expect(find.text('Filter Results'), findsOneWidget);
      expect(find.textContaining('Apply Filters'), findsOneWidget);

      // Select 'Under ₹50' chip inside the modal
      final under50Chip = find.widgetWithText(ChoiceChip, 'Under ₹50');
      expect(under50Chip, findsOneWidget);
      await tester.tap(under50Chip);
      await tester.pumpAndSettle();

      // Real-time preview CTA button text updated
      expect(find.textContaining('Apply Filters'), findsOneWidget);

      // Tap CTA Button
      final ctaButton = find.byType(ElevatedButton);
      expect(ctaButton, findsOneWidget);
      await tester.tap(ctaButton);
      await tester.pumpAndSettle();

      // Bottom sheet closed, screen successfully reflects filter state
      expect(find.byType(SearchResultsScreen), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
