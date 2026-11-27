// TEMPORARY INTEGRATION DEPENDENCY (Member 3 — Tinsae Aysheshim):
// Created so Member 2's Cart and Checkout screens can build and test
// independently. Reconcile or replace with Tinsae's InMemoryCartRepository
// once merged.
import '../../../menu/domain/entities/menu_item.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/checkout_order.dart';
import '../../domain/repositories/cart_repository.dart';

/// In-memory implementation of [CartRepository] for Milestone 1.
class InMemoryCartRepository implements CartRepository {
  final List<CartItem> _items = [];
  final List<CheckoutOrder> _orders = [];
  int _nextOrderNumber = 104;

  @override
  List<CartItem> getItems() => List.unmodifiable(_items);

  @override
  List<CartItem> addItem(MenuItem item, {int quantity = 1}) {
    if (!item.isAvailable || quantity <= 0) {
      return getItems();
    }

    final index = _items.indexWhere((entry) => entry.menuItem.id == item.id);
    if (index >= 0) {
      final current = _items[index];
      _items[index] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      _items.add(CartItem(menuItem: item, quantity: quantity));
    }
    return getItems();
  }

  @override
  List<CartItem> updateQuantity(String menuItemId, int quantity) {
    final index = _items.indexWhere((entry) => entry.menuItem.id == menuItemId);
    if (index < 0) return getItems();

    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
    return getItems();
  }

  @override
  List<CartItem> removeItem(String menuItemId) {
    _items.removeWhere((entry) => entry.menuItem.id == menuItemId);
    return getItems();
  }

  @override
  List<CartItem> clear() {
    _items.clear();
    return getItems();
  }

  @override
  CheckoutOrder submitOrder({
    required String customerName,
    required String phoneNumber,
    required String pickupNote,
    required PaymentMethod paymentMethod,
  }) {
    if (_items.isEmpty) {
      throw StateError('Cannot submit an order with an empty cart.');
    }

    final total = _items.fold<double>(0, (sum, entry) => sum + entry.lineTotal);
    final maxPrep = _items.fold<int>(
      5,
      (maxTime, entry) => entry.menuItem.prepTimeMinutes > maxTime
          ? entry.menuItem.prepTimeMinutes
          : maxTime,
    );

    final order = CheckoutOrder(
      orderId: 'ORD-${_nextOrderNumber++}',
      customerName: customerName.trim(),
      phoneNumber: phoneNumber.trim(),
      pickupNote: pickupNote.trim(),
      paymentMethod: paymentMethod,
      items: List.unmodifiable(_items),
      totalPrice: total,
      estimatedWaitMinutes: maxPrep + 5,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    _items.clear();
    return order;
  }

  @override
  List<CheckoutOrder> getPlacedOrders() => List.unmodifiable(_orders);
}
