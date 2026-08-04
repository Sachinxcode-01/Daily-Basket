import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/theme/app_theme.dart';

/// Professional Live Support Chat Screen — Google Stitch Specification
/// Features:
/// - Dynamic Intent Recognition & Contextual Bot Responses
/// - Interactive In-Chat Action Cards (Live Delivery Status, Wallet Refund Card, Item Complaint Picker)
/// - Senior Manager Escalation ("Ananya R. — Senior Support Lead")
/// - Header Control Menu (Call Support, Request Manager, Order Details)
class LiveSupportChatScreen extends StatefulWidget {
  const LiveSupportChatScreen({super.key});

  @override
  State<LiveSupportChatScreen> createState() => _LiveSupportChatScreenState();
}

class _LiveSupportChatScreenState extends State<LiveSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isEscalatedToManager = false;
  String _activeAgentName = 'Sarah J.';
  String _activeAgentRole = 'Support Agent • Online';

  final List<Map<String, dynamic>> _messages = [
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? inputQuery]) {
    final text = inputQuery ?? _messageController.text.trim();
    if (text.isEmpty) return;

    const userTime = 'Just now';
    setState(() {
      _messages.add({
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'isAgent': false,
        'text': text,
        'time': userTime,
        'type': 'text',
      });
      if (inputQuery == null) {
        _messageController.clear();
      }
    });
    _scrollToBottom();

    // Process Bot Response
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _processBotResponse(text);
    });
  }

  void _processBotResponse(String userText) {
    final lower = userText.toLowerCase();
    final agentName = _activeAgentName;

    if (lower.contains('manager') ||
        lower.contains('human') ||
        lower.contains('supervisor') ||
        lower.contains('agent')) {
      _escalateToSeniorManager();
      return;
    }

    if (lower.contains('damage') ||
        lower.contains('fault') ||
        lower.contains('broken') ||
        lower.contains('rotten') ||
        lower.contains('quality')) {
      setState(() {
        _messages.add({
          'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': agentName,
          'text':
              'I am so sorry to hear that an item arrived in damaged condition! We have a zero-compromise freshness policy.',
          'time': 'Just now',
          'type': 'item_complaint',
          'data': {
            'items': [
              {'name': 'Organic Farm Fresh Tomatoes (500g)', 'price': '₹24'},
              {'name': 'Fresh Cherry Tomatoes Pack (250g)', 'price': '₹45'},
              {'name': 'Italian Sun-Dried Tomatoes (150g)', 'price': '₹120'},
            ]
          },
        });
      });
    } else if (lower.contains('delay') ||
        lower.contains('late') ||
        lower.contains('where') ||
        lower.contains('tracking') ||
        lower.contains('delivery')) {
      setState(() {
        _messages.add({
          'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': agentName,
          'text':
              'Here is the live status for your express order #DB-9824. Your delivery rider is en route!',
          'time': 'Just now',
          'type': 'order_status',
          'data': {
            'orderId': '#DB-9824',
            'riderName': 'Rahul M.',
            'riderPhone': '+91 9876543210',
            'eta': '3 mins away',
            'location': 'Near MG Road Signal',
          },
        });
      });
    } else if (lower.contains('refund') ||
        lower.contains('money') ||
        lower.contains('wallet') ||
        lower.contains('credit') ||
        lower.contains('return')) {
      setState(() {
        _messages.add({
          'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': agentName,
          'text':
              'Here are your latest wallet refund details for order #DB-9824:',
          'time': 'Just now',
          'type': 'refund_card',
          'data': {
            'amount': '₹120.00',
            'status': 'SUCCESS',
            'txnId': '#TXN-882193',
            'method': 'Daily Basket Instant Wallet',
            'timestamp': 'Today, 10:45 AM',
          },
        });
      });
    } else if (lower.contains('missing') || lower.contains('short')) {
      setState(() {
        _messages.add({
          'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': agentName,
          'text':
              'I apologize for the missing item in your order. Please tap the missing item below to issue an instant wallet refund:',
          'time': 'Just now',
          'type': 'item_complaint',
          'data': {
            'items': [
              {'name': 'Organic Farm Fresh Tomatoes (500g)', 'price': '₹24'},
              {'name': 'Fresh Cherry Tomatoes Pack (250g)', 'price': '₹45'},
            ]
          },
        });
      });
    } else if (lower.contains('cancel') || lower.contains('stop')) {
      setState(() {
        _messages.add({
          'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': agentName,
          'text':
              'Order #DB-9824 is currently out for delivery with rider Rahul M. If you need to cancel, rider will return items to darkstore and 100% refund will be credited instantly.',
          'time': 'Just now',
          'type': 'cancellation_card',
        });
      });
    } else {
      setState(() {
        _messages.add({
          'id': 'agent_${DateTime.now().millisecondsSinceEpoch}',
          'isAgent': true,
          'agentName': agentName,
          'text':
              'Thank you for reaching out! Regarding "$userText", I have updated your ticket in our system. You can track your order or view your wallet balance directly.',
          'time': 'Just now',
          'type': 'general_resolution',
        });
      });
    }
    _scrollToBottom();
  }

  void _escalateToSeniorManager() {
    setState(() {
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
    });
    _scrollToBottom();
  }

  void _issueInstantRefund(String itemName, String price) {
    setState(() {
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
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: _isEscalatedToManager
                      ? AppColors.primaryContainer
                      : const Color(0xFFDCE5DD),
                  child: Icon(
                    _isEscalatedToManager
                        ? Icons.verified_user_rounded
                        : Icons.support_agent_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _activeAgentName,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      if (_isEscalatedToManager) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    _activeAgentRole,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurface),
            onSelected: (value) {
              switch (value) {
                case 'call':
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Call Customer Support',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      content: Text(
                          'Calling Daily Basket Priority Support hotline at +1 (800) DAILY-BASKET',
                          style: GoogleFonts.inter(fontSize: 14)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary),
                          child: const Text('Dial Now'),
                        ),
                      ],
                    ),
                  );
                  break;
                case 'manager':
                  _escalateToSeniorManager();
                  break;
                case 'transcript':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Chat transcript emailed to your address!')),
                  );
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'call',
                child: Row(
                  children: [
                    Icon(Icons.phone_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Text('Call Priority Helpline'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'manager',
                child: Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Text('Connect Senior Manager'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'transcript',
                child: Row(
                  children: [
                    Icon(Icons.email_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Text('Email Chat Summary'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages Canvas
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEF0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Today • Priority Support Active',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }

                    final msg = _messages[index - 1];
                    final isAgent = msg['isAgent'] as bool;
                    final msgType = msg['type'] as String? ?? 'text';
                    final data = msg['data'] as Map<String, dynamic>?;

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 300),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: Align(
                    alignment:
                        isAgent ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.82,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isAgent
                            ? const Color(0xFFEEEEF0)
                            : AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isAgent ? 4 : 18),
                          bottomRight: Radius.circular(isAgent ? 18 : 4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isAgent
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          if (isAgent)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg['agentName'] ?? _activeAgentName,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (_isEscalatedToManager) ...[
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'LEAD',
                                        style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                          Text(
                            msg['text'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.4,
                              color: isAgent
                                  ? AppColors.onSurface
                                  : Colors.white,
                            ),
                          ),

                          // Custom Interactive Card Extensions
                          if (msgType == 'order_status' && data != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.outlineVariant
                                        .withValues(alpha: 0.40)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['orderId'] ?? '#DB-9824',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          data['eta'] ?? '3 mins away',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.two_wheeler_rounded,
                                          size: 16, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Rider: ${data['riderName']} (${data['location']})',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.onSurfaceVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 36,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Calling Rider ${data['riderName']} at ${data['riderPhone']}'),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.phone, size: 16),
                                      label: const Text('Call Rider'),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          if (msgType == 'refund_card' && data != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FFF2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.30)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Refund Amount',
                                        style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors.onSurfaceVariant),
                                      ),
                                      Text(
                                        data['amount'] ?? '₹120.00',
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Txn ID: ${data['txnId']} • ${data['method']}',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          if (msgType == 'item_complaint' && data != null) ...[
                            const SizedBox(height: 10),
                            Column(
                              children: (data['items']
                                      as List<Map<String, String>>)
                                  .map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.outlineVariant
                                            .withValues(alpha: 0.30)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['name']!,
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => _issueInstantRefund(
                                            item['name']!, item['price']!),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Claim ${item['price']}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 4),
                          Text(
                            msg['time'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isAgent
                                  ? AppColors.onSurfaceVariant
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      ),

            // Quick Reply Action Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildQuickReplyChip('Delivery delay', Icons.bolt_rounded),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Damaged product', Icons.broken_image_rounded),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Refund status', Icons.account_balance_wallet_rounded),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Missing item', Icons.inventory_2_rounded),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Talk to Manager', Icons.support_agent_rounded),
                ],
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E2E5))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.inter(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Type your message or issue...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F3F6),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: AppColors.primary),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyChip(String text, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE2E2E5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => _sendMessage(text),
    );
  }
}
