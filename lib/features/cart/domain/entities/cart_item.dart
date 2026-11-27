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
