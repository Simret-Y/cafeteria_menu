import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OrderPreparationStatus {
  received('Received'),
  preparing('Preparing'),
  ready('Ready for Pickup'),
  collected('Collected');

  const OrderPreparationStatus(this.label);
  final String label;
}

class StaffOrderStatusNotifier
    extends Notifier<Map<String, OrderPreparationStatus>> {
  @override
  Map<String, OrderPreparationStatus> build() => const {};

  OrderPreparationStatus statusFor(String orderId) =>
      state[orderId] ?? OrderPreparationStatus.received;

  void updateStatus(String orderId, OrderPreparationStatus status) {
    state = {...state, orderId: status};
  }
}

final staffOrderStatusProvider =
    NotifierProvider<
      StaffOrderStatusNotifier,
      Map<String, OrderPreparationStatus>
    >(StaffOrderStatusNotifier.new);
