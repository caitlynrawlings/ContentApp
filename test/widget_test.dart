// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:content_app/lang_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:content_app/main.dart';

void main() {

  testWidgets('Verify language dropdown initializes correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MyApp(jsonFile: 'assets/test_content.json',));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('languageDropdown')), findsOneWidget);

      // Find the LanguageDropdown widget using its key
      final languageDropdownFinder = find.byKey(const ValueKey("languageDropdown"));

      expect(languageDropdownFinder, findsOneWidget);

      // Extract the language from the language Dropdown widget
      final language = (tester.widget<LanguageDropdown>(languageDropdownFinder)).selectedLanguage;

      // Verify that the extracted languages is equal to the expected language
      expect(language, equals("english"));

      // Extract the languages from the language Dropdown widget
      final languages = (tester.widget<LanguageDropdown>(languageDropdownFinder)).languages;

      final expectedLanguages = ["english", "dholuo", "kiswahili"];

      // Verify that the extracted languages is equal to the expected language
      expect(languages, equals(expectedLanguages));
    });
  });

  testWidgets('Verify language dropdown changes updates self properly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MyApp(jsonFile: 'assets/test_content.json',));
      await tester.pumpAndSettle();

      // Tap on the dropdown to open it
      await tester.tap(find.byKey(const ValueKey('languageDropdown')));
      await tester.pumpAndSettle(); // Ensure dropdown menu is rendered

      // Find the dropdown menu item for "dholuo"
      final dholuoItem = find.text("dholuo");

      // Check if the item is found
      expect(dholuoItem, findsOneWidget);

      // Tap on the "dholuo" dropdown menu item to select it
      await tester.tap(dholuoItem);
      await tester.pumpAndSettle(); // Ensure widget tree is updated

      // Verify that the selected language is updated to "dholuo"
      expect(find.text("dholuo"), findsOneWidget);
    });
  });

  testWidgets('Verify language dropdown changes updates page properly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MyApp(jsonFile: 'assets/test_content.json',));
      await tester.pumpAndSettle();

      // Tap on the dropdown to open it
      await tester.tap(find.byKey(const ValueKey('languageDropdown')));
      await tester.pumpAndSettle(); // Ensure dropdown menu is rendered

      // Find english heading
      final headingItem = find.text("Page 1 (english)");
      // Check if the item is found
      expect(headingItem, findsOneWidget);

      // Find the dropdown menu item for "dholuo"
      final dholuoItem = find.text("dholuo");

      // Check if the item is found
      expect(dholuoItem, findsOneWidget);

      // Tap on the "dholuo" dropdown menu item to select it
      await tester.tap(dholuoItem);
      await tester.pumpAndSettle(); // Ensure widget tree is updated

      // Find english heading
      final newHeadingItem = find.text("Page 1 (dholuo) and the translation is really really really long");
      // Check if the item is found
      expect(newHeadingItem, findsOneWidget);

      // Verify that the selected language is updated to "dholuo"
      expect(find.text("dholuo"), findsOneWidget);
    });
  });

  testWidgets('Find home icon', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MyApp());

      expect(find.byIcon(Icons.home), findsOneWidget);
    });
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
