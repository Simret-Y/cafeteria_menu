import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';

/// In-memory sample menu repository for Milestone 1 prototyping.
class InMemoryMenuRepository implements MenuRepository {
  static const List<MenuItem> _sampleItems = [
    MenuItem(
      id: 'meal-chicken-sandwich',
      name: 'Chicken Sandwich',
      description: 'Grilled spiced chicken breast on toasted ciabatta with crisp lettuce, tomato, and house garlic mayo.',
      price: 150,
      imageUrl: 'sandwich',
      category: 'Meals',
      isAvailable: true,
      prepTimeMinutes: 10,
    ),
    MenuItem(
      id: 'meal-pasta',
      name: 'Pasta',
      description: 'Al dente penne tossed in slow-simmered tomato basil sauce with roasted vegetables and parmesan.',
      price: 180,
      imageUrl: 'pasta',
      category: 'Meals',
      isAvailable: true,
      prepTimeMinutes: 12,
    ),
    MenuItem(
      id: 'meal-chechebsa',
      name: 'Special Chechebsa',
      description: 'Warm shredded flatbread sautéed in spiced berbere butter, topped with honey and a side of yogurt.',
      price: 140,
      imageUrl: 'breakfast',
      category: 'Breakfast',
      isAvailable: true,
      prepTimeMinutes: 8,
    ),
    MenuItem(
      id: 'meal-beef-wrap',
      name: 'Beef Shawarma Wrap',
      description: 'Tender marinated beef strips wrapped with pickled cucumbers, onions, and tahini drizzle.',
      price: 210,
      imageUrl: 'wrap',
      category: 'Meals',
      isAvailable: true,
      prepTimeMinutes: 14,
    ),
    MenuItem(
      id: 'drink-macchiato',
      name: 'Ethiopian Macchiato',
      description: 'Freshly pulled Ethiopian highland espresso layered with velvety steamed milk.',
      price: 60,
      imageUrl: 'coffee',
      category: 'Drinks',
      isAvailable: true,
      prepTimeMinutes: 4,
    ),
    MenuItem(
      id: 'drink-mango-juice',
      name: 'Fresh Mango Juice',
      description: 'Chilled seasonal mango puree blended to order with a hint of fresh lime.',
      price: 95,
      imageUrl: 'juice',
      category: 'Drinks',
      isAvailable: false,
      prepTimeMinutes: 5,
    ),
    MenuItem(
      id: 'snack-samosa',
      name: 'Lentil Sambusa (3 pcs)',
      description: 'Golden crisp pastry triangles filled with spiced red lentils, jalapeño, and fresh herbs.',
      price: 85,
      imageUrl: 'snack',
      category: 'Snacks',
      isAvailable: true,
      prepTimeMinutes: 6,
    ),
  ];

  @override
  List<MenuItem> getMenuItems() => List.unmodifiable(_sampleItems);

  @override
  MenuItem? getMenuItemById(String id) {
    for (final item in _sampleItems) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  List<String> getCategories() {
    final seen = <String>{};
    final categories = <String>['All'];
    for (final item in _sampleItems) {
      if (seen.add(item.category)) {
        categories.add(item.category);
      }
    }
    return List.unmodifiable(categories);
  }
}
