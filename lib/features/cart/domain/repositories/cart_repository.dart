import '../../../menu/domain/entities/menu_item.dart';
import '../entities/cart_item.dart';
import '../entities/checkout_order.dart';

/// Abstraction for managing customer cart items and submitting prototype orders.
abstract interface class CartRepository {
  List<CartItem> getItems();

  List<CartItem> addItem(MenuItem item, {int quantity = 1});

  List<CartItem> updateQuantity(String menuItemId, int quantity);

  List<CartItem> removeItem(String menuItemId);

  List<CartItem> clear();

  CheckoutOrder submitOrder({
    required String customerName,
    required String phoneNumber,
    required String pickupNote,
    required PaymentMethod paymentMethod,
  });

  List<CheckoutOrder> getPlacedOrders();
}
