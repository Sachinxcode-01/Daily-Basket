import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/user_provider.dart';
import 'core/providers/app_theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/notification_provider.dart';
import 'features/referral/providers/coupon_provider.dart';

// Authentication Screens
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/verify_email_screen.dart';
import 'features/auth/presentation/screens/email_verified_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';
import 'features/auth/presentation/screens/mfa_selection_screen.dart';
import 'features/auth/presentation/screens/mfa_verification_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/enable_biometrics_screen.dart';
import 'features/auth/presentation/screens/account_locked_screen.dart';

// Store, Customer & Catalog Screens
import 'features/home/presentation/screens/home_screen.dart';
import 'features/search/presentation/screens/search_results_screen.dart';
import 'features/categories/presentation/screens/browse_categories_screen.dart';
import 'features/catalog/presentation/screens/product_details_screen.dart';

// Cart & Checkout Screens
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/cart/presentation/screens/checkout_screen.dart';
import 'features/cart/presentation/screens/payment_screen.dart';
import 'features/cart/presentation/screens/empty_basket_screen.dart';

// Orders & Tracking Screens
import 'features/orders/presentation/screens/order_history_screen.dart';
import 'features/orders/presentation/screens/order_details_screen.dart';
import 'features/orders/presentation/screens/order_success_screen.dart';
import 'features/orders/presentation/screens/delivery_tracking_screen.dart';
import 'features/orders/presentation/screens/rate_delivery_screen.dart';

// Profile & Settings Screens
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/personal_info_screen.dart';
import 'features/profile/presentation/screens/saved_addresses_screen.dart';
import 'features/profile/presentation/screens/add_address_screen.dart';
import 'features/profile/presentation/screens/payment_methods_screen.dart';
import 'features/settings/presentation/screens/security_settings_screen.dart';
import 'features/settings/presentation/screens/app_theme_screen.dart';
import 'features/settings/presentation/screens/delete_account_screen.dart';

// Support & Notifications Screens
import 'features/support/presentation/screens/help_center_screen.dart';
import 'features/support/presentation/screens/privacy_policy_screen.dart';
import 'features/support/presentation/screens/terms_of_service_screen.dart';
import 'features/notifications/presentation/screens/notification_center_screen.dart';
import 'features/notifications/presentation/screens/notification_preferences_screen.dart';
import 'features/wallet/presentation/screens/wallet_transactions_screen.dart';
import 'features/referral/presentation/screens/offers_screen.dart';
import 'features/referral/presentation/screens/referral_screen.dart';
import 'features/referral/presentation/screens/referral_history_screen.dart';
import 'features/membership/presentation/screens/daily_basket_plus_screen.dart';
import 'features/profile/presentation/screens/my_impact_dashboard_screen.dart';
import 'features/support/presentation/screens/live_support_chat_screen.dart';
import 'features/catalog/presentation/screens/quick_buy_essentials_screen.dart';
import 'features/notifications/presentation/screens/back_to_stock_alerts_screen.dart';
import 'features/freshness/presentation/screens/fresh_produce_explorer_screen.dart';
import 'features/support/presentation/screens/about_app_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const DailyBasketApp(),
    ),
  );
}

class DailyBasketApp extends StatelessWidget {
  const DailyBasketApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appThemeProvider = context.watch<AppThemeProvider>();

    return MaterialApp(
      title: 'Daily Basket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeProvider.themeMode,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/product-details') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: args?['productId'] ?? 'prod_avocado',
              productName: args?['productName'] ?? 'Organic Hass Avocados',
              price: args?['price'] ?? '₹120',
              mrp: args?['mrp'] ?? '₹150',
              unitDetails: args?['unitDetails'] ?? '2 units (Approx. 400g)',
              imageUrl: args?['imageUrl'] ?? 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=800&q=80',
            ),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/verify-email': (context) => const VerifyEmailScreen(),
        '/success': (context) => const EmailVerifiedScreen(),
        '/email-verified': (context) => const EmailVerifiedScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/mfa-selection': (context) => const MfaSelectionScreen(),
        '/mfa-verify': (context) => const MfaVerificationScreen(),
        '/otp': (context) => const OtpScreen(),
        '/enable-biometrics': (context) => const EnableBiometricsScreen(),
        '/account-locked': (context) => const AccountLockedScreen(),
        '/customer/home': (context) => const CustomerHomeScreen(),
        '/search': (context) => const SearchResultsScreen(),
        '/categories': (context) => const BrowseCategoriesScreen(),
        '/cart': (context) => const CartScreen(),
        '/cart/empty': (context) => const EmptyBasketScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/orders': (context) => const OrderHistoryScreen(),
        '/order-details': (context) => const OrderDetailsScreen(),
        '/order-success': (context) => const OrderSuccessScreen(),
        '/tracking': (context) => const DeliveryTrackingScreen(),
        '/rate-delivery': (context) => const RateDeliveryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/personal-info': (context) => const PersonalInfoScreen(),
        '/security': (context) => const SecuritySettingsScreen(),
        '/saved-addresses': (context) => const SavedAddressesScreen(),
        '/add-address': (context) => const AddAddressScreen(),
        '/payment-methods': (context) => const PaymentMethodsScreen(),
        '/help': (context) => const HelpCenterScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
        '/terms-of-service': (context) => const TermsOfServiceScreen(),
        '/app-theme': (context) => const AppThemeScreen(),
        '/notifications': (context) => const NotificationCenterScreen(),
        '/notification-preferences': (context) => const NotificationPreferencesScreen(),
        '/wallet': (context) => const WalletTransactionsScreen(),
        '/loyalty': (context) => const DailyBasketPlusScreen(),
        '/freshness': (context) => const FreshProduceExplorerScreen(),
        '/about': (context) => const AboutAppScreen(),
        '/delete-account': (context) => const DeleteAccountScreen(),
        '/coupons': (context) => const OffersScreen(),
        '/referral': (context) => const ReferralScreen(),
        '/referral-history': (context) => const ReferralHistoryScreen(),
        '/my-impact': (context) => const MyImpactDashboardScreen(),
        '/live-chat': (context) => const LiveSupportChatScreen(),
        '/quick-buy': (context) => const QuickBuyEssentialsScreen(),
        '/back-to-stock': (context) => const BackToStockAlertsScreen(),
      },
    );
  }
}
