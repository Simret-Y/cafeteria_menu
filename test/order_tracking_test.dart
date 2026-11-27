// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafeteria_app/features/cart/domain/entities/cart_item.dart';
import 'package:cafeteria_app/features/cart/domain/entities/checkout_order.dart';
import 'package:cafeteria_app/features/menu/domain/entities/menu_item.dart';
import 'package:cafeteria_app/features/orders/data/repositories/in_memory_order_repository.dart';
import 'package:cafeteria_app/features/orders/domain/entities/order.dart';
import 'package:cafeteria_app/features/orders/domain/entities/order_status.dart';
import 'package:cafeteria_app/features/orders/presentation/providers/order_providers.dart';

// ── Helpers ────────────────────────────────────────────────────────────────

final _sampleItem = MenuItem(
  id: 'test-001',
  name: 'Test Sandwich',
  description: 'A test sandwich for unit tests.',
  price: 150,
  imageUrl: 'sandwich',
  category: 'Meals',
  isAvailable: true,
);

Order _makeOrder({
  String id = 'ORD-001',
  OrderStatus status = OrderStatus.placed,
}) =>
    Order(
      id: id,
      customerName: 'Test User',
      items: [CartItem(menuItem: _sampleItem, quantity: 2)],
      totalPrice: 300,
      estimatedWaitMinutes: 15,
      createdAt: DateTime(2026, 11, 27, 10),
      status: status,
    );

CheckoutOrder _makeCheckoutOrder({String orderId = 'ORD-200'}) => CheckoutOrder(
      orderId: orderId,
      customerName: 'Checkout User',
      phoneNumber: '0911000000',
      pickupNote: '',
      paymentMethod: PaymentMethod.counter,
      items: [CartItem(menuItem: _sampleItem, quantity: 1)],
      totalPrice: 150,
      estimatedWaitMinutes: 10,
      createdAt: DateTime(2026, 11, 27, 11),
    );

// ── InMemoryOrderRepository tests ──────────────────────────────────────────

void main() {
  group('InMemoryOrderRepository', () {
    late InMemoryOrderRepository repo;

    setUp(() => repo = InMemoryOrderRepository());

    test('getAllOrders returns empty list initially', () {
      expect(repo.getAllOrders(), isEmpty);
    });

    test('addOrder persists an order and returns it', () {
      final order = _makeOrder();
      final returned = repo.addOrder(order);

      expect(returned.id, 'ORD-001');
      expect(repo.getAllOrders(), hasLength(1));
    });

    test('addOrder ignores duplicate orderId', () {
      final order = _makeOrder();
      repo.addOrder(order);
      repo.addOrder(order); // second call with same id

      expect(repo.getAllOrders(), hasLength(1));
    });

    test('getOrderById returns correct order', () {
      repo.addOrder(_makeOrder(id: 'ORD-100'));
      repo.addOrder(_makeOrder(id: 'ORD-101'));

      final found = repo.getOrderById('ORD-100');
      expect(found, isNotNull);
      expect(found!.id, 'ORD-100');
    });

    test('getOrderById returns null for unknown id', () {
      expect(repo.getOrderById('UNKNOWN'), isNull);
    });

    test('updateStatus changes status and returns updated order', () {
      repo.addOrder(_makeOrder());

      final updated = repo.updateStatus('ORD-001', OrderStatus.preparing);
      expect(updated.status, OrderStatus.preparing);
      expect(repo.getOrderById('ORD-001')!.status, OrderStatus.preparing);
    });

    test('updateStatus throws ArgumentError for unknown id', () {
      expect(
        () => repo.updateStatus('UNKNOWN', OrderStatus.ready),
        throwsArgumentError,
      );
    });
  });

  // ── OrderStatus extension tests ──────────────────────────────────────────

  group('OrderStatus extension', () {
    test('label returns human-readable string for each status', () {
      expect(OrderStatus.placed.label, 'Order Placed');
      expect(OrderStatus.preparing.label, 'Preparing');
      expect(OrderStatus.ready.label, 'Ready for Pickup');
      expect(OrderStatus.completed.label, 'Completed');
      expect(OrderStatus.cancelled.label, 'Cancelled');
    });

    test('stepIndex is ascending for active statuses', () {
      expect(OrderStatus.placed.stepIndex, lessThan(OrderStatus.preparing.stepIndex));
      expect(OrderStatus.preparing.stepIndex, lessThan(OrderStatus.ready.stepIndex));
      expect(OrderStatus.ready.stepIndex, lessThan(OrderStatus.completed.stepIndex));
    });

    test('stepIndex is -1 for cancelled', () {
      expect(OrderStatus.cancelled.stepIndex, -1);
    });

    test('isActive is true for placed, preparing, ready', () {
      expect(OrderStatus.placed.isActive, isTrue);
      expect(OrderStatus.preparing.isActive, isTrue);
      expect(OrderStatus.ready.isActive, isTrue);
    });

    test('isActive is false for completed and cancelled', () {
      expect(OrderStatus.completed.isActive, isFalse);
      expect(OrderStatus.cancelled.isActive, isFalse);
    });
  });

  // ── OrderNotifier (Riverpod) tests ────────────────────────────────────────

  group('OrderNotifier (Riverpod)', () {
    ProviderContainer makeContainer() => ProviderContainer();

    test('initial state is empty', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      expect(container.read(orderProvider), isEmpty);
    });

    test('trackFromCheckout adds an order derived from CheckoutOrder', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container
          .read(orderProvider.notifier)
          .trackFromCheckout(_makeCheckoutOrder());

      final orders = container.read(orderProvider);
      expect(orders, hasLength(1));
      expect(orders.first.id, 'ORD-200');
      expect(orders.first.status, OrderStatus.placed);
    });

    test('trackFromCheckout is idempotent for the same orderId', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final co = _makeCheckoutOrder();
      container.read(orderProvider.notifier).trackFromCheckout(co);
      container.read(orderProvider.notifier).trackFromCheckout(co);

      expect(container.read(orderProvider), hasLength(1));
    });

    test('updateStatus changes status in Riverpod state', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container
          .read(orderProvider.notifier)
          .trackFromCheckout(_makeCheckoutOrder(orderId: 'ORD-300'));

      container
          .read(orderProvider.notifier)
          .updateStatus('ORD-300', OrderStatus.preparing);

      final order = container.read(orderProvider).first;
      expect(order.status, OrderStatus.preparing);
    });

    test('latestOrderProvider returns the most-recently added order', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container
          .read(orderProvider.notifier)
          .trackFromCheckout(_makeCheckoutOrder(orderId: 'ORD-401'));
      container
          .read(orderProvider.notifier)
          .trackFromCheckout(_makeCheckoutOrder(orderId: 'ORD-402'));

      // Most recent first.
      expect(container.read(latestOrderProvider)?.id, 'ORD-402');
    });

    test('activeOrdersProvider excludes completed orders', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container
          .read(orderProvider.notifier)
          .trackFromCheckout(_makeCheckoutOrder(orderId: 'ORD-501'));
      container
          .read(orderProvider.notifier)
          .updateStatus('ORD-501', OrderStatus.completed);

      container
          .read(orderProvider.notifier)
          .trackFromCheckout(_makeCheckoutOrder(orderId: 'ORD-502'));

      final active = container.read(activeOrdersProvider);
      expect(active, hasLength(1));
      expect(active.first.id, 'ORD-502');
    });
  });
}
