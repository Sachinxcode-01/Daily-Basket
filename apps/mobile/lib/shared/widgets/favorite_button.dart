import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/providers/favorites_provider.dart';
import '../../core/theme/app_theme.dart';

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
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isNowFav ? AppColors.onPrimary : AppColors.inverseOnSurface,
          ),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isNowFav ? AppColors.primary : AppColors.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FavoritesProvider? favProvider;
    try {
      favProvider = context.watch<FavoritesProvider>();
    } catch (_) {}
    final isFav = favProvider?.isFavorite(widget.productId) ?? false;

    return InkWell(
      onTap: () {
        if (favProvider != null) {
          _onTap(favProvider);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: widget.padding,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: widget.size,
            color: isFav
                ? (widget.activeColor ?? AppColors.error)
                : (widget.inactiveColor ?? AppColors.outlineVariant),
          ),
        ),
      ),
    );
  }
}
