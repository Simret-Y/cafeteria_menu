import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/domain/entities/checkout_order.dart';
import '../../data/repositories/in_memory_order_repository.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';

// ── Repository provider ────────────────────────────────────────────────────

/// Singleton in-memory repository shared across the app.
///
/// Both the customer-facing Order Tracking screen and the staff dashboard
/// read from and write to the same instance, so status updates are reflected
/// immediately without a network round-trip.
final orderRepositoryProvider = Provider<OrderRepository>(
  (_) => InMemoryOrderRepository(),
);

// ── State notifier ─────────────────────────────────────────────────────────

/// Manages the application-level list of [Order]s with reactive state.
///
/// Orders are created from [CheckoutOrder]s produced by [CartNotifier].
/// Status transitions are applied via [updateStatus] (called from the
/// staff dashboard in later milestones).
class OrderNotifier extends Notifier<List<Order>> {
  OrderRepository get _repo => ref.read(orderRepositoryProvider);

  @override
  List<Order> build() => _repo.getAllOrders();

  /// Converts [checkoutOrder] into an [Order] and begins tracking it.
  ///
  /// Safe to call multiple times with the same [checkoutOrder] — duplicates
  /// are silently ignored by the repository.
  void trackFromCheckout(CheckoutOrder checkoutOrder) {
    final order = Order(
      id: checkoutOrder.orderId,
      customerName: checkoutOrder.customerName,
      items: List.unmodifiable(checkoutOrder.items),
      totalPrice: checkoutOrder.totalPrice,
      estimatedWaitMinutes: checkoutOrder.estimatedWaitMinutes,
      createdAt: checkoutOrder.createdAt,
    );
    _repo.addOrder(order);
    state = _repo.getAllOrders();
  }

  /// Transitions [orderId] to [status] and refreshes reactive state.
  ///
  /// Throws [ArgumentError] if [orderId] is not tracked.
  void updateStatus(String orderId, OrderStatus status) {
    _repo.updateStatus(orderId, status);
    state = _repo.getAllOrders();
  }
}

/// The primary order provider.
///
/// Exposed as [List<Order>] so the UI can iterate orders reactively.
final orderProvider = NotifierProvider<OrderNotifier, List<Order>>(
  OrderNotifier.new,
);

// ── Derived providers ──────────────────────────────────────────────────────

/// Returns the most recently placed order, or null if none exists.
///
/// Used by [OrderTrackingScreen] to display the current order.
final latestOrderProvider = Provider<Order?>((ref) {
  final orders = ref.watch(orderProvider);
  return orders.isEmpty ? null : orders.first;
});

/// Returns all active orders (placed or preparing) for the staff dashboard.
final activeOrdersProvider = Provider<List<Order>>((ref) {
  return ref
      .watch(orderProvider)
      .where((o) => o.status.isActive)
      .toList();
});
