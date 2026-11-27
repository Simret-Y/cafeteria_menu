import '../entities/menu_item.dart';

/// Abstraction for retrieving cafeteria menu items.
abstract interface class MenuRepository {
  List<MenuItem> getMenuItems();

  MenuItem? getMenuItemById(String id);

  List<String> getCategories();
}
