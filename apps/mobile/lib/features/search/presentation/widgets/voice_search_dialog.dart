import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/services/voice_chat_service.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Real-Time AI Voice Shopping Modal for Daily Basket Quick-Commerce
/// Designed strictly according to design.md (Primary: #2d9d43, Outfit font, 24px top sheet)
class VoiceSearchDialog extends StatefulWidget {
  final Function(String query)? onSearchCompleted;
  final ApiClient? apiClient;
  final VoiceChatService? voiceService;

  const VoiceSearchDialog({
    super.key,
    this.onSearchCompleted,
    this.apiClient,
    this.voiceService,
  });

  static Future<void> show(
    BuildContext context, {
    Function(String query)? onSpeechResult,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => VoiceSearchDialog(
        onSearchCompleted: onSpeechResult,
      ),
    );
  }

  @override
  State<VoiceSearchDialog> createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends State<VoiceSearchDialog>
    with SingleTickerProviderStateMixin {
  late final ApiClient _apiClient;
  late final VoiceChatService _voiceService;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  VoiceSearchState _state = VoiceSearchState.idle;
  String _liveTranscription = '';
  String _selectedLocale = 'en_IN';
  String? _errorMessage;

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearchingApi = false;

  final TextEditingController _editController = TextEditingController();

  final List<Map<String, String>> _availableLocales = [
    {'code': 'en_IN', 'label': 'English'},
    {'code': 'hi_IN', 'label': 'हिंदी'},
    {'code': 'kn_IN', 'label': 'ಕನ್ನಡ'},
  ];

  @override
  void initState() {
    super.initState();
    _apiClient = widget.apiClient ?? ApiClient();
    _voiceService = widget.voiceService ?? VoiceChatService();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.28).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-start push-to-talk voice recording on modal open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVoiceCapture();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _editController.dispose();
    _voiceService.cancelListening();
    super.dispose();
  }

