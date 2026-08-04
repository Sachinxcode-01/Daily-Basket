import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Live Support Chat Screen — Exact Google Stitch Specification
/// Screen ID: a34a964ee4394b3a8917511452822264
class LiveSupportChatScreen extends StatefulWidget {
  const LiveSupportChatScreen({super.key});

  @override
  State<LiveSupportChatScreen> createState() => _LiveSupportChatScreenState();
}

class _LiveSupportChatScreenState extends State<LiveSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isAgent': true,
      'text':
          'Hi there! Thanks for reaching out to Daily Basket support. How can I help make your day a little fresher?',
      'time': '10:42 AM',
      'agentName': 'Sarah J.',
    },
    {
      'isAgent': false,
      'text':
          'Hi, I just received my order (#DB-9824) but there seems to be a minor issue with one item.',
      'time': '10:44 AM',
    },
    {
      'isAgent': true,
      'text':
          'I am so sorry to hear that! I can see order #DB-9824 in your account. Which item was affected? We can issue an instant refund right away.',
      'time': '10:45 AM',
      'agentName': 'Sarah J.',
    },
  ];

  void _sendMessage([String? quickReplyText]) {
    final text = quickReplyText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isAgent': false,
        'text': text,
        'time': 'Just now',
      });
      if (quickReplyText == null) {
        _messageController.clear();
      }
    });

    // Simulate Agent Auto Response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'isAgent': true,
            'text':
                'Thank you for providing the detail. I have initiated a 100% instant refund of ₹120 to your Daily Basket Wallet.',
            'time': 'Just now',
            'agentName': 'Sarah J.',
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1C1E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFDCE5DD),
                  child: Icon(Icons.support_agent_rounded,
                      color: Color(0xFF006B23), size: 22),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006B23),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah J.',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                Text(
                  'Support Agent • Online',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF006B23),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1A1C1E)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages Canvas
            Expanded(
              child: ListView.builder(
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
                          'Today, 10:42 AM',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF3F4A3D),
                          ),
                        ),
                      ),
                    );
                  }

                  final msg = _messages[index - 1];
                  final isAgent = msg['isAgent'] as bool;

                  return Align(
                    alignment:
                        isAgent ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isAgent
                            ? const Color(0xFFEEEEF0)
                            : const Color(0xFF006B23),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isAgent ? 4 : 16),
                          bottomRight: Radius.circular(isAgent ? 16 : 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isAgent
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          if (isAgent)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                msg['agentName'] ?? 'Agent',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF006B23),
                                ),
                              ),
                            ),
                          Text(
                            msg['text'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.4,
                              color: isAgent
                                  ? const Color(0xFF1A1C1E)
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg['time'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isAgent
                                  ? const Color(0xFF3F4A3D)
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Quick Reply Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildQuickReplyChip('Missing item'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Delivery delay'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Damaged product'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Refund status'),
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
                        hintText: 'Type your message...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF3F4A3D),
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
                        color: Color(0xFF006B23)),
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

  Widget _buildQuickReplyChip(String text) {
    return ActionChip(
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A1C1E),
        ),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE2E2E5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => _sendMessage(text),
    );
  }
}
