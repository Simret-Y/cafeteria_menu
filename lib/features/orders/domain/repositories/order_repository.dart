import '../entities/order.dart';
import '../entities/order_status.dart';

/// Contract for the order store used by [OrderNotifier].
///
/// The in-memory implementation seeds from checkout submissions;
/// a future Firebase implementation would persist to Firestore.
abstract interface class OrderRepository {
  /// Returns all orders, most-recent first.
  List<Order> getAllOrders();

  /// Returns the order matching [id], or null if not found.
  Order? getOrderById(String id);

  /// Persists [order] and returns it.
  Order addOrder(Order order);

  /// Updates the [status] of the order identified by [id].
  ///
  /// Throws [ArgumentError] if no order with [id] exists.
  Order updateStatus(String id, OrderStatus status);
}
