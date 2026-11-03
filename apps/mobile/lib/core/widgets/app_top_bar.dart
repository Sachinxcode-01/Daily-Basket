import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../navigation/app_navigation_drawer.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';

/// Reusable Google Stitch compliant Top App Bar for Daily Basket
/// Provides:
/// - Drawer Navigation Bar trigger (hamburger menu)
/// - Back navigation fallback
/// - Branded title typography
/// - User profile avatar button (clickable, navigates to `/profile`)
/// - Cart quick-access button with live item count badge
/// - Dynamic adaptation for Dark & Light theme modes
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showDrawer;
  final bool showBack;
  final bool showProfile;
  final bool showCart;
  final bool showDrawerAction;
  final VoidCallback? onBack;
  final List<Widget>? extraActions;

  const AppTopBar({
    super.key,
    this.title = 'Daily Basket',
    this.showDrawer = true,
    this.showBack = false,
    this.showProfile = true,
    this.showCart = false,
    this.showDrawerAction = false,
    this.onBack,
    this.extraActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topBarBg = isDark
        ? const Color(0xFF191C1E).withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.95);
    final iconColor = isDark ? const Color(0xFFF0F0F3) : const Color(0xFF1A1C1E);
    final brandColor = isDark ? const Color(0xFF70DD7A) : const Color(0xFF006B23);
    final avatarBorderColor = isDark ? const Color(0xFF70DD7A) : const Color(0xFFC0E8C7);

    UserProvider? userProvider;
    CartProvider? cartProvider;

    try {
      userProvider = context.watch<UserProvider>();
    } catch (_) {}
    try {
      cartProvider = context.watch<CartProvider>();
    } catch (_) {}

    final profileImageUrl = userProvider?.profileImageUrl ??
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80';
    final cartCount = cartProvider?.itemCount ?? 0;

    Widget? leadingWidget;
    if (showBack || (!showDrawer && Navigator.of(context).canPop())) {
      leadingWidget = IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: iconColor),
        tooltip: 'Back',
        onPressed: onBack ??
            () {
              HapticFeedback.lightImpact();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/customer/home',
                  (route) => false,
                );
              }
            },
      );
    } else if (showDrawer) {
      leadingWidget = Builder(
        builder: (scaffoldContext) => IconButton(
          icon: Icon(Icons.menu_rounded, color: iconColor, size: 26),
          tooltip: 'Navigation Hub',
          onPressed: () {
            HapticFeedback.lightImpact();
            AppNavigationDrawer.openOrShow(scaffoldContext);
          },
        ),
      );
    }

    final actionsList = <Widget>[];

    if (extraActions != null) {
      actionsList.addAll(extraActions!);
    }

    final shouldShowDrawerAction = showDrawerAction || (showBack && showDrawer);
    if (shouldShowDrawerAction) {
      actionsList.add(
        Builder(
          builder: (scaffoldContext) => IconButton(
            icon: Icon(Icons.menu_rounded, color: iconColor),
            tooltip: 'Navigation Hub',
            onPressed: () {
              HapticFeedback.lightImpact();
              AppNavigationDrawer.openOrShow(scaffoldContext);
            },
          ),
        ),
      );
    }

    if (showCart) {
      actionsList.add(
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_basket_outlined,
                color: brandColor,
                size: 24,
              ),
              tooltip: 'Cart',
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pushNamed('/cart');
              },
            ),
            if (cartCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: brandColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (showProfile) {
      actionsList.add(
        Padding(
          padding: const EdgeInsets.only(right: 14, left: 4),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pushNamed('/profile');
              },
              customBorder: const CircleBorder(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: avatarBorderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: brandColor.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Image.network(
                    profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      color: brandColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: topBarBg,
      elevation: 0.5,
      centerTitle: true,
      leading: leadingWidget,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: brandColor,
        ),
      ),
      actions: actionsList,
    );
  }
}
