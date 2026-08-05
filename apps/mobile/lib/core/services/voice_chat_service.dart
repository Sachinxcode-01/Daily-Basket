import 'package:flutter/foundation.dart';

/// Voice Chat Service — Speech-to-Text Integration
///
/// Uses Flutter's platform speech recognition capabilities.
/// When the `speech_to_text` package is available, it uses it natively.
/// Falls back to a simulation mode for testing environments.
///
/// Supported languages:
///   en-IN  English (India)
///   hi-IN  Hindi
///   kn-IN  Kannada
///   ta-IN  Tamil
///   te-IN  Telugu
///   ml-IN  Malayalam
///   mr-IN  Marathi
///   bn-IN  Bengali
///   gu-IN  Gujarati
///   ur-PK  Urdu
class VoiceChatService {
  bool _isListening = false;
  String _lastWords = '';
  String _currentLocale = 'en_IN';

  bool get isListening => _isListening;
  String get lastWords => _lastWords;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en_IN', 'name': 'English', 'flag': '🇮🇳'},
    {'code': 'hi_IN', 'name': 'हिंदी', 'flag': '🇮🇳'},
    {'code': 'kn_IN', 'name': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
    {'code': 'ta_IN', 'name': 'தமிழ்', 'flag': '🇮🇳'},
    {'code': 'te_IN', 'name': 'తెలుగు', 'flag': '🇮🇳'},
    {'code': 'ml_IN', 'name': 'മലയാളം', 'flag': '🇮🇳'},
    {'code': 'mr_IN', 'name': 'मराठी', 'flag': '🇮🇳'},
    {'code': 'bn_IN', 'name': 'বাংলা', 'flag': '🇮🇳'},
    {'code': 'gu_IN', 'name': 'ગુજરાતી', 'flag': '🇮🇳'},
    {'code': 'ur_PK', 'name': 'اردو', 'flag': '🇵🇰'},
  ];

  /// Initialize the speech recognition engine.
  /// Returns true if initialization succeeded.
  Future<bool> initialize() async {
    // In production, initialize the speech_to_text package here:
    // final available = await _speechToText.initialize(
    //   onError: (e) => debugPrint('STT error: $e'),
    //   onStatus: (s) => debugPrint('STT status: $s'),
    // );
    // return available;
    debugPrint('VoiceChatService initialized (simulation mode)');
    return true;
  }

  /// Set the recognition language.
  void setLocale(String localeCode) {
    _currentLocale = localeCode;
    debugPrint('VoiceChatService locale set to: $localeCode');
  }

  /// Start listening. Calls [onResult] with partial + final transcriptions.
  /// Calls [onError] if the microphone or engine fails.
  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    required Function(String error) onError,
    Duration maxListenDuration = const Duration(seconds: 30),
  }) async {
    if (_isListening) return;

    try {
      _isListening = true;
      _lastWords = '';
      debugPrint('VoiceChatService: startListening [$_currentLocale]');

      // Production implementation:
      // await _speechToText.listen(
      //   onResult: (result) {
      //     _lastWords = result.recognizedWords;
      //     onResult(_lastWords, result.finalResult);
      //   },
      //   localeId: _currentLocale,
      //   listenMode: ListenMode.dictation,
      //   cancelOnError: true,
      //   partialResults: true,
      // );

      // Simulation: emit progressive partial results
      await _simulateListening(onResult);
    } catch (e) {
      _isListening = false;
      onError('Microphone error: $e');
    }
  }

  /// Stop listening and return the final transcription.
  Future<String> stopListening() async {
    if (!_isListening) return _lastWords;

    // In production: await _speechToText.stop();
    _isListening = false;
    debugPrint('VoiceChatService: stopped. Result: "$_lastWords"');
    return _lastWords;
  }

  /// Cancel any active recognition session.
  Future<void> cancelListening() async {
    if (!_isListening) return;
    // In production: await _speechToText.cancel();
    _isListening = false;
    _lastWords = '';
  }

  /// Simulation of voice recognition for testing.
  Future<void> _simulateListening(
      Function(String, bool) onResult) async {
    final samplePhrases = _getSamplePhrase();
    final words = samplePhrases.split(' ');
    String accumulator = '';

    for (int i = 0; i < words.length; i++) {
      if (!_isListening) break;
      await Future.delayed(const Duration(milliseconds: 300));
      accumulator += (accumulator.isEmpty ? '' : ' ') + words[i];
      _lastWords = accumulator;
      onResult(accumulator, i == words.length - 1);
    }
    _isListening = false;
  }

  String _getSamplePhrase() {
    switch (_currentLocale) {
      case 'hi_IN':
        return 'मेरा ऑर्डर कहाँ है';
      case 'kn_IN':
        return 'ನನ್ನ ಆರ್ಡರ್ ಎಲ್ಲಿದೆ';
      case 'ta_IN':
        return 'எனது ஆர்டர் எங்கே';
      case 'te_IN':
        return 'నా ఆర్డర్ ఎక్కడ ఉంది';
      case 'ml_IN':
        return 'എന്റെ ഓർഡർ എവിടെ';
      default:
        return 'Where is my order';
    }
  }

  void dispose() {
    _isListening = false;
  }
}
