import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:daily_basket_mobile/features/search/presentation/widgets/voice_search_dialog.dart';
import 'package:daily_basket_mobile/core/providers/cart_provider.dart';
import 'package:daily_basket_mobile/core/network/api_client.dart';
import 'package:daily_basket_mobile/core/services/voice_chat_service.dart';

class _MockHttpOverrides extends HttpOverrides {}

class _FakeVoiceChatService extends VoiceChatService {
  @override
  Future<bool> initialize() async => true;

  @override
  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    required Function(String error) onError,
    Duration maxListenDuration = const Duration(seconds: 30),
    Duration pauseFor = const Duration(seconds: 3),
  }) async {
    onResult('Organic Bananas', true);
  }

  @override
  Future<String> stopListening() async => 'Organic Bananas';
}

class _FakeApiClient extends ApiClient {
  @override
  Future<Map<String, dynamic>> voiceSearch({
    String? queryHint,
    String? audioBase64,
    String? mimeType,
    String? languageHint,
    String? currentRoute,
    String? token,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    return {
      'success': true,
      'data': {
        'transcription': queryHint ?? 'Organic Bananas',
        'searchQuery': 'bananas',
        'results': [
          {
            'id': 'p_banana_1',
            'name': 'Organic Bananas',
            'brand': 'Daily Basket',
            'price': 45.0,
            'mrp': 50.0,
            'unit': '1 bunch',
            'imageUrl': '',
          },
        ],
        'totalCount': 1,
      },
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget createTestWidget({
    VoiceChatService? voiceService,
    ApiClient? apiClient,
    CartProvider? cartProvider,
    Function(String)? onSearchCompleted,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>.value(
          value: cartProvider ?? CartProvider(autoFetch: false),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: VoiceSearchDialog(
            voiceService: voiceService ?? _FakeVoiceChatService(),
            apiClient: apiClient ?? _FakeApiClient(),
            onSearchCompleted: onSearchCompleted,
          ),
        ),
      ),
    );
  }

  group('VoiceSearchDialog Component & Cart Integration Test Suite', () {
    testWidgets('1. VoiceSearchDialog renders header, language chips, and microphone control',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('AI Voice Shopping'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('हिंदी'), findsOneWidget);
      expect(find.text('ಕನ್ನಡ'), findsOneWidget);
    });

    testWidgets('2. Tapping Language chip updates selected recognition language',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final kannadaChip = find.widgetWithText(ChoiceChip, 'ಕನ್ನಡ');
      expect(kannadaChip, findsOneWidget);
      await tester.tap(kannadaChip);
      await tester.pumpAndSettle();

      final selectedChip = tester.widget<ChoiceChip>(kannadaChip);
      expect(selectedChip.selected, isTrue);
    });

    testWidgets('3. Adding product from search results mutates CartProvider state immediately',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(411, 823);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cartProvider = CartProvider(autoFetch: false);

      await tester.pumpWidget(createTestWidget(cartProvider: cartProvider));
      await tester.pumpAndSettle();

      // Verify product from catalogue search is rendered
      expect(find.text('Organic Bananas'), findsWidgets);
      expect(find.text('₹45'), findsOneWidget);
      expect(find.text('ADD'), findsOneWidget);

      // Initially cart is empty
      expect(cartProvider.totalCount, 0);

      // Tap ADD button on product card
      await tester.tap(find.text('ADD'));
      await tester.pumpAndSettle();

      // Verify cart state updated immediately
      expect(cartProvider.totalCount, 1);
      expect(cartProvider.itemTotal, 45);

      // Verify quantity controls appear (+ / -)
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.text('1'), findsWidgets);

      // Advance timer past ApiClient timeout so no pending timers remain
      await tester.pump(const Duration(seconds: 16));
    });
  });
}
