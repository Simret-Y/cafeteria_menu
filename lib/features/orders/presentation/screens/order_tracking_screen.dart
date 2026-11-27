import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder order tracking screen.
///
/// Owned by Meresiet (customer-facing UI). Replace with the real
/// Order Tracking screen when ready — keep the file path and class name.
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Order Tracking',
        icon: Icons.track_changes,
        owner: 'Meresiet',
      ),
    );
  }
}
