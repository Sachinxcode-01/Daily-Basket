import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

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

// Store & Customer Screens
import 'features/home/presentation/screens/home_screen.dart';
import 'features/search/presentation/screens/search_results_screen.dart';
import 'features/categories/presentation/screens/browse_categories_screen.dart';
import 'features/support/presentation/screens/help_center_screen.dart';
import 'features/orders/presentation/screens/delivery_tracking_screen.dart';
import 'features/orders/presentation/screens/rate_delivery_screen.dart';
import 'features/notifications/presentation/screens/notification_center_screen.dart';
import 'features/wallet/presentation/screens/wallet_transactions_screen.dart';
import 'features/membership/presentation/screens/daily_basket_plus_screen.dart';
import 'features/freshness/presentation/screens/fresh_produce_explorer_screen.dart';
import 'features/cart/presentation/screens/empty_basket_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DailyBasketApp());
}

class DailyBasketApp extends StatelessWidget {
  const DailyBasketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Basket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
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
        '/help': (context) => const HelpCenterScreen(),
        '/tracking': (context) => const DeliveryTrackingScreen(),
        '/rate-delivery': (context) => const RateDeliveryScreen(),
        '/notifications': (context) => const NotificationCenterScreen(),
        '/wallet': (context) => const WalletTransactionsScreen(),
        '/loyalty': (context) => const DailyBasketPlusScreen(),
        '/freshness': (context) => const FreshProduceExplorerScreen(),
        '/cart/empty': (context) => const EmptyBasketScreen(),
      },
    );
  }
}
