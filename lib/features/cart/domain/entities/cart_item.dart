// TEMPORARY INTEGRATION DEPENDENCY (Member 3 — Tinsae Aysheshim):
// Created so Member 2's Cart and Checkout screens can build and test
// independently. Reconcile or replace with Tinsae's CartItem model once merged.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../menu/domain/entities/menu_item.dart';

part 'cart_item.freezed.dart';

/// Immutable item inside the customer's shopping cart.
@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({required MenuItem menuItem, required int quantity}) =
      _CartItem;

  double get lineTotal => menuItem.price * quantity;
}
