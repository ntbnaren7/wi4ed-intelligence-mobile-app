// WI4ED Flutter App - Widget Tests

import 'package:flutter_test/flutter_test.dart';

import 'package:wi4ed_app/app.dart';

void main() {
  testWidgets('WI4ED app renders home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WI4EDApp());

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app renders with WI4ED branding
    expect(find.text('WI4ED'), findsWidgets);
  });
}
