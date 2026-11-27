import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/placeholder_screen.dart';

/// Placeholder cart screen.
///
/// Owned by Meresiet (customer-facing UI). Replace with the real Cart
/// screen when ready — keep the file path and class name.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: AppBottomNav(),
      body: PlaceholderScreen(
        title: 'Cart',
        icon: Icons.shopping_cart,
        owner: 'Meresiet',
      ),
    );
  }
}
