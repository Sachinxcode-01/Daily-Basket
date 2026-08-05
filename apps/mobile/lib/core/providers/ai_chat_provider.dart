import 'package:flutter/material.dart';
import '../services/ai_agent_service.dart';

class AiChatProvider extends ChangeNotifier {
  final AiAgentService _aiService = AiAgentService();

  bool _isLoading = false;
  bool _isEscalatedToManager = false;
  String _activeAgentName = 'Sarah J.';
  String _activeAgentRole = 'Support Agent • Online';
  String _searchQuery = '';

  List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg_1',
      'isAgent': true,
      'text':
          'Hi there! Welcome to Daily Basket priority support. I am Sarah J. How can I assist you with your orders or account today?',
      'time': '10:42 AM',
      'agentName': 'Sarah J.',
      'type': 'text',
    },
    {
      'id': 'msg_2',
      'isAgent': false,
      'text':
          'Hi, I have a question regarding my recent express order #DB-9824.',
      'time': '10:44 AM',
      'type': 'text',
    },
    {
      'id': 'msg_3',
      'isAgent': true,
      'text':
          'I see order #DB-9824 in your account (3 items • ₹219). Please tap a topic below or type your question:',
      'time': '10:45 AM',
      'agentName': 'Sarah J.',
      'type': 'order_summary',
      'data': {
        'orderId': '#DB-9824',
        'itemCount': '3 items',
        'total': '₹219',
        'status': 'Out for Delivery',
      },
    },
  ];

  bool get isLoading => _isLoading;
  bool get isEscalatedToManager => _isEscalatedToManager;
  String get activeAgentName => _activeAgentName;
  String get activeAgentRole => _activeAgentRole;
  String get searchQuery => _searchQuery;

  List<Map<String, dynamic>> get messages {
    if (_searchQuery.isEmpty) return _messages;
    return _messages.where((m) {
      final text = (m['text'] as String? ?? '').toLowerCase();
      return text.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> sendMessage(String text, {Map<String, dynamic>? screenContext}) async {
    if (text.trim().isEmpty) return;

    final userMsgId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _messages.add({
      'id': userMsgId,
      'isAgent': false,
      'text': text,
      'time': 'Just now',
      'type': 'text',
    });

    _isLoading = true;
    notifyListeners();

    // Check for explicit manager escalation request
    final lower = text.toLowerCase();
    if (lower.contains('manager') || lower.contains('human') || lower.contains('supervisor')) {
      _escalateToSeniorManager();
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await _aiService.sendMessage(
        message: text,
        context: screenContext ?? {'currentRoute': '/chat', 'activeOrderId': '#DB-9824'},
      );

      _messages.add({
        'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
        'isAgent': true,
        'agentName': _activeAgentName,
        'text': response['content'] ?? 'How else may I help you with Daily Basket?',
        'time': 'Just now',
        'type': response['cardType'] ?? 'text',
        'data': response['cardData'],
      });
    } catch (e) {
      _messages.add({
        'id': 'agent_err_${DateTime.now().millisecondsSinceEpoch}',
        'isAgent': true,
        'agentName': _activeAgentName,
        'text': 'Thank you for reaching out! I am resolving your query with Daily Basket priority support.',
        'time': 'Just now',
        'type': 'text',
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _escalateToSeniorManager() {
    _isEscalatedToManager = true;
    _activeAgentName = 'Ananya R.';
    _activeAgentRole = 'Senior Support Manager • Online';

    _messages.add({
      'id': 'escalate_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': true,
      'agentName': 'Ananya R.',
      'text':
          'Hello! I am Ananya R., Senior Support Manager at Daily Basket. I have taken over your case for Order #DB-9824. How can I resolve this for you personally?',
      'time': 'Just now',
      'type': 'manager_transfer',
      'data': {
        'managerTitle': 'Senior Support Lead • Priority Escalation',
      },
    });
  }

  void escalateToManagerExplicitly() {
    _escalateToSeniorManager();
    notifyListeners();
  }

  void issueInstantRefund(String itemName, String price) {
    _messages.add({
      'id': 'refund_user_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': false,
      'text': 'Selected $itemName for instant refund',
      'time': 'Just now',
      'type': 'text',
    });

    _messages.add({
      'id': 'refund_agent_${DateTime.now().millisecondsSinceEpoch}',
      'isAgent': true,
      'agentName': _activeAgentName,
      'text':
          'Done! 100% instant refund of $price for "$itemName" has been credited to your Daily Basket Wallet.',
      'time': 'Just now',
      'type': 'refund_card',
      'data': {
        'amount': price,
        'status': 'SUCCESS',
        'txnId': '#TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'method': 'Daily Basket Instant Wallet',
        'timestamp': 'Just now',
      },
    });
    notifyListeners();
  }

  void clearHistory() {
    _messages = [
      {
        'id': 'msg_init',
        'isAgent': true,
        'text': 'Welcome to Daily Basket priority support! How can I help you today?',
        'time': 'Just now',
        'agentName': _activeAgentName,
        'type': 'text',
      }
    ];
    notifyListeners();
  }
}
