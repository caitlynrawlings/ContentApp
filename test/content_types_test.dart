import 'package:content_app/content_types/audio_widget.dart';
import 'package:content_app/lang_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:content_app/main.dart';

void main() {
  group('Heading content type', () {
    testWidgets('Verify heading populates on screen', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/content_types_test.json',));
        await tester.pumpAndSettle();

        // Find page1button widget using its key
        final page0button = find.byKey(const ValueKey("Page0"));

        expect(page0button, findsOneWidget);

        await tester.tap(page0button);
        await tester.pumpAndSettle();

        // Find heading widget using its key
        final heading = find.text("Heading Text");

        expect(heading, findsOneWidget);
      });
    });
  });

  group('Subeading content type', () {
    testWidgets('Verify subheading populates on screen', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/content_types_test.json',));
        await tester.pumpAndSettle();

        // Find page1button widget using its key
        final page1button = find.byKey(const ValueKey("Page1"));

        expect(page1button, findsOneWidget);

        await tester.tap(page1button);
        await tester.pumpAndSettle();

        // Find subheading widget using its key
        final subheading = find.text("Subheading Text");

        expect(subheading, findsOneWidget);
      });
    });
  });

  group('Body text content type', () {
    testWidgets('Verify body text populates on screen', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/content_types_test.json',));
        await tester.pumpAndSettle();

        // Find page2button widget using its key
        final page2button = find.byKey(const ValueKey("Page2"));

        expect(page2button, findsOneWidget);

        await tester.tap(page2button);
        await tester.pumpAndSettle();

        // Find body text widget using its key
        final text = find.text("Body Text");

        expect(text, findsOneWidget);
      });
    });
  });

  group('Callout content type', () {
    testWidgets('Verify callout populates on screen', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/content_types_test.json',));
        await tester.pumpAndSettle();

        // Find page3button widget using its key
        final page3button = find.byKey(const ValueKey("Page3"));

        expect(page3button, findsOneWidget);

        await tester.tap(page3button);
        await tester.pumpAndSettle();

        // Find callout widget using its text
        final text = find.text("Callout text");
        expect(text, findsOneWidget);

        // Find callout widget icon
        expect(find.byWidgetPredicate(
          (Widget widget) => widget is Image, // Check if the widget is an Image
          description: 'Image Widget',
        ), findsNWidgets(1));
      });
    });
  });

  group('Spacer content type', () {
    testWidgets('Verify spacer populates on screen', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/content_types_test.json',));
        await tester.pumpAndSettle();

        // Find page4button widget using its key
        final page4button = find.byKey(const ValueKey("Page4"));

        expect(page4button, findsOneWidget);

        await tester.tap(page4button);
        await tester.pumpAndSettle();

        // Find spacer widget using its key
        final spacer = find.byKey(const ValueKey("spacer8"));

        expect(spacer, findsOneWidget);
      });
    });
  });

  group('Audio content type', () {
    testWidgets('Verify audio populates on screen', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/content_types_test.json',));
        await tester.pumpAndSettle();

        // Find page5button widget using its key
        final page5button = find.byKey(const ValueKey("Page5"));

        expect(page5button, findsOneWidget);

        await tester.tap(page5button);
        await tester.pumpAndSettle();

        // Find audio widget icon
        expect(find.byWidgetPredicate(
          (Widget widget) => widget is AudioWidget, // Check if the widget is an AuidoWidget
          description: 'Audio Widget',
        ), findsNWidgets(1));
      });
    });
  });

}
