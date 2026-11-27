import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/in_memory_menu_repository.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';

/// Provides the active [MenuRepository] implementation.
final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => InMemoryMenuRepository(),
);

/// All cafeteria menu items from the repository.
final menuItemsProvider = Provider<List<MenuItem>>(
  (ref) => ref.watch(menuRepositoryProvider).getMenuItems(),
);

/// Available category filter labels, starting with 'All'.
final menuCategoriesProvider = Provider<List<String>>(
  (ref) => ref.watch(menuRepositoryProvider).getCategories(),
);

/// Active category filter selected on the Customer Home screen.
class SelectedMenuCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void select(String category) => state = category;
}

final selectedMenuCategoryProvider =
    NotifierProvider<SelectedMenuCategoryNotifier, String>(
      SelectedMenuCategoryNotifier.new,
    );

/// Active search query entered on the Customer Home screen.
class MenuSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;

  void clear() => state = '';
}

final menuSearchQueryProvider =
    NotifierProvider<MenuSearchQueryNotifier, String>(
      MenuSearchQueryNotifier.new,
    );

/// Menu items filtered by the active category and search query.
final filteredMenuItemsProvider = Provider<List<MenuItem>>((ref) {
  final items = ref.watch(menuItemsProvider);
  final selectedCategory = ref.watch(selectedMenuCategoryProvider);
  final query = ref.watch(menuSearchQueryProvider).trim().toLowerCase();

  return items.where((item) {
    final matchesCategory =
        selectedCategory == 'All' || item.category == selectedCategory;
    if (!matchesCategory) return false;
    if (query.isEmpty) return true;
    return item.name.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query) ||
        item.category.toLowerCase().contains(query);
  }).toList();
});

/// Looks up a single [MenuItem] by its ID.
final menuItemByIdProvider = Provider.family<MenuItem?, String>((ref, itemId) {
  return ref.watch(menuRepositoryProvider).getMenuItemById(itemId);
});

/// Tracks selected quantity per menu item on the Menu Details screen.
class MenuDetailQuantityNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => const {};

  int quantityFor(String itemId) => state[itemId] ?? 1;

  void increment(String itemId) {
    final current = quantityFor(itemId);
    state = {...state, itemId: current + 1};
  }

  void decrement(String itemId) {
    final current = quantityFor(itemId);
    if (current <= 1) return;
    state = {...state, itemId: current - 1};
  }

  void reset(String itemId) {
    if (!state.containsKey(itemId)) return;
    final updated = {...state}..remove(itemId);
    state = updated;
  }
}

final menuDetailQuantityProvider =
    NotifierProvider<MenuDetailQuantityNotifier, Map<String, int>>(
      MenuDetailQuantityNotifier.new,
    );
