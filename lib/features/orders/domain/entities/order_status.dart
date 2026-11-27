/// Order lifecycle status for the cafeteria prototype.
///
/// Transitions in a linear flow: placed → preparing → ready → completed.
/// The [cancelled] status is a terminal state that may be set by staff.
enum OrderStatus {
  placed,
  preparing,
  ready,
  completed,
  cancelled;
}

/// Convenience extension on [OrderStatus].
extension OrderStatusLabel on OrderStatus {
  /// Human-readable label shown in the UI.
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Step index used by the status stepper (0-based).
  /// Returns -1 for [cancelled] since it is not a linear step.
  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.completed:
        return 3;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  /// Whether the order is still active (not completed or cancelled).
  bool get isActive =>
      this != OrderStatus.completed && this != OrderStatus.cancelled;
}
