import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../providers/menu_providers.dart';
import '../widgets/meal_visual.dart';

/// Displays full details, availability, preparation time, and quantity
/// selection for a single menu item.
class MenuDetailsScreen extends ConsumerWidget {
  const MenuDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItems = ref.watch(menuItemsProvider);
    final selectedId = ref.watch(selectedMenuItemIdProvider);
    final effectiveId =
        selectedId ?? (allItems.isNotEmpty ? allItems.first.id : null);
    final item = effectiveId == null
        ? null
        : ref.watch(menuItemByIdProvider(effectiveId));
    final theme = Theme.of(context);

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Menu Details')),
        bottomNavigationBar: const AppBottomNav(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 56,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text('Menu item not found', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Back to Menu'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final quantityMap = ref.watch(menuDetailQuantityProvider);
    final quantity = quantityMap[item.id] ?? 1;
    final subtotal = item.price * quantity;
    final availabilityColor = item.isAvailable
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Details'),
        actions: [
          IconButton(
            tooltip: 'Open Cart',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              context.go(AppRoutes.cart);
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: MealVisual(imageKey: item.imageUrl, size: 132, iconSize: 64),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(item.category)),
              Chip(
                avatar: Icon(
                  item.isAvailable ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: availabilityColor,
                ),
                label: Text(
                  item.isAvailable ? 'Available' : 'Unavailable',
                  style: TextStyle(color: availabilityColor),
                ),
              ),
              Chip(
                avatar: const Icon(Icons.schedule, size: 18),
                label: Text('~${item.prepTimeMinutes} min prep'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                MealVisual.formatPrice(item.price),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text('Quantity', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    key: const ValueKey('details_decrement_button'),
                    onPressed: item.isAvailable && quantity > 1
                        ? () => ref
                              .read(menuDetailQuantityProvider.notifier)
                              .decrement(item.id)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$quantity',
                    key: const ValueKey('details_quantity_text'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('details_increment_button'),
                    onPressed: item.isAvailable
                        ? () => ref
                              .read(menuDetailQuantityProvider.notifier)
                              .increment(item.id)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const ValueKey('details_add_to_cart_button'),
            onPressed: item.isAvailable
                ? () {
                    ref
                        .read(cartProvider.notifier)
                        .addItem(item, quantity: quantity);
                    ref
                        .read(menuDetailQuantityProvider.notifier)
                        .reset(item.id);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added $quantity x ${item.name} to cart',
                          ),
                          action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () => context.go(AppRoutes.cart),
                          ),
                        ),
                      );
                  }
                : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(
              item.isAvailable
                  ? 'Add to Cart • ${MealVisual.formatPrice(subtotal)}'
                  : 'Currently Unavailable',
            ),
          ),
        ],
      ),
    );
  }
}
