import 'package:content_app/lang_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:content_app/main.dart';

void main() {
  group('heading tests', () {
    testWidgets('verify heading appears', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/example.json',));
        await tester.pumpAndSettle();

        await tester.tap(find.text('English Title'));
        await tester.pumpAndSettle();

        expect(find.text("The Heading Text"), findsOneWidget);
      });
    });
  });
}