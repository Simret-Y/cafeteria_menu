import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder checkout screen.
///
/// Owned by Meresiet (customer-facing UI). Replace with the real Checkout
/// screen when ready — keep the file path and class name.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlaceholderScreen(
        title: 'Checkout',
        icon: Icons.payment,
        owner: 'Meresiet',
      ),
    );
  }
}
