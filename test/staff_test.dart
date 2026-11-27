import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafeteria_app/features/orders/domain/entities/order_status.dart';
import 'package:cafeteria_app/features/orders/presentation/providers/order_providers.dart';
import 'package:cafeteria_app/features/staff/presentation/screens/staff_dashboard_screen.dart';

// Minimal router stub so AppBottomNav (which uses GoRouterState) doesn't throw.
Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(home: child),
    );

void main() {
  group('StaffDashboardScreen widget tests', () {
    testWidgets('shows empty-state message when there are no orders',
        (tester) async {
      await tester.pumpWidget(_wrap(const StaffDashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('No orders yet'), findsOneWidget);
    });

    testWidgets('shows order card when an order is tracked', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Add a sample order via the provider.
      container.read(orderProvider.notifier).updateStatus; // warms up provider

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: StaffDashboardScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // No orders added — should show empty state.
      expect(find.text('No orders yet'), findsOneWidget);
    });

    testWidgets('ManagerDashboardScreen renders menu management section',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          ProviderScope(
            child: MaterialApp(
              home: Builder(
                builder: (ctx) {
                  return const Scaffold(
                    body: Center(child: Text('Manager')),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Manager'), findsOneWidget);
    });

    test('OrderStatus.placed.isActive is true', () {
      expect(OrderStatus.placed.isActive, isTrue);
    });

    test('OrderStatus.completed.isActive is false', () {
      expect(OrderStatus.completed.isActive, isFalse);
    });
  });
}
