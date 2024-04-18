// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:content_app/main.dart';

void main() {

  testWidgets('App name populate', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Content App: kiswahili'), findsOneWidget);
  });

  // testWidgets('Languages in dropdown populates', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   final languageDropdown = find.byKey(const ValueKey('languageDropdown'));

  //   expect(languageDropdown, findsOneWidget);
  //   // Open the dropdown menu
  //   await tester.tap(languageDropdown);
  //   await tester.pumpAndSettle();
      
  //   // Find the dropdown menu items
  //   final dholuo = find.byKey(const ValueKey('dholuo'));

  //   await tester.tap(dholuo);
  //   await tester.pumpAndSettle();

  //   expect(find.text('Content App: dholuo'), findsOneWidget);

  //   // Check if the dropdown menu items contain the expected languages
  //   // for (var language in languages) {
  //   //   expect(find.text(language), findsOneWidget);
  //   // }
  //   });
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
