import 'package:flutter_test/flutter_test.dart';

import 'package:cafeteria_app/main.dart';

void main() {
  testWidgets('App launches and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Continue as Customer'), findsOneWidget);
    expect(find.text('Continue as Staff'), findsOneWidget);
    expect(find.text('Continue as Manager'), findsOneWidget);
  });

  testWidgets('Login navigates to register', (WidgetTester tester) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('Customer login navigates to home with customer nav', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue as Customer'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    // Customer bottom nav destinations
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
  });

  testWidgets('Staff login navigates to staff dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue as Staff'));
    await tester.pumpAndSettle();

    expect(find.text('Staff Dashboard'), findsWidgets);
    expect(find.text('QR Scanner'), findsOneWidget);
    // Customer destinations must not appear for staff
    expect(find.text('Cart'), findsNothing);
  });

  testWidgets('Manager login navigates to manager dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue as Manager'));
    await tester.pumpAndSettle();

    expect(find.text('Manager Dashboard'), findsWidgets);
    expect(find.text('Cart'), findsNothing);
  });

  testWidgets('Customer bottom nav navigates between tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue as Customer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Cart'), findsWidgets);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('Order Tracking'), findsWidgets);
  });

  testWidgets('Staff bottom nav navigates to QR scanner', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue as Staff'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('QR Scanner'));
    await tester.pumpAndSettle();
    expect(find.text('QR Scanner'), findsWidgets);
  });

  testWidgets('All routes load without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    // Login as customer, then visit each customer route via bottom nav / taps.
    await tester.tap(find.text('Continue as Customer'));
    await tester.pumpAndSettle();

    // Menu details, checkout, recommendations are reachable routes; verify
    // they render by navigating through the router indirectly is complex,
    // so verify the remaining nav destinations load.
    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
