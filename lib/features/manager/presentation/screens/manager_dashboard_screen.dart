import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../menu/domain/entities/menu_item.dart';
import '../../../menu/presentation/providers/menu_providers.dart';
import '../../../menu/presentation/widgets/meal_visual.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(menuItemsProvider);
    final availableCount = items.where((item) => item.isAvailable).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Manager Dashboard')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      bottomNavigationBar: const AppBottomNav(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'Menu Items',
                  value: '${items.length}',
                  icon: Icons.restaurant_menu,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Available',
                  value: '$availableCount',
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No menu items', textAlign: TextAlign.center),
              ),
            )
          else
            for (final item in items) ...[
              _ManagerItemCard(
                item: item,
                onAvailabilityChanged: (value) => ref
                    .read(menuItemsProvider.notifier)
                    .setAvailability(item.id, value),
                onEdit: () => _showItemDialog(context, ref, item: item),
                onDelete: () {
                  ref.read(menuItemsProvider.notifier).removeItem(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.name} removed')),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Future<void> _showItemDialog(
    BuildContext context,
    WidgetRef ref, {
    MenuItem? item,
  }) async {
    final nameController = TextEditingController(text: item?.name);
    final descriptionController = TextEditingController(
      text: item?.description,
    );
    final priceController = TextEditingController(
      text: item?.price.toStringAsFixed(0),
    );
    final prepController = TextEditingController(
      text: '${item?.prepTimeMinutes ?? 10}',
    );
    var category = item?.category ?? 'Meals';
    var isAvailable = item?.isAvailable ?? true;

    final result = await showDialog<MenuItem>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price (ETB)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: prepController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Prep time (minutes)',
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const ['Meals', 'Breakfast', 'Drinks', 'Snacks']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => category = value);
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Available'),
                  value: isAvailable,
                  onChanged: (value) =>
                      setDialogState(() => isAvailable = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();
                final price = double.tryParse(priceController.text.trim());
                final prep = int.tryParse(prepController.text.trim());
                if (name.isEmpty ||
                    description.isEmpty ||
                    price == null ||
                    price <= 0 ||
                    prep == null ||
                    prep < 1) {
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  MenuItem(
                    id:
                        item?.id ??
                        'meal-${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    description: description,
                    price: price,
                    imageUrl: item?.imageUrl ?? 'meal',
                    category: category,
                    isAvailable: isAvailable,
                    prepTimeMinutes: prep,
                  ),
                );
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    prepController.dispose();
    if (result == null) return;

    if (item == null) {
      ref.read(menuItemsProvider.notifier).addItem(result);
    } else {
      ref.read(menuItemsProvider.notifier).updateItem(result);
    }
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ManagerItemCard extends StatelessWidget {
  const _ManagerItemCard({
    required this.item,
    required this.onAvailabilityChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final MenuItem item;
  final ValueChanged<bool> onAvailabilityChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MealVisual(imageKey: item.imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    MealVisual.formatPrice(item.price),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(item.isAvailable ? 'Available' : 'Unavailable'),
                      const Spacer(),
                      Switch(
                        value: item.isAvailable,
                        onChanged: onAvailabilityChanged,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: onEdit, child: const Text('Edit')),
                      TextButton(
                        onPressed: onDelete,
                        child: Text(
                          'Remove',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
