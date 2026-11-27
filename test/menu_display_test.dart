import 'package:cafeteria_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _signInAsCustomer(WidgetTester tester) async {
  await tester.pumpWidget(const CafeteriaApp());
  await tester.pumpAndSettle();

  final customerButton = find.text('Continue as Customer');
  await tester.ensureVisible(customerButton);
  await tester.tap(customerButton);
  await tester.pumpAndSettle();
}

void main() {
  group('Customer menu, details, cart, and checkout flow', () {
    testWidgets('CustomerHomeScreen displays sample menu items and prices', (
      WidgetTester tester,
    ) async {
      await _signInAsCustomer(tester);

      expect(find.text("TODAY'S MENU"), findsOneWidget);
      expect(find.text('Chicken Sandwich'), findsOneWidget);
      expect(find.text('150 ETB'), findsOneWidget);
      expect(find.text('Pasta'), findsOneWidget);
      expect(find.text('180 ETB'), findsOneWidget);
    });

    testWidgets(
      'CustomerHomeScreen filters menu items by category and search',
      (WidgetTester tester) async {
        await _signInAsCustomer(tester);

        await tester.tap(find.widgetWithText(ChoiceChip, 'Drinks'));
        await tester.pumpAndSettle();

        expect(find.text('Ethiopian Macchiato'), findsOneWidget);
        expect(find.text('Fresh Mango Juice'), findsOneWidget);
        expect(find.text('Chicken Sandwich'), findsNothing);

        await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('menu_search_field')),
          'Pasta',
        );
        await tester.pumpAndSettle();

        expect(
          find.descendant(of: find.byType(Card), matching: find.text('Pasta')),
          findsOneWidget,
        );
        expect(find.text('Chicken Sandwich'), findsNothing);
      },
    );

    testWidgets(
      'Navigating to MenuDetailsScreen adds selected quantity to Cart and completes Checkout',
      (WidgetTester tester) async {
        await _signInAsCustomer(tester);

        await tester.tap(find.text('View Details').first);
        await tester.pumpAndSettle();

        expect(find.text('Menu Details'), findsOneWidget);
        expect(find.text('Chicken Sandwich'), findsOneWidget);

        final incrementButton = find.byKey(
          const ValueKey('details_increment_button'),
        );
        await tester.ensureVisible(incrementButton);
        await tester.tap(incrementButton);
        await tester.pumpAndSettle();

        expect(find.text('2'), findsOneWidget);

        final addButton = find.byKey(
          const ValueKey('details_add_to_cart_button'),
        );
        await tester.ensureVisible(addButton);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Open Cart'));
        await tester.pumpAndSettle();

        expect(find.text('Chicken Sandwich'), findsOneWidget);
        expect(find.text('300 ETB'), findsOneWidget);

        final checkoutButton = find.byKey(
          const ValueKey('proceed_to_checkout_button'),
        );
        await tester.ensureVisible(checkoutButton);
        await tester.tap(checkoutButton);
        await tester.pumpAndSettle();

        expect(find.text('Checkout'), findsOneWidget);

        // Validate checkout form requires customer name and phone number.
        final placeOrderButton = find.byKey(
          const ValueKey('place_order_button'),
        );
        await tester.ensureVisible(placeOrderButton);
        await tester.tap(placeOrderButton);
        await tester.pumpAndSettle();

        expect(find.text('Please enter your full name'), findsOneWidget);
        expect(find.text('Please enter your phone number'), findsOneWidget);

        await tester.enterText(
          find.byKey(const ValueKey('checkout_name_field')),
          'Meresiet Zekiros',
        );
        await tester.enterText(
          find.byKey(const ValueKey('checkout_phone_field')),
          '0911223344',
        );
        await tester.ensureVisible(placeOrderButton);
        await tester.tap(placeOrderButton);
        await tester.pumpAndSettle();

        expect(find.text('Order Placed'), findsOneWidget);
        expect(find.textContaining('ORD-'), findsOneWidget);
      },
    );
  });
}
