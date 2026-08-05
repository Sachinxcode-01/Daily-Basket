import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/ai_chat_provider.dart';
import '../../../../core/services/voice_chat_service.dart';
import '../../../../core/services/image_analysis_service.dart';

/// Stitch Screen: Enterprise AI Live Agent Support Chat
/// ID: live_support_chat_enterprise_v2
class LiveSupportChatScreen extends StatefulWidget {
  const LiveSupportChatScreen({super.key});

  @override
  State<LiveSupportChatScreen> createState() => _LiveSupportChatScreenState();
}

class _LiveSupportChatScreenState extends State<LiveSupportChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final VoiceChatService _voiceService = VoiceChatService();
  final ImageAnalysisService _imageService = ImageAnalysisService();

  bool _isSearching = false;
  bool _isVoiceMode = false;
  String _voiceTranscript = '';
  String _selectedLocale = 'en_IN';

  // Mic pulse animation
  late AnimationController _micPulseController;
  late Animation<double> _micPulseAnimation;

  // Typing indicator dots animation
  late AnimationController _typingDotController;
  late Animation<double> _typingDotAnimation;

  @override
  void initState() {
    super.initState();
    _voiceService.initialize();

    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _micPulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _micPulseController, curve: Curves.easeInOut),
    );

    _typingDotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _typingDotAnimation = CurvedAnimation(
      parent: _typingDotController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _micPulseController.dispose();
    _typingDotController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(AiChatProvider provider, [String? inputQuery]) {
    final text = (inputQuery ?? _messageController.text).trim();
    if (text.isEmpty) return;
    if (inputQuery == null) _messageController.clear();
    provider.sendMessage(text, screenContext: {
      'currentRoute': '/chat',
      'activeOrderId': '#DB-9824',
      'cartItemCount': 3,
      'language': provider.detectedLanguage,
    });
    _scrollToBottom();
  }

  // ─── Voice Input ───────────────────────────────────────────────────────────

  void _openVoiceSheet(AiChatProvider provider) {
    _voiceService.setLocale(_selectedLocale);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildVoiceSheet(ctx, provider),
    );
  }

  Widget _buildVoiceSheet(BuildContext ctx, AiChatProvider provider) {
    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('Voice Input',
                  style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface)),
              const SizedBox(height: 8),

              // Language selection chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: VoiceChatService.supportedLanguages.map((lang) {
                    final isSelected = _selectedLocale == lang['code'];
                    return GestureDetector(
                      onTap: () {
                        setSheetState(() => _selectedLocale = lang['code']!);
                        _voiceService.setLocale(lang['code']!);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFF3F3F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          '${lang['flag']} ${lang['name']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Mic button with pulse
              GestureDetector(
                onTapDown: (_) async {
                  setSheetState(() {
                    _isVoiceMode = true;
                    _voiceTranscript = '';
                  });
                  provider.setRecording(true);

                  await _voiceService.startListening(
                    onResult: (text, isFinal) {
                      setSheetState(() => _voiceTranscript = text);
                      if (isFinal && text.isNotEmpty) {
                        Navigator.pop(ctx);
                        provider.setRecording(false);
                        provider.sendVoiceMessage(text);
                        _scrollToBottom();
                      }
                    },
                    onError: (error) {
                      setSheetState(() => _isVoiceMode = false);
                      provider.setRecording(false);
                    },
                  );
                },
                onTapUp: (_) async {
                  final transcribed = await _voiceService.stopListening();
                  setSheetState(() => _isVoiceMode = false);
                  provider.setRecording(false);
                  if (transcribed.isNotEmpty) {
                    if (ctx.mounted) Navigator.pop(ctx);
                    provider.sendVoiceMessage(transcribed);
                    _scrollToBottom();
                  }
                },
                child: AnimatedBuilder(
                  animation: _micPulseAnimation,
                  builder: (context, child) {
                    final scale = _isVoiceMode ? _micPulseAnimation.value : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: _isVoiceMode
                                ? [
                                    AppColors.primary.withValues(alpha: 0.8),
                                    AppColors.primary
                                  ]
                                : [
                                    const Color(0xFFE8F5E9),
                                    const Color(0xFFDCE5DD)
                                  ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: _isVoiceMode
                              ? [
                                  BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 8)
                                ]
                              : [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4))
                                ],
                        ),
                        child: Icon(
                          _isVoiceMode ? Icons.stop_rounded : Icons.mic_rounded,
                          size: 40,
                          color: _isVoiceMode
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              Text(
                _isVoiceMode
                    ? 'Listening... Release to send'
                    : 'Hold mic to speak',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isVoiceMode
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),

              if (_voiceTranscript.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"$_voiceTranscript"',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.onSurface),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ─── Image Attachment Sheet ────────────────────────────────────────────────

  void _openAttachmentSheet(AiChatProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('Share Image',
                  style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface)),
              const SizedBox(height: 6),
              Text('Send a photo of the issue for instant AI analysis',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: const Color(0xFF006B23),
                    onTap: () async {
                      Navigator.pop(ctx);
                      final file = await _imageService.captureFromCamera();
                      if (file != null && mounted) {
                        provider.sendImageMessage(file,
                            caption: '📷 Camera photo');
                        _scrollToBottom();
                      } else {
                        _simulateImageUpload(provider);
                      }
                    },
                  ),
                  _buildAttachOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: const Color(0xFF1565C0),
                    onTap: () async {
                      Navigator.pop(ctx);
                      final file = await _imageService.pickFromGallery();
                      if (file != null && mounted) {
                        provider.sendImageMessage(file,
                            caption: '🖼️ Gallery image');
                        _scrollToBottom();
                      } else {
                        _simulateImageUpload(provider);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface)),
        ],
      ),
    );
  }

  /// Simulate an image upload for demo/testing when image_picker is unavailable.
  void _simulateImageUpload(AiChatProvider provider) {
    provider.sendImageMessage(
      File('simulated_image.jpg'),
      caption: '📷 Product image',
    );
    _scrollToBottom();
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<AiChatProvider>(
      builder: (context, aiProvider, child) {
        final messages = aiProvider.messages;
        final isEscalated = aiProvider.isEscalatedToManager;
        final agentName = aiProvider.activeAgentName;
        final agentRole = aiProvider.activeAgentRole;
        final isStreaming = aiProvider.isStreaming || aiProvider.isLoading;

        // Auto-scroll when new messages arrive
        if (messages.isNotEmpty) _scrollToBottom();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FC),
          appBar: _buildAppBar(aiProvider, agentName, agentRole, isEscalated),
          body: SafeArea(
            child: Column(
              children: [
                // ── Chat Canvas ──────────────────────────────────────────────
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: messages.length + (isStreaming ? 0 : 0) + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) return _buildDateBadge();

                        final msg = messages[index - 1];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 300),
                          child: SlideAnimation(
                            verticalOffset: 30.0,
                            child: FadeInAnimation(
                              child: _buildMessageBubble(msg, aiProvider, isEscalated, agentName),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ── Quick Reply Chips ────────────────────────────────────────
                if (!isStreaming)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        _chip(aiProvider, '📦 Track order',
                            Icons.local_shipping_rounded),
                        const SizedBox(width: 8),
                        _chip(aiProvider, '💳 Wallet balance',
                            Icons.account_balance_wallet_rounded),
                        const SizedBox(width: 8),
                        _chip(aiProvider, '🏷️ My coupons',
                            Icons.local_offer_rounded),
                        const SizedBox(width: 8),
                        _chip(aiProvider, '🥦 Damaged product',
                            Icons.broken_image_rounded),
                        const SizedBox(width: 8),
                        _chip(aiProvider, '👤 Talk to Manager',
                            Icons.support_agent_rounded),
                      ],
                    ),
                  ),

                // ── Input Bar ────────────────────────────────────────────────
                _buildInputBar(aiProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(AiChatProvider provider, String agentName,
      String agentRole, bool isEscalated) {
    return AppBar(
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
                hintText: 'Search chat...',
                border: InputBorder.none,
                hintStyle: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.onSurfaceVariant),
              ),
              onChanged: (v) => provider.setSearchQuery(v),
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
                          color: const Color(0xFF4CAF50),
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
                          Text(agentName,
                              style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface)),
                          if (isEscalated) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded,
                                size: 16, color: AppColors.primary),
                          ],
                        ],
                      ),
                      Text(agentRole,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
      actions: [
        IconButton(
          icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: AppColors.onSurface),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                provider.setSearchQuery('');
              }
            });
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.onSurface),
          onSelected: (value) {
            switch (value) {
              case 'call':
                _showCallDialog();
                break;
              case 'manager':
                provider.escalateToManagerExplicitly();
                _scrollToBottom();
                break;
              case 'transcript':
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Chat transcript sent to your email! 📧')));
                break;
              case 'clear':
                provider.clearHistory();
                break;
            }
          },
          itemBuilder: (ctx) => const [
            PopupMenuItem(
                value: 'call',
                child: Row(children: [
                  Icon(Icons.phone_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Call Priority Helpline'),
                ])),
            PopupMenuItem(
                value: 'manager',
                child: Row(children: [
                  Icon(Icons.shield_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Connect Senior Manager'),
                ])),
            PopupMenuItem(
                value: 'transcript',
                child: Row(children: [
                  Icon(Icons.email_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Email Chat Summary'),
                ])),
            PopupMenuItem(
                value: 'clear',
                child: Row(children: [
                  Icon(Icons.delete_outline_rounded,
                      color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Text('Clear Chat Session'),
                ])),
          ],
        ),
      ],
    );
  }

  // ─── Date Badge ────────────────────────────────────────────────────────────

  Widget _buildDateBadge() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEF0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Today • Priority Support Active',
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }

  // ─── Message Bubble ────────────────────────────────────────────────────────

  Widget _buildMessageBubble(Map<String, dynamic> msg,
      AiChatProvider provider, bool isEscalated, String agentName) {
    final isAgent = msg['isAgent'] as bool;
    final msgType = msg['type'] as String? ?? 'text';
    final data = msg['data'] as Map<String, dynamic>?;
    final isStreamingMsg = msg['isStreaming'] as bool? ?? false;
    final isVoice = msg['isVoice'] as bool? ?? false;
    final imagePath = msg['imagePath'] as String?;

    return GestureDetector(
      onLongPress: () {
        final text = msg['text'] as String? ?? '';
        if (text.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Message copied to clipboard'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating));
        }
      },
      child: Align(
        alignment: isAgent ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isAgent ? const Color(0xFFEEEEF0) : AppColors.primary,
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
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: isAgent
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              // Agent name header
              if (isAgent) _buildAgentNameRow(msg, agentName, isEscalated),

              // Voice indicator
              if (isVoice && !isAgent)
                Row(children: [
                  const Icon(Icons.mic_rounded, size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text('Voice',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic)),
                  const SizedBox(height: 4),
                ]),

              // Image uploaded preview
              if (imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    color: const Color(0xFFDCE5DD),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_rounded,
                            size: 48, color: AppColors.primary),
                        const SizedBox(height: 4),
                        Text('Image uploaded',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Main text (with streaming cursor effect)
              if ((msg['text'] as String? ?? '').isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        msg['text'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.4,
                          color: isAgent
                              ? AppColors.onSurface
                              : Colors.white,
                        ),
                      ),
                    ),
                    if (isStreamingMsg && isAgent) ...[
                      const SizedBox(width: 4),
                      AnimatedBuilder(
                        animation: _typingDotAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: (_typingDotAnimation.value * 2).clamp(0, 1),
                            child: Container(
                              width: 6,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),

              // Image analysis card
              if (msgType == 'image_analysis' && data != null)
                _buildImageAnalysisCard(data),

              // Order Status Card
              if (msgType == 'order_status' && data != null)
                _buildOrderStatusCard(data),

              // Refund Card
              if (msgType == 'refund_card' && data != null)
                _buildRefundCard(data),

              // Item Complaint Card
              if (msgType == 'item_complaint' && data != null)
                _buildItemComplaintCard(data, provider),

              // Manager Transfer Card
              if (msgType == 'manager_transfer' && data != null)
                _buildManagerCard(data),

              // Timestamp
              const SizedBox(height: 4),
              Text(
                msg['time'] as String? ?? '',
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
    );
  }

  Widget _buildAgentNameRow(
      Map<String, dynamic> msg, String agentName, bool isEscalated) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            msg['agentName'] as String? ?? agentName,
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.primary),
          ),
          if (isEscalated) ...[
            const SizedBox(width: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('LEAD',
                  style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Rich Cards ────────────────────────────────────────────────────────────

  Widget _buildImageAnalysisCard(Map<String, dynamic> data) {
    final suggestRefund = data['suggestRefund'] as bool? ?? false;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.image_search_rounded,
                size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text('AI Image Analysis',
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ]),
          const SizedBox(height: 6),
          Text(data['finding'] as String? ?? 'Issue detected',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.onSurface)),
          if (suggestRefund) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('⚡ Instant Refund Available',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['orderId'] ?? '#DB-9824',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(data['eta'] ?? '3 mins away',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.two_wheeler_rounded,
                size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Rider: ${data['riderName']} (${data['location']})',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Calling Rider ${data['riderName']} at ${data['riderPhone']}')),
              ),
              icon: const Icon(Icons.phone, size: 16),
              label: const Text('Call Rider'),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FFF2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Refund Amount',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.onSurfaceVariant)),
              Text(data['amount'] ?? '₹0',
                  style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Txn: ${data['txnId']} • ${data['method']}',
              style: GoogleFonts.inter(
                  fontSize: 10, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildItemComplaintCard(
      Map<String, dynamic> data, AiChatProvider provider) {
    return Column(
      children: (data['items'] as List)
          .map<Widget>((item) {
        final mapItem = Map<String, String>.from(item as Map);
        return Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(mapItem['name'] ?? '',
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              InkWell(
                onTap: () => provider.issueInstantRefund(
                    mapItem['name'] ?? '', mapItem['price'] ?? '₹0'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Claim ${mapItem['price']}',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildManagerCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF004D1A), Color(0xFF006B23)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['managerTitle'] ?? 'Senior Manager',
                    style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text(data['badge'] ?? 'PRIORITY ESCALATION',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Input Bar ─────────────────────────────────────────────────────────────

  Widget _buildInputBar(AiChatProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E2E5))),
      ),
      child: Row(
        children: [
          // Attachment button
          _inputIconButton(
            icon: Icons.attach_file_rounded,
            tooltip: 'Attach Image',
            onTap: () => _openAttachmentSheet(provider),
          ),
          const SizedBox(width: 4),

          // Text input
          Expanded(
            child: TextField(
              controller: _messageController,
              style: GoogleFonts.inter(fontSize: 14),
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
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
              onSubmitted: (_) => _handleSendMessage(provider),
            ),
          ),
          const SizedBox(width: 4),

          // Voice button
          _inputIconButton(
            icon: provider.isRecording
                ? Icons.stop_rounded
                : Icons.mic_rounded,
            tooltip: 'Voice Input',
            color: provider.isRecording
                ? Colors.red
                : AppColors.primary,
            onTap: () => _openVoiceSheet(provider),
          ),
          const SizedBox(width: 4),

          // Send button
          GestureDetector(
            onTap: () => _handleSendMessage(provider),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color ?? AppColors.onSurfaceVariant),
        ),
      ),
    );
  }

  // ─── Quick Reply Chips ─────────────────────────────────────────────────────

  Widget _chip(AiChatProvider provider, String text, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(text,
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE2E2E5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        // Strip emoji prefix before sending
        final clean = text.replaceAll(RegExp(r'[^\x00-\x7F]+\s*'), '').trim();
        _handleSendMessage(provider, clean);
      },
    );
  }

  // ─── Call Dialog ───────────────────────────────────────────────────────────

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Call Priority Support',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text(
            'Calling Daily Basket Priority Support hotline at +91 1800-DAILY-BASKET',
            style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Dial Now')),
        ],
      ),
    );
  }
}
