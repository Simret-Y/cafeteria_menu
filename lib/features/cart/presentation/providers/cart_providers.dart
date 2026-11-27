import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../menu/domain/entities/menu_item.dart';
import '../../data/repositories/in_memory_cart_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/checkout_order.dart';
import '../../domain/repositories/cart_repository.dart';

part 'cart_providers.freezed.dart';

/// Immutable state for the customer cart and checkout flow.
@freezed
abstract class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    @Default([]) List<CartItem> items,
    @Default(PaymentMethod.counter) PaymentMethod selectedPaymentMethod,
    CheckoutOrder? lastPlacedOrder,
    @Default([]) List<CheckoutOrder> placedOrders,
  }) = _CartState;

  double get totalPrice =>
      items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  int get totalItemCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get estimatedWaitMinutes {
    if (items.isEmpty) return 0;
    final maxPrep = items.fold<int>(
      5,
      (maxTime, item) => item.menuItem.prepTimeMinutes > maxTime
          ? item.menuItem.prepTimeMinutes
          : maxTime,
    );
    return maxPrep + 5;
  }
}

/// Provides the active [CartRepository] implementation.
final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => InMemoryCartRepository(),
);

/// Manages cart items, quantities, payment selection, and checkout submission.
class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    final repo = ref.watch(cartRepositoryProvider);
    return CartState(
      items: repo.getItems(),
      placedOrders: repo.getPlacedOrders(),
    );
  }

  void addItem(MenuItem item, {int quantity = 1}) {
    final updated = ref
        .read(cartRepositoryProvider)
        .addItem(item, quantity: quantity);
    state = state.copyWith(items: updated);
  }

  void incrementQuantity(String menuItemId) {
    final current = state.items.firstWhere(
      (entry) => entry.menuItem.id == menuItemId,
    );
    final updated = ref
        .read(cartRepositoryProvider)
        .updateQuantity(menuItemId, current.quantity + 1);
    state = state.copyWith(items: updated);
  }

  void decrementQuantity(String menuItemId) {
    final current = state.items.firstWhere(
      (entry) => entry.menuItem.id == menuItemId,
    );
    final updated = ref
        .read(cartRepositoryProvider)
        .updateQuantity(menuItemId, current.quantity - 1);
    state = state.copyWith(items: updated);
  }

  void removeItem(String menuItemId) {
    final updated = ref.read(cartRepositoryProvider).removeItem(menuItemId);
    state = state.copyWith(items: updated);
  }

  void clearCart() {
    final updated = ref.read(cartRepositoryProvider).clear();
    state = state.copyWith(items: updated);
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  CheckoutOrder submitOrder({
    required String customerName,
    required String phoneNumber,
    String pickupNote = '',
  }) {
    final repo = ref.read(cartRepositoryProvider);
    final order = repo.submitOrder(
      customerName: customerName,
      phoneNumber: phoneNumber,
      pickupNote: pickupNote,
      paymentMethod: state.selectedPaymentMethod,
    );
    state = state.copyWith(
      items: repo.getItems(),
      lastPlacedOrder: order,
      placedOrders: repo.getPlacedOrders(),
    );
    return order;
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

/// Derived cart total price in ETB.
final cartTotalProvider = Provider<double>(
  (ref) => ref.watch(cartProvider).totalPrice,
);

/// Derived total count of units currently in the cart.
final cartItemCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).totalItemCount,
);
