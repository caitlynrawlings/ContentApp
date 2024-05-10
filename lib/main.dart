import 'package:content_app/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'custom_page.dart';
import 'lang_dropdown.dart'; 

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  const file = String.fromEnvironment("FILE", defaultValue: 'assets/pages.json');
  runApp(const MyApp(jsonFile: file));
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
      home: SelectionArea(child: AppScreen(jsonFile: jsonFile)),
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
  String selectedLanguage = "";  // tracks current language and its directionality

  List<dynamic> pageIds = [];
  List<dynamic> pageTitles = [];
  List<dynamic> pagesContents = [];
  Map<String, String> languages = {};

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString(widget.jsonFile);
    final data = json.decode(jsonData);

    setState(() {
      final dynamic languagesData = data['languages'];
      if (languagesData is List && languagesData.isNotEmpty && languagesData.every((e) => e is Map<String, dynamic>)) {
        for (var item in languagesData) {
          String lan = item['language'] != Null ? item['language'] : throw Exception('language cannot be null');
          String dir = item['direction'] != Null ? item['direction'] : throw Exception('language cannot be null');
          languages[lan] = dir;
        }
      } else {
        throw Exception('language cannot be null');
      }
      selectedLanguage = languages.keys.first;
      
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
    return FocusScope(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                toolbarHeight: 60,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 6.0,),
                  child: IconButton(
                    // tooltip: "Menu",
                    icon: const Icon(Icons.menu, size: 40),
                    onPressed: () {
                      setState(() {
                        selectedPageIndex = 0;
                      });
                    },
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LanguageDropdown(
                      key: const ValueKey('languageDropdown'),
                      selectedLanguage: selectedLanguage,
                      languages: languages.keys.toList(),
                      onChanged: (String newLanguage) {
                        _handleLanguageChange(newLanguage);
                      },
                    ),
                    const SizedBox(width: 4.0),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 40),
                      onPressed: () {
                        setState(() {
                          selectedPageIndex = -1;
                        });
                      },
                    )
                  ],
                ),
              ),
              body: Directionality(
                textDirection: languages[selectedLanguage] == "rtl" ? TextDirection.rtl : TextDirection.ltr,
                 child: 
                Column(
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
              ),
          );
        },
      ),
    );
  }
}