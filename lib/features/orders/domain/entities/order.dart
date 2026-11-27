import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../cart/domain/entities/cart_item.dart';
import 'order_status.dart';

part 'order.freezed.dart';

/// Immutable representation of a placed customer order with live status.
///
/// Created by [OrderNotifier] when a customer submits their cart.
/// The [status] field is the only mutable concern — all other fields
/// are snapshotted at the moment the order is placed.
@freezed
abstract class Order with _$Order {
  const factory Order({
    /// Unique order identifier (e.g. 'ORD-104').
    required String id,

    /// Customer display name captured at checkout.
    required String customerName,

    /// Snapshot of cart items at the time of ordering.
    required List<CartItem> items,

    /// Pre-calculated total in ETB.
    required double totalPrice,

    /// Estimated minutes until pickup, computed from item prep times.
    required int estimatedWaitMinutes,

    /// Timestamp when the order was placed.
    required DateTime createdAt,

    /// Current lifecycle status, starts at [OrderStatus.placed].
    @Default(OrderStatus.placed) OrderStatus status,
  }) = _Order;
}
