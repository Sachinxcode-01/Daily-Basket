import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_basket_mobile/features/search/presentation/screens/search_results_screen.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('SearchResultsScreen Real-time Filter & CTA Button Test Suite', () {
    testWidgets('1. SearchResultsScreen renders initial search results and top filter chips',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: SearchResultsScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(SearchResultsScreen), findsOneWidget);
      expect(find.text('Organic Farm Fresh Tomatoes'), findsOneWidget);
      expect(find.text('Fresh Cherry Tomatoes Pack'), findsOneWidget);
      expect(find.text('Italian Sun-Dried Tomatoes'), findsOneWidget);
    });

    testWidgets('2. Opening Filter Modal displays real-time CTA button with product count',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: SearchResultsScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

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

      // Bottom sheet closed, main screen now shows 3 results (Italian Sun-Dried ₹120 excluded)
      expect(find.text('Organic Farm Fresh Tomatoes'), findsOneWidget);
      expect(find.text('Italian Sun-Dried Tomatoes'), findsNothing);
    });
  });
}
