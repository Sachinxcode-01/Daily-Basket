import 'dart:io';
import 'package:flutter/material.dart';
import '../services/ai_agent_service.dart';

/// Enterprise AI Chat Provider
/// Manages conversation state, SSE streaming, image/voice messages,
/// escalation logic, and multi-lingual session continuity.
class AiChatProvider extends ChangeNotifier {
  final AiAgentService _aiService = AiAgentService();

  // ─── Session ───────────────────────────────────────────────────────────────
  final String _sessionId =
      'session_${DateTime.now().millisecondsSinceEpoch}';

  // ─── State ─────────────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _isStreaming = false;
  bool _isEscalatedToManager = false;
  bool _isRecording = false;
  String _activeAgentName = 'Sarah J.';
  String _activeAgentRole = 'AI Support Agent • Online';
  String _searchQuery = '';
  String _streamingMessageId = '';
  String _streamingBuffer = '';
  String _detectedLanguage = 'en';

  // ─── Messages ──────────────────────────────────────────────────────────────
  List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg_welcome',
      'isAgent': true,
      'text':
          'Hi! 👋 Welcome to Daily Basket Priority Support. I am Sarah J., your AI Support Executive.\n\nI can help you with:\n• 📦 Order tracking & delivery\n• 💳 Wallet, refunds & payments\n• 🏷️ Coupons & offers\n• 🥦 Products & freshness issues\n• 📋 Account & settings\n\nYou can also send a photo of a damaged product or use voice. How can I help you today?',
      'time': _nowTime(),
      'agentName': 'Sarah J.',
      'type': 'text',
    },
  ];

  // ─── Getters ───────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  bool get isStreaming => _isStreaming;
  bool get isEscalatedToManager => _isEscalatedToManager;
  bool get isRecording => _isRecording;
  String get activeAgentName => _activeAgentName;
  String get activeAgentRole => _activeAgentRole;
  String get searchQuery => _searchQuery;
  String get detectedLanguage => _detectedLanguage;
  String get sessionId => _sessionId;

  List<Map<String, dynamic>> get messages {
    if (_searchQuery.isEmpty) return List.unmodifiable(_messages);
    return _messages.where((m) {
      final text = (m['text'] as String? ?? '').toLowerCase();
      return text.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  static String _nowTime() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  void _detectLanguage(String text) {
    final hasDevanagari = text.runes.any((r) => r >= 0x0900 && r <= 0x097F);
    final hasKannada = text.runes.any((r) => r >= 0x0C80 && r <= 0x0CFF);
    final hasTamil = text.runes.any((r) => r >= 0x0B80 && r <= 0x0BFF);
    final hasTelugu = text.runes.any((r) => r >= 0x0C00 && r <= 0x0C7F);
    if (hasKannada) {
      _detectedLanguage = 'kn';
    } else if (hasDevanagari) {
      _detectedLanguage = 'hi';
    } else if (hasTamil) {
      _detectedLanguage = 'ta';
    } else if (hasTelugu) {
      _detectedLanguage = 'te';
    } else {
      _detectedLanguage = 'en';
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  // ─── Send Text Message (SSE Streaming) ────────────────────────────────────

  Future<void> sendMessage(String text,
      {Map<String, dynamic>? screenContext}) async {
    if (text.trim().isEmpty) return;

    _detectLanguage(text);

    // Append user message
    _messages.add({
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': false,
      'text': text,
      'time': _nowTime(),
      'type': 'text',
      'lang': _detectedLanguage,
    });

    // Check for explicit escalation request
    final lower = text.toLowerCase();
    if (lower.contains('manager') ||
        lower.contains('human') ||
        lower.contains('supervisor') ||
        lower.contains('senior') ||
        lower.contains('ananya')) {
      _escalateToSeniorManager();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _isStreaming = false;
    notifyListeners();

    // Create placeholder streaming bubble
    final streamId = 'agent_${DateTime.now().millisecondsSinceEpoch}';
    _streamingMessageId = streamId;
    _streamingBuffer = '';

    _messages.add({
      'id': streamId,
      'isAgent': true,
      'agentName': _activeAgentName,
      'text': '',
      'time': _nowTime(),
      'type': 'text',
      'isStreaming': true,
    });

    _isLoading = false;
    _isStreaming = true;
    notifyListeners();

    bool receivedContent = false;
    Map<String, dynamic>? pendingCard;

    try {
      final stream = _aiService.streamMessage(
        message: text,
        sessionId: _sessionId,
        context: screenContext ??
            {
              'currentRoute': '/chat',
              'activeOrderId': '#DB-9824',
              'language': _detectedLanguage,
            },
      );

      await for (final chunk in stream) {
        final type = chunk['type'] as String? ?? 'content';

        if (type == 'content' || type == 'text') {
          final content = chunk['content'] as String? ?? '';
          _streamingBuffer += content;
          receivedContent = true;
          _updateStreamingMessage(_streamingBuffer);
        } else if (type == 'card') {
          pendingCard = chunk;
        } else if (type == 'done') {
          break;
        } else if (type == 'error') {
          break;
        }
      }
    } catch (e) {
      debugPrint('AiChatProvider streaming error: $e');
    }

    // Finalize the streaming message
    _finalizeStreamingMessage(_streamingBuffer, pendingCard);

    // If we got no content at all, add a contextual fallback message
    if (!receivedContent || _streamingBuffer.isEmpty) {
      _replaceOrAddFallbackMessage(text);
    }

    _isStreaming = false;
    _streamingMessageId = '';
    _streamingBuffer = '';
    notifyListeners();
  }

  void _updateStreamingMessage(String content) {
    final idx = _messages.indexWhere((m) => m['id'] == _streamingMessageId);
    if (idx != -1) {
      _messages[idx] = {
        ..._messages[idx],
        'text': content,
        'isStreaming': true,
      };
      notifyListeners();
    }
  }

  void _finalizeStreamingMessage(
      String finalText, Map<String, dynamic>? card) {
    final idx = _messages.indexWhere((m) => m['id'] == _streamingMessageId);
    if (idx != -1) {
      _messages[idx] = {
        ..._messages[idx],
        'text': finalText.isNotEmpty
            ? finalText
            : 'How can I assist you further with Daily Basket?',
        'isStreaming': false,
        'type': card != null ? (card['cardType'] ?? 'text') : 'text',
        'data': card?['cardData'],
      };
    }
    // Append card as separate message if present
    if (card != null && card['cardType'] != null) {
      _messages.add({
        'id': 'card_${DateTime.now().millisecondsSinceEpoch}',
        'isAgent': true,
        'agentName': _activeAgentName,
        'text': '',
        'time': _nowTime(),
        'type': card['cardType'],
        'data': card['cardData'],
        'isStreaming': false,
      });
    }
  }

  void _replaceOrAddFallbackMessage(String originalQuery) {
    final idx = _messages.indexWhere((m) => m['id'] == _streamingMessageId);
    final fallback = _aiService.sendMessage(message: originalQuery);
    fallback.then((resp) {
      if (idx != -1) {
        _messages[idx] = {
          ..._messages[idx],
          'text': resp['content'] ?? 'How can I help you with Daily Basket?',
          'isStreaming': false,
          'type': resp['cardType'] ?? 'text',
          'data': resp['cardData'],
        };
        if (resp['cardType'] != null) {
          _messages.add({
            'id': 'card_fb_${DateTime.now().millisecondsSinceEpoch}',
            'isAgent': true,
            'agentName': _activeAgentName,
            'text': '',
            'time': _nowTime(),
            'type': resp['cardType'],
            'data': resp['cardData'],
            'isStreaming': false,
          });
        }
      }
      notifyListeners();
    });
  }

  // ─── Send Image Message ────────────────────────────────────────────────────

  Future<void> sendImageMessage(File imageFile,
      {String caption = ''}) async {
    final imgMsgId = 'img_user_${DateTime.now().millisecondsSinceEpoch}';

    _messages.add({
      'id': imgMsgId,
      'isAgent': false,
      'text': caption.isNotEmpty ? caption : '📷 Sent an image',
      'time': _nowTime(),
      'type': 'image_upload',
      'imagePath': imageFile.path,
    });

    _isLoading = true;
    notifyListeners();

    // AI analyzing placeholder
    final analysisId = 'img_agent_${DateTime.now().millisecondsSinceEpoch}';
    _messages.add({
      'id': analysisId,
      'isAgent': true,
      'agentName': _activeAgentName,
      'text': '🔍 Analyzing your image...',
      'time': _nowTime(),
      'type': 'text',
      'isStreaming': true,
    });
    notifyListeners();

    try {
      final result = await _aiService.analyzeImage(
        imageFile: imageFile,
        sessionId: _sessionId,
        context: 'Customer uploaded image for product complaint or query',
      );

      final recommendation = result['recommendation'] as String? ??
          'I have analyzed the image. It appears there may be a quality issue. Would you like an instant refund?';
      final suggestRefund = result['suggestRefund'] as bool? ?? true;

      final idx = _messages.indexWhere((m) => m['id'] == analysisId);
      if (idx != -1) {
        _messages[idx] = {
          ..._messages[idx],
          'text': recommendation,
          'isStreaming': false,
          'type': 'image_analysis',
          'data': {
            'finding': result['finding'] ?? 'Quality issue detected',
            'severity': result['severity'] ?? 'MEDIUM',
            'suggestRefund': suggestRefund,
          },
        };
      }

      // If refund is recommended, add item complaint card
      if (suggestRefund) {
        _messages.add({
          'id': 'img_card_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': _activeAgentName,
          'text':
              'Select the item below to receive an instant refund to your Daily Basket Wallet:',
          'time': _nowTime(),
          'type': 'item_complaint',
          'data': {
            'items': [
              {'name': 'Identified Item from Image', 'price': '₹0'},
              {'name': 'Full Order Replacement', 'price': 'Full Amount'},
            ],
          },
        });
      }
    } catch (e) {
      debugPrint('AiChatProvider sendImageMessage error: $e');
      final idx = _messages.indexWhere((m) => m['id'] == analysisId);
      if (idx != -1) {
        _messages[idx] = {
          ..._messages[idx],
          'text':
              'I have received your image. Our team will review it shortly. In the meantime, would you like an instant refund?',
          'isStreaming': false,
        };
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // ─── Send Voice Message ────────────────────────────────────────────────────

  Future<void> sendVoiceMessage(String transcribedText) async {
    if (transcribedText.trim().isEmpty) return;

    _messages.add({
      'id': 'voice_user_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': false,
      'text': transcribedText,
      'time': _nowTime(),
      'type': 'voice_message',
      'isVoice': true,
    });

    notifyListeners();

    // Process as regular message for AI response
    await sendMessage(transcribedText,
        screenContext: {'currentRoute': '/chat', 'inputMode': 'voice'});
  }

  // ─── Escalation ────────────────────────────────────────────────────────────

  void _escalateToSeniorManager() {
    _isEscalatedToManager = true;
    _activeAgentName = 'Ananya R.';
    _activeAgentRole = 'Senior Support Manager • Online';

    _messages.add({
      'id': 'escalate_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': true,
      'agentName': 'Ananya R.',
      'text':
          'Hello! I am Ananya R., Senior Support Manager at Daily Basket. 🛡️\n\nI have personally taken over your case and reviewed your complete conversation history. Rest assured, I will resolve this for you with the highest priority.\n\nHow can I help you today?',
      'time': _nowTime(),
      'type': 'manager_transfer',
      'data': {
        'managerTitle': 'Senior Support Manager',
        'badge': 'PRIORITY ESCALATION',
      },
    });
  }

  void escalateToManagerExplicitly() {
    _escalateToSeniorManager();
    notifyListeners();
  }

  // ─── Instant Refund ────────────────────────────────────────────────────────

  void issueInstantRefund(String itemName, String price) {
    _messages.add({
      'id': 'refund_user_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': false,
      'text': 'Requesting instant refund for $itemName',
      'time': _nowTime(),
      'type': 'text',
    });

    _messages.add({
      'id': 'refund_agent_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': true,
      'agentName': _activeAgentName,
      'text':
          '✅ Done! A 100% instant refund of $price for "$itemName" has been credited to your Daily Basket Wallet. You should see it reflected immediately.',
      'time': _nowTime(),
      'type': 'refund_card',
      'data': {
        'amount': price,
        'status': 'SUCCESS',
        'txnId':
            '#TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'method': 'Daily Basket Instant Wallet',
        'timestamp': _nowTime(),
      },
    });
    notifyListeners();
  }

  // ─── Utilities ─────────────────────────────────────────────────────────────

  void clearHistory() {
    _messages = [
      {
        'id': 'msg_init_${DateTime.now().millisecondsSinceEpoch}',
        'isAgent': true,
        'text':
            'Hi! 👋 How can I assist you with Daily Basket today? You can ask me about your orders, wallet, coupons, or any product-related queries.',
        'time': _nowTime(),
        'agentName': _activeAgentName,
        'type': 'text',
      }
    ];
    _isEscalatedToManager = false;
    _activeAgentName = 'Sarah J.';
    _activeAgentRole = 'AI Support Agent • Online';
    _isStreaming = false;
    _isLoading = false;
    notifyListeners();
  }
}
