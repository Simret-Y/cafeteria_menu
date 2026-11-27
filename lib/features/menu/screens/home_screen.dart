import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Placeholder home screen.
///
/// Owned by Meresiet (customer-facing UI). Replace with the real Home
/// screen when ready — keep the file path and class name.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Home',
        icon: Icons.home,
        owner: 'Meresiet',
      ),
    );
  }
}
