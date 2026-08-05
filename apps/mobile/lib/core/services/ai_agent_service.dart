import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiAgentService {
  final String baseUrl;

  AiAgentService({this.baseUrl = 'http://10.0.2.2:3000/api'});

  /// Send message to Enterprise AI Backend
  Future<Map<String, dynamic>> sendMessage({
    required String message,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? context,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/ai/chat');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId ?? 'user_demo_01',
          'message': message,
          'sessionId': sessionId,
          'context': context ?? {},
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('AiAgentService sendMessage error: $e');
    }

    // Client-side fallback if backend server is offline or unreachable
    return _generateClientFallback(message);
  }

  /// Client-side intelligent fallback response generator
  Map<String, dynamic> _generateClientFallback(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('delay') || lower.contains('tracking') || lower.contains('where') || lower.contains('status')) {
      return {
        'content': 'Here is the live delivery status for your express order #DB-9824. Your delivery rider is en route!',
        'cardType': 'order_status',
        'cardData': {
          'orderId': '#DB-9824',
          'riderName': 'Rahul M.',
          'riderPhone': '+91 9876543210',
          'eta': '3 mins away',
          'location': 'Near MG Road Signal',
        },
        'providerUsed': 'CLIENT_FALLBACK',
      };
    } else if (lower.contains('refund') || lower.contains('wallet') || lower.contains('money')) {
      return {
        'content': 'Here are your latest wallet refund details for order #DB-9824:',
        'cardType': 'refund_card',
        'cardData': {
          'amount': '₹120.00',
          'status': 'SUCCESS',
          'txnId': '#TXN-882193',
          'method': 'Daily Basket Instant Wallet',
          'timestamp': 'Today, 10:45 AM',
        },
        'providerUsed': 'CLIENT_FALLBACK',
      };
    } else if (lower.contains('damage') || lower.contains('broken') || lower.contains('missing') || lower.contains('quality')) {
      return {
        'content': 'I am so sorry to hear that an item arrived in damaged condition! We have a zero-compromise freshness policy. Select an item below to claim an instant refund:',
        'cardType': 'item_complaint',
        'cardData': {
          'items': [
            {'name': 'Organic Farm Fresh Tomatoes (500g)', 'price': '₹24'},
            {'name': 'Fresh Cherry Tomatoes Pack (250g)', 'price': '₹45'},
            {'name': 'Italian Sun-Dried Tomatoes (150g)', 'price': '₹120'},
          ],
        },
        'providerUsed': 'CLIENT_FALLBACK',
      };
    }

    return {
      'content': 'Thank you for reaching out! Regarding "$message", I have updated your ticket in our system. You can track your order or view your wallet balance directly.',
      'cardType': 'general_resolution',
      'providerUsed': 'CLIENT_FALLBACK',
    };
  }
}
