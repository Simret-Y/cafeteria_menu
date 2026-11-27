import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder staff dashboard screen.
///
/// Owned by Yared (staff/manager dashboards). Replace with the real
/// Staff Dashboard when ready — keep the file path and class name.
class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Staff Dashboard',
        icon: Icons.dashboard,
        owner: 'Yared',
      ),
    );
  }
}
