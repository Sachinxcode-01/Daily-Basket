import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/ai_chat_provider.dart';

/// Professional Live Support Chat Screen — Google Stitch Specification
/// Enterprise AI Live Agent Integration
class LiveSupportChatScreen extends StatefulWidget {
  const LiveSupportChatScreen({super.key});

  @override
  State<LiveSupportChatScreen> createState() => _LiveSupportChatScreenState();
}

class _LiveSupportChatScreenState extends State<LiveSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

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

  void _handleSendMessage(AiChatProvider provider, [String? inputQuery]) {
    final text = inputQuery ?? _messageController.text.trim();
    if (text.isEmpty) return;

    if (inputQuery == null) {
      _messageController.clear();
    }

    provider.sendMessage(
      text,
      screenContext: {
        'currentRoute': '/chat',
        'activeOrderId': '#DB-9824',
        'cartItemCount': 3,
      },
    );

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AiChatProvider>(
      builder: (context, aiProvider, child) {
        final messages = aiProvider.messages;
        final isEscalated = aiProvider.isEscalatedToManager;
        final agentName = aiProvider.activeAgentName;
        final agentRole = aiProvider.activeAgentRole;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FC),
          appBar: AppBar(
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search chat history...',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant),
                    ),
                    onChanged: (val) => aiProvider.setSearchQuery(val),
                  )
                : Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 19,
                            backgroundColor: isEscalated
                                ? AppColors.primaryContainer
                                : const Color(0xFFDCE5DD),
                            child: Icon(
                              isEscalated
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
                                  agentName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                if (isEscalated) ...[
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
                              agentRole,
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
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close_rounded : Icons.search_rounded,
                  color: AppColors.onSurface,
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      aiProvider.setSearchQuery('');
                    }
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurface),
                onSelected: (value) {
                  switch (value) {
                    case 'call':
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Call Priority Support',
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
                      aiProvider.escalateToManagerExplicitly();
                      _scrollToBottom();
                      break;
                    case 'transcript':
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Chat transcript exported & sent to your email!')),
                      );
                      break;
                    case 'clear':
                      aiProvider.clearHistory();
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
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text('Clear Chat Session'),
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
                // Chat Canvas
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: messages.length + (aiProvider.isLoading ? 2 : 1),
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

                        if (aiProvider.isLoading && index == messages.length + 1) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEF0),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Agent is typing...',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final msg = messages[index - 1];
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
                                alignment: isAgent
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.82,
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
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                msg['agentName'] ?? agentName,
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              if (isEscalated) ...[
                                                const SizedBox(width: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 6, vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(8),
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

                                      // Order Status Live Action Card
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2),
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
                                                  const Icon(
                                                      Icons.two_wheeler_rounded,
                                                      size: 16,
                                                      color: AppColors.primary),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      'Rider: ${data['riderName']} (${data['location']})',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .onSurfaceVariant),
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
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Calling Rider ${data['riderName']} at ${data['riderPhone']}'),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(Icons.phone,
                                                      size: 16),
                                                  label: const Text('Call Rider'),
                                                  style: OutlinedButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    minimumSize: Size.zero,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      // Refund Action Card
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Refund Amount',
                                                    style: GoogleFonts.inter(
                                                        fontSize: 11,
                                                        color: AppColors
                                                            .onSurfaceVariant),
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
                                                    color: AppColors
                                                        .onSurfaceVariant),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      // Item Complaint Picker Card
                                      if (msgType == 'item_complaint' && data != null) ...[
                                        const SizedBox(height: 10),
                                        Column(
                                          children: (data['items'] as List)
                                              .map<Widget>((item) {
                                            final mapItem = Map<String, String>.from(item);
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
                                                      mapItem['name']!,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () =>
                                                        aiProvider.issueInstantRefund(
                                                            mapItem['name']!,
                                                            mapItem['price']!),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primary,
                                                        borderRadius:
                                                            BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        'Claim ${mapItem['price']}',
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
                      _buildQuickReplyChip(
                          aiProvider, 'Delivery delay', Icons.bolt_rounded),
                      const SizedBox(width: 8),
                      _buildQuickReplyChip(aiProvider, 'Damaged product',
                          Icons.broken_image_rounded),
                      const SizedBox(width: 8),
                      _buildQuickReplyChip(aiProvider, 'Refund status',
                          Icons.account_balance_wallet_rounded),
                      const SizedBox(width: 8),
                      _buildQuickReplyChip(
                          aiProvider, 'Missing item', Icons.inventory_2_rounded),
                      const SizedBox(width: 8),
                      _buildQuickReplyChip(aiProvider, 'Talk to Manager',
                          Icons.support_agent_rounded),
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
                              color: AppColors.onSurfaceVariant
                                  .withValues(alpha: 0.7),
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
                          onSubmitted: (_) => _handleSendMessage(aiProvider),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send_rounded,
                            color: AppColors.primary),
                        onPressed: () => _handleSendMessage(aiProvider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickReplyChip(
      AiChatProvider provider, String text, IconData icon) {
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
      onPressed: () => _handleSendMessage(provider, text),
    );
  }
}
