import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../menu/domain/entities/menu_item.dart';
import '../../../menu/presentation/providers/menu_providers.dart';
import '../../../menu/presentation/widgets/meal_visual.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  final Set<String> _preferences = {'Meals'};

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(menuItemsProvider);
    final recommendations = _rankRecommendations(items);
    final categories = ref
        .watch(menuCategoriesProvider)
        .where((category) => category != 'All')
        .toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Recommendations')),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Choose your preferences to rank available meals for you.',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your preferences',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in categories)
                FilterChip(
                  label: Text(category),
                  selected: _preferences.contains(category),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _preferences.add(category);
                      } else {
                        _preferences.remove(category);
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Picks for you',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (recommendations.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No available meals match the menu right now.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            for (var i = 0; i < recommendations.length; i++) ...[
              _RecommendationCard(
                item: recommendations[i],
                rank: i + 1,
                onAdd: () {
                  ref.read(cartProvider.notifier).addItem(recommendations[i]);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '${recommendations[i].name} added to cart',
                        ),
                        action: SnackBarAction(
                          label: 'Cart',
                          onPressed: () => context.go(AppRoutes.cart),
                        ),
                      ),
                    );
                },
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  List<MenuItem> _rankRecommendations(List<MenuItem> items) {
    final available = items.where((item) => item.isAvailable).toList();
    available.sort((a, b) {
      final scoreA = _recommendationScore(a);
      final scoreB = _recommendationScore(b);
      return scoreB.compareTo(scoreA);
    });
    return available.take(5).toList();
  }

  int _recommendationScore(MenuItem item) {
    var score = 0;
    if (_preferences.contains(item.category)) score += 5;
    if (item.prepTimeMinutes <= 8) score += 2;
    if (item.price <= 150) score += 1;
    if (item.category == 'Meals') score += 1;
    return score;
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.item,
    required this.rank,
    required this.onAdd,
  });

  final MenuItem item;
  final int rank;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            MealVisual(imageKey: item.imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        child: Text(
                          '$rank',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.category} · ${item.prepTimeMinutes} min · ${MealVisual.formatPrice(item.price)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: onAdd,
              style: FilledButton.styleFrom(minimumSize: const Size(64, 36)),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
