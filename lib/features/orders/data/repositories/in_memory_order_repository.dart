import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';

/// In-memory implementation of [OrderRepository] for Milestone 1.
///
/// Orders are held in a mutable list that starts empty and is populated
/// via [addOrder] as customers complete checkout. Status updates via
/// [updateStatus] propagate immediately to any subsequent [getAllOrders] call.
class InMemoryOrderRepository implements OrderRepository {
  final List<Order> _orders = [];

  @override
  List<Order> getAllOrders() => List.unmodifiable(_orders);

  @override
  Order? getOrderById(String id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  @override
  Order addOrder(Order order) {
    // Avoid duplicate tracking if the same orderId is added twice.
    final exists = _orders.any((o) => o.id == order.id);
    if (!exists) {
      _orders.insert(0, order);
    }
    return _orders.firstWhere((o) => o.id == order.id);
  }

  @override
  Order updateStatus(String id, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index < 0) {
      throw ArgumentError('No order with id "$id" found.');
    }
    _orders[index] = _orders[index].copyWith(status: status);
    return _orders[index];
  }
}
