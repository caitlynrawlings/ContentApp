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
  group('Language Dropdown', () {
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
        final page1Button = find.text("Page 1 (english)");
        // Check if the item is found
        expect(page1Button, findsOneWidget);

        // Find the dropdown menu item for "dholuo"
        final dholuoItem = find.text("dholuo");

        // Check if the item is found
        expect(dholuoItem, findsOneWidget);

        // Tap on the "dholuo" dropdown menu item to select it
        await tester.tap(dholuoItem);
        await tester.pumpAndSettle(); // Ensure widget tree is updated

        // Find english heading
        final newPage1Button = find.text("Page 1 (dholuo) and the translation is really really really long");
        // Check if the item is found
        expect(newPage1Button, findsOneWidget);

        // Verify that the selected language is updated to "dholuo"
        expect(find.text("dholuo"), findsOneWidget);
      });
    });
  });

  group('Menu to page and back to menu', () {
    testWidgets('Verify menu button updates page', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/test_content.json',));
        await tester.pumpAndSettle();

        // Find english heading
        final page1button = find.text("Page 1 (english)");
        // Check if the item is found
        expect(page1button, findsOneWidget);

        // Tap on the page button to go to that page
        await tester.tap(page1button);
        await tester.pumpAndSettle(); 

        // Find the dropdown menu item for "dholuo"
        final headingItem = find.text("page1heading1");

        // Check if the item is found
        expect(headingItem, findsOneWidget);
      });
    });

    testWidgets('Find home icon', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp());

        expect(find.byIcon(Icons.home), findsOneWidget);
      });
    });

    testWidgets('Verify home button returns to menu', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp(jsonFile: 'assets/test_content.json',));
        await tester.pumpAndSettle();

        // Find english heading
        var page1button = find.text("Page 1 (english)");
        // Check if the item is found
        expect(page1button, findsOneWidget);

        // Tap on the page button to go to that page
        await tester.tap(page1button);
        await tester.pumpAndSettle();

        // Find the dropdown menu item for "dholuo"
        final headingItem = find.text("page1heading1");

        // Check if the item is found
        expect(headingItem, findsOneWidget);

        // Find home button
        final homeButton = find.byIcon(Icons.home);
        // Check if the item is found
        expect(homeButton, findsOneWidget);

        // Tap on the page button to go to that page
        await tester.tap(homeButton);
        await tester.pumpAndSettle();

        // Check for all page names in english to see if back in menu
        page1button = find.text("Page 1 (english)");
        // Check if the item is found
        expect(page1button, findsOneWidget);

        final page2button = find.text("Page 2 (english)");
        // Check if the item is found
        expect(page2button, findsOneWidget);

      });
    });
  });
}
