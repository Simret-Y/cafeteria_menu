import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Placeholder manager dashboard screen.
///
/// Owned by Yared (staff/manager dashboards). Replace with the real
/// Manager Dashboard when ready — keep the file path and class name.
class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Manager Dashboard',
        icon: Icons.admin_panel_settings,
        owner: 'Yared',
      ),
    );
  }
}
