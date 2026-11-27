// TEMPORARY INTEGRATION DEPENDENCY (Member 3 — Tinsae Aysheshim):
// Created so Member 2's Checkout screen can build and test independently.
// Reconcile or replace with Tinsae's Order Freezed model once merged.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'checkout_order.freezed.dart';

/// Supported prototype payment options at checkout.
enum PaymentMethod {
  counter('Pay at Counter'),
  telebirr('Telebirr (Prototype)'),
  cbeBirr('CBE Birr (Prototype)');

  const PaymentMethod(this.label);

  final String label;
}

/// Immutable prototype order confirmation created from checkout.
@freezed
abstract class CheckoutOrder with _$CheckoutOrder {
  const factory CheckoutOrder({
    required String orderId,
    required String customerName,
    required String phoneNumber,
    required String pickupNote,
    required PaymentMethod paymentMethod,
    required List<CartItem> items,
    required double totalPrice,
    required int estimatedWaitMinutes,
    required DateTime createdAt,
  }) = _CheckoutOrder;
}
