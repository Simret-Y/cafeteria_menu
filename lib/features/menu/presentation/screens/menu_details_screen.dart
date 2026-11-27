import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder menu details screen.
///
/// Owned by Meresiet (customer-facing UI). Replace with the real
/// Menu Details screen when ready — keep the file path and class name.
class MenuDetailsScreen extends StatelessWidget {
  const MenuDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Menu Details',
        icon: Icons.restaurant_menu,
        owner: 'Meresiet',
      ),
    );
  }
}
