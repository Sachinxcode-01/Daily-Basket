import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// App Network Image Component with Loading Shimmer & Visual Fallback
/// Ensures category and product images ALWAYS render beautifully across the app.
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;
  final Color? fallbackBgColor;
  final Color? fallbackIconColor;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.shopping_basket_rounded,
    this.fallbackBgColor,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(12);

    Widget fallbackWidget() {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: fallbackBgColor ?? const Color(0xFFF3F3F6),
          borderRadius: effectiveRadius,
        ),
        child: Center(
          child: Icon(
            fallbackIcon,
            color: fallbackIconColor ?? AppColors.primary,
            size: (height != null && height! < 60) ? 20 : 32,
          ),
        ),
      );
    }

    if (imageUrl.isEmpty) {
      return fallbackWidget();
    }

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF3F3F6),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary.withValues(alpha: 0.5),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return fallbackWidget();
        },
      ),
    );
  }
}
