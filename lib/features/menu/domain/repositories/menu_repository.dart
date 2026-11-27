// TEMPORARY INTEGRATION DEPENDENCY (Member 3 — Tinsae Aysheshim):
// Created so Member 2's customer screens can build and test independently.
// Reconcile or replace with Tinsae's MenuRepository interface once merged.
import '../entities/menu_item.dart';

/// Abstraction for retrieving cafeteria menu items.
abstract interface class MenuRepository {
  List<MenuItem> getMenuItems();

  MenuItem? getMenuItemById(String id);

  List<String> getCategories();
}
