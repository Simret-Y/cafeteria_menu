import 'package:flutter_test/flutter_test.dart';

import 'package:cafeteria_app/main.dart';

void main() {
  testWidgets('App launches and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CafeteriaApp());
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });
}
