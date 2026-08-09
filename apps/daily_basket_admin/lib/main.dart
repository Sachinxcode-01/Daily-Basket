import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/admin_theme.dart';
import 'core/providers/admin_auth_provider.dart';
import 'core/providers/admin_dashboard_provider.dart';

// Stitch Authentication & Session Screens
import 'features/authentication/presentation/screens/admin_splash_screen.dart';
import 'features/authentication/presentation/screens/admin_welcome_screen.dart';
import 'features/authentication/presentation/screens/admin_google_signin_screen.dart';
import 'features/authentication/presentation/screens/admin_secure_login_screen.dart';
import 'features/authentication/presentation/screens/admin_mfa_selection_screen.dart';
import 'features/authentication/presentation/screens/admin_otp_verification_screen.dart';
import 'features/authentication/presentation/screens/admin_biometric_login_screen.dart';
import 'features/authentication/presentation/screens/admin_device_verification_screen.dart';
import 'features/authentication/presentation/screens/admin_forgot_password_screen.dart';
import 'features/authentication/presentation/screens/admin_reset_password_screen.dart';
import 'features/authentication/presentation/screens/admin_auth_error_screen.dart';
import 'features/authentication/presentation/screens/admin_session_expired_screen.dart';
import 'features/authentication/presentation/screens/admin_force_password_change_screen.dart';
import 'features/authentication/presentation/screens/admin_terms_acceptance_screen.dart';
import 'features/authentication/presentation/screens/admin_access_denied_screen.dart';
import 'features/authentication/presentation/screens/admin_loading_screen.dart';
import 'features/authentication/presentation/screens/admin_account_locked_screen.dart';

// Operations Dashboard & Modules
import 'features/dashboard/presentation/screens/admin_overview_screen.dart';
import 'features/dashboard/presentation/screens/operational_insights_roi_screen.dart';
import 'features/dashboard/presentation/screens/admin_dashboard_shell.dart';
import 'features/orders/presentation/screens/admin_orders_screen.dart';
import 'features/inventory/presentation/screens/admin_inventory_screen.dart';
import 'features/products/presentation/screens/admin_products_screen.dart';
import 'features/products/presentation/screens/admin_add_product_basic_info_screen.dart';
import 'features/products/presentation/screens/admin_product_details_screen.dart';
import 'features/customers/presentation/screens/admin_customers_screen.dart';
import 'features/delivery/presentation/screens/admin_delivery_screen.dart';
import 'features/finance/presentation/screens/admin_finance_screen.dart';
import 'features/marketing/presentation/screens/admin_marketing_screen.dart';
import 'features/support/presentation/screens/admin_support_screen.dart';
import 'features/settings/presentation/screens/admin_settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
      ],
      child: const DailyBasketAdminApp(),
    ),
  );
}

class DailyBasketAdminApp extends StatelessWidget {
  const DailyBasketAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Basket Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.lightTheme,
      darkTheme: AdminTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const AdminSplashScreen(),
        '/admin/welcome': (context) => const AdminWelcomeScreen(),
        '/admin/google-signin': (context) => const AdminGoogleSigninScreen(),
        '/admin/secure-login': (context) => const AdminSecureLoginScreen(),
        '/admin/mfa-selection': (context) => const AdminMfaSelectionScreen(),
        '/admin/otp-verification': (context) => const AdminOtpVerificationScreen(),
        '/admin/biometric-login': (context) => const AdminBiometricLoginScreen(),
        '/admin/device-verification': (context) => const AdminDeviceVerificationScreen(),
        '/admin/forgot-password': (context) => const AdminForgotPasswordScreen(),
        '/admin/reset-password': (context) => const AdminResetPasswordScreen(),
        '/admin/auth-error': (context) => const AdminAuthErrorScreen(),
        '/admin/session-expired': (context) => const AdminSessionExpiredScreen(),
        '/admin/force-password-change': (context) => const AdminForcePasswordChangeScreen(),
        '/admin/terms-acceptance': (context) => const AdminTermsAcceptanceScreen(),
        '/admin/access-denied': (context) => const AdminAccessDeniedScreen(),
        '/admin/loading': (context) => const AdminLoadingScreen(),
        '/admin/account-locked': (context) => const AdminAccountLockedScreen(),

        // Operational Dashboard & Modules
        '/admin/dashboard': (context) => const AdminDashboardShell(),
        '/admin/overview': (context) => const AdminOverviewScreen(),
        '/admin/insights': (context) => const OperationalInsightsRoiScreen(),
        '/admin/orders': (context) => const AdminOrdersScreen(),
        '/admin/inventory': (context) => const AdminInventoryScreen(),
        '/admin/products': (context) => const AdminProductsScreen(),
        '/admin/products/new': (context) => const AdminAddProductBasicInfoScreen(),
        '/admin/products/details': (context) => const AdminProductDetailsScreen(),
        '/admin/customers': (context) => const AdminCustomersScreen(),
        '/admin/delivery': (context) => const AdminDeliveryScreen(),
        '/admin/finance': (context) => const AdminFinanceScreen(),
        '/admin/marketing': (context) => const AdminMarketingScreen(),
        '/admin/support': (context) => const AdminSupportScreen(),
        '/admin/settings': (context) => const AdminSettingsScreen(),
      },
    );
  }
}
