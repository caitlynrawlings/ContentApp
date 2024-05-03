import 'package:content_app/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'custom_page.dart';
import 'lang_dropdown.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String jsonFile; 

  const MyApp({super.key, this.jsonFile = 'assets/pages.json'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Content App',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 97, 29, 157),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: AppScreen(jsonFile: jsonFile),
    );
  }
}

class AppScreen extends StatefulWidget {
  final String jsonFile; 

  const AppScreen({super.key, required this.jsonFile});

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int selectedPageIndex = 0;  // tracks which page is being displayed. 0 is menu page and increments from that in order of pages added
  String selectedLanguage = "";  // tracks current language

  List<dynamic> pageIds = [];
  List<dynamic> pageTitles = [];
  List<dynamic> pagesContents = [];
  List<String> languages = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString(widget.jsonFile);
    final data = json.decode(jsonData);
    setState(() {
      languages = List<String>.from(data['languages']);
      selectedLanguage = languages[0];

      List<dynamic> pages = data['pages'];
      for (dynamic page in pages) {
        pageIds += [page["id"]];
        pageTitles += [page["title"]];
        pagesContents += [page["content"]];
      }
    });
  }

  void _handleLanguageChange(String newLanguage) {
    setState(() {
      selectedLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                setState(() {
                  selectedPageIndex = 0;
                });
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LanguageDropdown(
                  key: const ValueKey('languageDropdown'),
                  selectedLanguage: selectedLanguage,
                  languages: languages,
                  onChanged: (String newLanguage) {
                    _handleLanguageChange(newLanguage);
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: selectedPageIndex == 0
                    ? Center(
                        child: Menu(
                          pageTitles: pageTitles,
                          selectedLanguage: selectedLanguage,
                          onSelectPage: (index) {
                            setState(() {
                              selectedPageIndex = index + 1;
                            });
                          },
                        ),
                      )
                    : CustomPage(
                        content: pagesContents[selectedPageIndex - 1],
                        title: pageTitles[selectedPageIndex - 1],
                        language: selectedLanguage,
                        onChangePage: (pageId) {
                            setState(() {
                              selectedPageIndex = pageIds.indexOf(pageId) + 1;
                            });
                          },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}