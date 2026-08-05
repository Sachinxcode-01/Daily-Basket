import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/favorites_provider.dart';

class FavoriteButton extends StatefulWidget {
  final String productId;
  final Map<String, dynamic>? productDetails;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry padding;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.productDetails,
    this.size = 22.0,
    this.activeColor,
    this.inactiveColor,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(FavoritesProvider provider) {
    _controller.forward().then((_) => _controller.reverse());
    provider.toggleFavorite(widget.productId, widget.productDetails);

    final isNowFav = provider.isFavorite(widget.productId);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowFav ? 'Added to Favorites ❤️' : 'Removed from Favorites 💔',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isNowFav ? const Color(0xFF0F766E) : const Color(0xFF334155),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(widget.productId);

    return InkWell(
      onTap: () => _onTap(favProvider),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: widget.padding,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: widget.size,
            color: isFav
                ? (widget.activeColor ?? const Color(0xFFEF4444))
                : (widget.inactiveColor ?? const Color(0xFF94A3B8)),
          ),
        ),
      ),
    );
  }
}
