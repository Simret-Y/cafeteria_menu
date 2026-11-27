import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_form_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../domain/entities/menu_item.dart';
import '../providers/menu_providers.dart';
import '../widgets/meal_visual.dart';

/// Customer home screen displaying daily menu highlights, category filtering,
/// search, and quick cart additions.
class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = ref.watch(customerDisplayNameProvider);
    final categories = ref.watch(menuCategoriesProvider);
    final selectedCategory = ref.watch(selectedMenuCategoryProvider);
    final searchQuery = ref.watch(menuSearchQueryProvider);
    final items = ref.watch(filteredMenuItemsProvider);
    final cartCount = ref.watch(cartItemCountProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'AI Recommendations',
            onPressed: () => context.push(AppRoutes.recommendations),
            icon: const Icon(Icons.auto_awesome),
          ),
          IconButton(
            tooltip: 'Open Cart',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              context.go(AppRoutes.cart);
            },
            icon: Badge.count(
              count: cartCount,
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          IconButton(
            tooltip: 'Sign Out',
            onPressed: () {
              ref.read(customerDisplayNameProvider.notifier).clear();
              ref.read(authProvider.notifier).signOut();
              context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${displayName ?? 'Customer'}!',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Browse today\'s menu and pre-order to skip the queue.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    onPressed: () => context.push(AppRoutes.recommendations),
                    child: const Text('AI Picks'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('menu_search_field'),
            decoration: InputDecoration(
              hintText: 'Search meals, drinks, or snacks...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () =>
                          ref.read(menuSearchQueryProvider.notifier).clear(),
                      icon: const Icon(Icons.clear),
                    )
                  : null,
            ),
            onChanged: (value) =>
                ref.read(menuSearchQueryProvider.notifier).update(value),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: category == selectedCategory,
                  onSelected: (_) => ref
                      .read(selectedMenuCategoryProvider.notifier)
                      .select(category),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "TODAY'S MENU",
            style: theme.textTheme.titleSmall?.copyWith(
              letterSpacing: 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  const Text('No menu items match your filter.'),
                ],
              ),
            )
          else
            for (final item in items) ...[
              _MenuItemCard(item: item),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _MenuItemCard extends ConsumerWidget {
  const _MenuItemCard({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusColor = item.isAvailable
        ? theme.colorScheme.primary
        : theme.colorScheme.error;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(selectedMenuItemIdProvider.notifier).select(item.id);
          context.push(AppRoutes.menuDetails);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MealVisual(imageKey: item.imageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          MealVisual.formatPrice(item.price),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.isAvailable ? 'Available' : 'Unavailable',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(selectedMenuItemIdProvider.notifier)
                                .select(item.id);
                            context.push(AppRoutes.menuDetails);
                          },
                          child: const Text('View Details'),
                        ),
                        const SizedBox(width: 4),
                        FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: item.isAvailable
                              ? () {
                                  ref.read(cartProvider.notifier).addItem(item);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${item.name} added to cart',
                                        ),
                                        action: SnackBarAction(
                                          label: 'Cart',
                                          onPressed: () =>
                                              context.go(AppRoutes.cart),
                                        ),
                                      ),
                                    );
                                }
                              : null,
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
