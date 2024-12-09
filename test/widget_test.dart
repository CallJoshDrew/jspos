// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jspos/app/jpos.dart';

// import 'package:jspos/main.dart';

void main() {
  testWidgets('Add category test', (WidgetTester tester) async {
   

    // Build our app and trigger a frame.
    await tester.pumpWidget(const JPOSApp());

    // Find the add category button and tap it
    var addButton = find.byIcon(Icons.add);
    await tester.tap(addButton);
    await tester.pump();

    // Enter text into the TextField
    var textField = find.byType(TextField);
    await tester.enterText(textField, 'New Category');
    await tester.pump();

    // Verify that the new category is added
    expect(find.text('New Category'), findsOneWidget);
  });
}

