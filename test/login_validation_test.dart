import 'package:cafeteria_app/core/validators/form_validators.dart';
import 'package:cafeteria_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormValidators', () {
    test('rejects empty and malformed emails', () {
      expect(FormValidators.email(''), isNotNull);
      expect(FormValidators.email('not-an-email'), isNotNull);
      expect(FormValidators.email('user@domain'), isNotNull);
      expect(FormValidators.email('customer@cafeteria.local'), isNull);
    });

    test('rejects empty and short passwords', () {
      expect(FormValidators.password(''), isNotNull);
      expect(FormValidators.password('12345'), isNotNull);
      expect(FormValidators.password('123456'), isNull);
    });

    test('validates matching confirmation password', () {
      expect(FormValidators.confirmPassword('', 'secret12'), isNotNull);
      expect(FormValidators.confirmPassword('secret99', 'secret12'), isNotNull);
      expect(FormValidators.confirmPassword('secret12', 'secret12'), isNull);
    });

    test('validates phone numbers', () {
      expect(FormValidators.phone(''), isNotNull);
      expect(FormValidators.phone('123'), isNotNull);
      expect(FormValidators.phone('0911 22 33 44'), isNull);
    });
  });

  group('Login and Registration validation widgets', () {
    testWidgets('LoginScreen shows validation errors on empty submission', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CafeteriaApp());
      await tester.pumpAndSettle();

      final submitButton = find.byKey(const ValueKey('login_submit_button'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('LoginScreen rejects invalid email and short password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CafeteriaApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('login_email_field')),
        'invalid-email',
      );
      await tester.enterText(
        find.byKey(const ValueKey('login_password_field')),
        '123',
      );

      final submitButton = find.byKey(const ValueKey('login_submit_button'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('LoginScreen signs in customer with valid credentials', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CafeteriaApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('login_email_field')),
        'customer@cafeteria.local',
      );
      await tester.enterText(
        find.byKey(const ValueKey('login_password_field')),
        'password123',
      );

      final submitButton = find.byKey(const ValueKey('login_submit_button'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text("TODAY'S MENU"), findsOneWidget);
      expect(find.text('Welcome, Customer!'), findsOneWidget);
    });

    testWidgets('RegisterScreen validates mismatched passwords and submits', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CafeteriaApp());
      await tester.pumpAndSettle();

      final registerLink = find.text("Don't have an account? Register");
      await tester.ensureVisible(registerLink);
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('register_name_field')),
        'Meresiet Zekiros',
      );
      await tester.enterText(
        find.byKey(const ValueKey('register_email_field')),
        'meresiet@cafeteria.local',
      );
      await tester.enterText(
        find.byKey(const ValueKey('register_password_field')),
        'secret123',
      );
      await tester.enterText(
        find.byKey(const ValueKey('register_confirm_password_field')),
        'different123',
      );

      final registerButton = find.byKey(
        const ValueKey('register_submit_button'),
      );
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('register_confirm_password_field')),
        'secret123',
      );
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome, Meresiet Zekiros!'), findsOneWidget);
      expect(find.text("TODAY'S MENU"), findsOneWidget);
    });
  });
}
