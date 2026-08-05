import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_mobile/features/support/presentation/screens/live_support_chat_screen.dart';
import 'package:daily_basket_mobile/core/providers/ai_chat_provider.dart';

class _MockHttpOverrides extends HttpOverrides {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget createTestWidget() {
    return ChangeNotifierProvider<AiChatProvider>(
      create: (_) => AiChatProvider(),
      child: const MaterialApp(
        home: LiveSupportChatScreen(),
      ),
    );
  }

  group('LiveSupportChatScreen Test Suite', () {
    testWidgets('1. Initial Chat renders Sarah J. and welcome message',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Sarah J.'), findsWidgets);
      expect(find.text('Support Agent • Online'), findsOneWidget);
      expect(find.textContaining('Welcome to Daily Basket priority support'), findsOneWidget);
    });

    testWidgets('2. Tapping "Delivery delay" triggers Live Delivery Order Status Card',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 200));

      // Tap 'Delivery delay' quick reply chip
      final delayChip = find.widgetWithText(ActionChip, 'Delivery delay');
      expect(delayChip, findsOneWidget);
      await tester.ensureVisible(delayChip);
      await tester.tap(delayChip);
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      // Verify user message balloon & bot response with rider info
      expect(find.text('Delivery delay'), findsWidgets);
      expect(find.textContaining('Your delivery rider is en route!'), findsOneWidget);
      expect(find.textContaining('Rahul M.'), findsOneWidget);
    });

    testWidgets('3. Tapping "Talk to Manager" escalates to Senior Manager Ananya R.',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 200));

      // Scroll to and tap 'Talk to Manager' chip
      await tester.drag(find.byType(SingleChildScrollView).last, const Offset(-400, 0));
      await tester.pumpAndSettle();

      final managerChip = find.widgetWithText(ActionChip, 'Talk to Manager');
      expect(managerChip, findsOneWidget);
      await tester.ensureVisible(managerChip);
      await tester.tap(managerChip);
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      // Verify header updated to Ananya R. Senior Support Manager
      expect(find.text('Ananya R.'), findsWidgets);
      expect(find.text('Senior Support Manager • Online'), findsOneWidget);
      expect(find.textContaining('I am Ananya R., Senior Support Manager'), findsOneWidget);
    });
  });
}
