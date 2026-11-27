import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../router/app_router.dart';

/// Role-aware bottom navigation bar.
///
/// Shows customer destinations (Home, Orders, Cart) for customers,
/// staff destinations (Dashboard, QR Scanner) for staff, and the
/// Manager Dashboard for managers. Renders nothing when logged out
/// or on auth screens.
class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authProvider).role;
    if (role == null) return const SizedBox.shrink();

    final currentPath = GoRouterState.of(context).uri.path;

    final destinations = switch (role) {
      UserRole.customer => const [
        _NavDestination(AppRoutes.home, 'Home', Icons.home),
        _NavDestination(
          AppRoutes.orderTracking,
          'Orders',
          Icons.receipt_long,
        ),
        _NavDestination(AppRoutes.cart, 'Cart', Icons.shopping_cart),
      ],
      UserRole.staff => const [
        _NavDestination(
          AppRoutes.staffDashboard,
          'Dashboard',
          Icons.dashboard,
        ),
        _NavDestination(AppRoutes.qrScanner, 'QR Scanner', Icons.qr_code_scanner),
      ],
      UserRole.manager => const [
        _NavDestination(
          AppRoutes.managerDashboard,
          'Dashboard',
          Icons.admin_panel_settings,
        ),
        // NavigationBar requires at least two destinations; Sign Out doubles
        // as the manager's session exit for the prototype.
        _NavDestination('', 'Sign Out', Icons.logout),
      ],
    };

    return NavigationBar(
      selectedIndex: destinations.indexWhere(
        (d) => currentPath == d.path,
      ).clamp(0, destinations.length - 1),
      onDestinationSelected: (index) {
        final destination = destinations[index];
        if (destination.path.isEmpty) {
          ref.read(authProvider.notifier).signOut();
          context.go(AppRoutes.login);
        } else {
          context.go(destination.path);
        }
      },
      destinations: [
        for (final d in destinations)
          NavigationDestination(icon: Icon(d.icon), label: d.label),
      ],
    );
  }
}

class _NavDestination {
  const _NavDestination(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;
}
