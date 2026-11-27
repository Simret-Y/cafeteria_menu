import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/screens/checkout_screen.dart';
import '../../features/manager/presentation/screens/manager_dashboard_screen.dart';
import '../../features/menu/presentation/screens/customer_home_screen.dart';
import '../../features/menu/presentation/screens/menu_details_screen.dart';
import '../../features/orders/presentation/screens/order_tracking_screen.dart';
import '../../features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
import '../../features/recommendations/presentation/screens/recommendations_screen.dart';
import '../../features/staff/presentation/screens/staff_dashboard_screen.dart';

/// Route paths for the app.
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String menuDetails = '/menu-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String staffDashboard = '/staff-dashboard';
  static const String qrScanner = '/qr-scanner';
  static const String managerDashboard = '/manager-dashboard';
  static const String recommendations = '/recommendations';
}

/// Creates the central go_router configuration for the app.
///
/// A factory is used (instead of a singleton) so tests and hot restarts get
/// a fresh router with clean navigation state.
GoRouter createAppRouter() => GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.menuDetails,
      name: 'menuDetails',
      builder: (context, state) => const MenuDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.cart,
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderTracking,
      name: 'orderTracking',
      builder: (context, state) => const OrderTrackingScreen(),
    ),
    GoRoute(
      path: AppRoutes.staffDashboard,
      name: 'staffDashboard',
      builder: (context, state) => const StaffDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.qrScanner,
      name: 'qrScanner',
      builder: (context, state) => const QrScannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.managerDashboard,
      name: 'managerDashboard',
      builder: (context, state) => const ManagerDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.recommendations,
      name: 'recommendations',
      builder: (context, state) => const RecommendationsScreen(),
    ),
  ],
  // Prototype guard: send logged-out users to /login. This is role-based
  // prototype navigation only — not real authentication.
  redirect: (context, state) {
    final auth = ProviderScope.containerOf(
      context,
    ).read(authProvider);
    final loggedIn = auth.isLoggedIn;
    final onAuthRoute =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;

    if (!loggedIn && !onAuthRoute) return AppRoutes.login;
    if (loggedIn && state.matchedLocation == AppRoutes.login) {
      return _homeForRole(auth.role);
    }
    return null;
  },
);

String _homeForRole(UserRole? role) {
  switch (role) {
    case UserRole.customer:
      return AppRoutes.home;
    case UserRole.staff:
      return AppRoutes.staffDashboard;
    case UserRole.manager:
      return AppRoutes.managerDashboard;
    case null:
      return AppRoutes.login;
  }
}

/// Provides the app router. Scoped to ProviderScope so each test/app
/// instance gets an isolated router.
final appRouterProvider = Provider<GoRouter>((ref) => createAppRouter());
