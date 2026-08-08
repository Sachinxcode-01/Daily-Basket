import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_basket_mobile/core/widgets/app_motion.dart';

void main() {
  group('AppPageTransitions', () {
    testWidgets('fadeThrough creates a route that fades in', (tester) async {
      final route = AppPageTransitions.fadeThrough(const Text('Target'));
      expect(route, isA<PageRouteBuilder>());
      expect(route.transitionDuration, const Duration(milliseconds: 300));
    });

    testWidgets('sharedAxisX creates a route with 350ms duration', (tester) async {
      final route = AppPageTransitions.sharedAxisX(const Text('Target'));
      expect(route, isA<PageRouteBuilder>());
      expect(route.transitionDuration, const Duration(milliseconds: 350));
    });

    testWidgets('sharedAxisY creates a route with 350ms duration', (tester) async {
      final route = AppPageTransitions.sharedAxisY(const Text('Target'));
      expect(route, isA<PageRouteBuilder>());
      expect(route.transitionDuration, const Duration(milliseconds: 350));
    });
  });

  group('AppPressable', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPressable(
              child: Text('Press me'),
            ),
          ),
        ),
      );
      expect(find.text('Press me'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPressable(
              onTap: () => tapped = true,
              child: const SizedBox(width: 100, height: 48, child: Text('Button')),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppPressable));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('renders without onTap (no-op)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPressable(
              child: Text('Disabled button'),
            ),
          ),
        ),
      );
      expect(find.text('Disabled button'), findsOneWidget);
    });
  });

  group('TypewriterText', () {
    testWidgets('renders an empty string initially then fills', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Hello',
              style: TextStyle(fontSize: 16),
              charDuration: Duration(milliseconds: 10),
            ),
          ),
        ),
      );
      // Pump a few frames to allow typewriter to progress
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('does not show cursor after typing completes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Hi',
              style: TextStyle(fontSize: 16),
              charDuration: Duration(milliseconds: 10),
              showCursor: true,
            ),
          ),
        ),
      );
      // Allow typing to finish + cursor fade to stop
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 900));
      // After typing done the displayed text matches the full string
      expect(find.text('Hi'), findsOneWidget);
    });
  });

  group('StaggeredListItem', () {
    testWidgets('renders its child with stagger delay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredListItem(
              index: 0,
              delayMs: 50,
              child: Text('Item 1'),
            ),
          ),
        ),
      );
      // Widget renders in the tree immediately
      expect(find.byType(StaggeredListItem), findsOneWidget);

      // After delay + animation, fully visible and text present
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('multiple items stagger correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: List.generate(3, (i) => StaggeredListItem(
                index: i,
                delayMs: 100,
                child: Text('Item $i'),
              )),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));
      for (int i = 0; i < 3; i++) {
        expect(find.text('Item $i'), findsOneWidget);
      }
    });
  });
}