  Future<void> _startVoiceCapture() async {
    setState(() {
      _state = VoiceSearchState.requestingPermission;
      _errorMessage = null;
      _searchResults = [];
      _liveTranscription = '';
    });

    final hasPermission = await _voiceService.initialize();
    if (!mounted) return;

    if (!hasPermission) {
      setState(() {
        _state = VoiceSearchState.permissionDenied;
        _errorMessage = 'Microphone permission is required for voice shopping.';
      });
      return;
    }

    _voiceService.setLocale(_selectedLocale);
    final isTestEnv = !kIsWeb &&
        (Platform.environment.containsKey('FLUTTER_TEST') ||
            Platform.environment.containsKey('CI'));
    if (!isTestEnv) {
      _pulseController.repeat(reverse: true);
    }

    setState(() {
      _state = VoiceSearchState.recording;
    });

    await _voiceService.startListening(
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() {
          _liveTranscription = text;
          _editController.text = text;
        });

        if (isFinal && text.trim().isNotEmpty) {
          _stopAndSearchCatalogue(text.trim());
        }
      },
      onError: (err) {
        if (!mounted) return;
        _pulseController.stop();
        setState(() {
          _state = VoiceSearchState.networkError;
          _errorMessage = err;
        });
      },
    );
  }

  Future<void> _stopAndSearchCatalogue([String? textOverride]) async {
    _pulseController.stop();
    final queryText = (textOverride ?? _liveTranscription).trim();

    if (queryText.isEmpty) {
      setState(() {
        _state = VoiceSearchState.invalidAudio;
        _errorMessage = 'No speech detected. Please speak clearly or type your product.';
      });
      return;
    }

    setState(() {
      _state = VoiceSearchState.processing;
      _isSearchingApi = true;
      _errorMessage = null;
    });

    try {
      final res = await _apiClient.voiceSearch(
        queryHint: queryText,
        languageHint: _selectedLocale,
        currentRoute: '/search',
      );

      if (!mounted) return;

      if (res['success'] == true && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;
        final rawResults = (data['results'] as List?) ?? [];
        final parsed = rawResults.map((e) => Map<String, dynamic>.from(e as Map)).toList();

        setState(() {
          _searchResults = parsed;
          _state = VoiceSearchState.showingResults;
          _isSearchingApi = false;
        });

        if (widget.onSearchCompleted != null) {
          widget.onSearchCompleted!(data['searchQuery'] ?? queryText);
        }
      } else {
        setState(() {
          _state = VoiceSearchState.providerUnavailable;
          _errorMessage = res['error'] ?? 'Voice service is currently busy. Please search with text.';
          _isSearchingApi = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = VoiceSearchState.networkError;
        _errorMessage = 'Could not reach server: $e';
        _isSearchingApi = false;
      });
    }
  }

  void _onAddToCart(BuildContext context, Map<String, dynamic> product) {
    final cart = context.read<CartProvider>();
    final productId = product['id']?.toString() ?? 'prod_${DateTime.now().millisecondsSinceEpoch}';
    final name = product['name']?.toString() ?? 'Daily Basket Item';
    final unit = product['unit']?.toString() ?? '1 unit';
    final price = (product['price'] as num?)?.toDouble() ?? 50.0;
    final image = product['imageUrl']?.toString() ?? '';

    cart.updateQuantityById(
      id: productId,
      name: name,
      subtitle: unit,
      price: price,
      image: image,
      delta: 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $name to basket (₹${price.round()})'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2D9D43),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FC), // surface token
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFBECAB9), // outline-variant
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with Title and Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Voice Shopping',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF191C1E),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                onPressed: () => Navigator.pop(context),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Horizontal Language Chips
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _availableLocales.map((loc) {
                  final isSelected = _selectedLocale == loc['code'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        loc['label']!,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF2D9D43),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2D9D43),
                      backgroundColor: const Color(0xFFECEEF0),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      visualDensity: VisualDensity.compact,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedLocale = loc['code']!;
                          });
                          _startVoiceCapture();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Central Microphone or Content Area
          if (_state == VoiceSearchState.recording || _state == VoiceSearchState.idle || _state == VoiceSearchState.requestingPermission)
            _buildListeningView()
          else if (_state == VoiceSearchState.processing || _isSearchingApi)
            _buildProcessingView()
          else if (_state == VoiceSearchState.showingResults)
            Expanded(child: _buildResultsView())
          else
            _buildErrorView(),
        ],
      ),
    );
  }

  Widget _buildListeningView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Pulsing Microphone Button
        GestureDetector(
          onTap: () async {
            if (_state == VoiceSearchState.recording) {
              final finalWords = await _voiceService.stopListening();
              _stopAndSearchCatalogue(finalWords);
            } else {
              _startVoiceCapture();
            }
          },
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              final scale = _state == VoiceSearchState.recording ? _pulseAnimation.value : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D9D43),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2D9D43).withValues(alpha: 0.35),
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _state == VoiceSearchState.recording ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        Text(
          _state == VoiceSearchState.recording ? 'Listening... Speak your grocery items' : 'Tap to Speak',
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 10),

        // Live recognized words
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E3E5)),
          ),
          child: Text(
            _liveTranscription.isNotEmpty
                ? '"$_liveTranscription"'
                : 'e.g. "Find one litre of milk", "Rice under 100 rupees", "Organic tomatoes"',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _liveTranscription.isNotEmpty ? const Color(0xFF191C1E) : const Color(0xFF94A3B8),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Done speaking button
        if (_liveTranscription.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () => _stopAndSearchCatalogue(),
            icon: const Icon(Icons.search, size: 18),
            label: Text(
              'Search Catalogue',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D9D43),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(200, 48),
            ),
          ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D9D43)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Searching Daily Basket Catalogue...',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191C1E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '"$_liveTranscription"',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    final cart = context.watch<CartProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Query header with edit option
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFECEEF0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.mic, size: 20, color: Color(0xFF2D9D43)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _liveTranscription,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF191C1E),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF64748B)),
                onPressed: _startVoiceCapture,
                tooltip: 'Re-speak',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Results count / availability header
        Text(
          _searchResults.isNotEmpty
              ? 'Found ${_searchResults.length} matching products in stock:'
              : 'No exact matches found in catalogue',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 10),

        if (_searchResults.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Color(0xFFBECAB9)),
                  const SizedBox(height: 12),
                  Text(
                    'No products match "$_liveTranscription"',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _startVoiceCapture,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D9D43),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Try Another Item'),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, index) {
                final p = _searchResults[index];
                final id = p['id']?.toString() ?? 'p_$index';
                final name = p['name']?.toString() ?? 'Daily Basket Item';
                final brand = p['brand']?.toString() ?? 'Daily Basket';
                final unit = p['unit']?.toString() ?? '1 unit';
                final price = (p['price'] as num?)?.toDouble() ?? 50.0;
                final mrp = (p['mrp'] as num?)?.toDouble() ?? price;
                final imageUrl = p['imageUrl']?.toString() ?? '';
                final currentQty = cart.getQuantity(id);

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFECEEF0)),
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 64,
                          height: 64,
                          color: const Color(0xFFF3F3F6),
                          child: imageUrl.isNotEmpty
                              ? AppNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.shopping_basket, color: Color(0xFF2D9D43)),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              brand.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF191C1E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              unit,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${price.round()}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF2D9D43),
                                  ),
                                ),
                                if (mrp > price) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '₹${mrp.round()}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Add to Cart / Qty Control
                      if (currentQty <= 0)
                        ElevatedButton(
                          onPressed: () => _onAddToCart(context, p),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D9D43),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: const Size(64, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'ADD',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D9D43),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                onPressed: () {
                                  cart.updateQuantityById(
                                    id: id,
                                    name: name,
                                    subtitle: unit,
                                    price: price,
                                    image: imageUrl,
                                    delta: -1,
                                  );
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                              Text(
                                '$currentQty',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                onPressed: () {
                                  cart.updateQuantityById(
                                    id: id,
                                    name: name,
                                    subtitle: unit,
                                    price: price,
                                    image: imageUrl,
                                    delta: 1,
                                  );
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        children: [
          const Icon(Icons.info_outline, size: 48, color: Color(0xFFBA1A1A)),
          const SizedBox(height: 14),
          Text(
            _errorMessage ?? 'Voice search encountered an error.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191C1E),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.keyboard, size: 18),
                label: const Text('Type Instead'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2D9D43),
                  side: const BorderSide(color: Color(0xFF2D9D43)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(120, 48),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _startVoiceCapture,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D9D43),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(120, 48),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
