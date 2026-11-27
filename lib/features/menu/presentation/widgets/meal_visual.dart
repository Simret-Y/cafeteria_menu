import 'package:flutter/material.dart';

/// Shared icon and currency formatting helpers for menu and cart UI.
class MealVisual extends StatelessWidget {
  const MealVisual({
    super.key,
    required this.imageKey,
    this.size = 56,
    this.iconSize = 28,
  });

  final String imageKey;
  final double size;
  final double iconSize;

  static String formatPrice(double price) => '${price.toStringAsFixed(0)} ETB';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = switch (imageKey) {
      'sandwich' => Icons.lunch_dining,
      'pasta' => Icons.ramen_dining,
      'breakfast' => Icons.bakery_dining,
      'wrap' => Icons.fastfood,
      'coffee' => Icons.local_cafe,
      'juice' => Icons.local_drink,
      'snack' => Icons.tapas,
      _ => Icons.restaurant_menu,
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: iconSize, color: colorScheme.onPrimaryContainer),
    );
  }
}
