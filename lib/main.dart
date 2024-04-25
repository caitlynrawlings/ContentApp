import 'package:content_app/Menu.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Content App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPageIndex = 0;  // tracks which page is being displayed. 0 is menu page and increments from that in order of pages added
  String selectedLanguage = "";  // tracks current language

  List<dynamic> pageTitles = [];
  List<dynamic> pagesContents = [];
  List<String> languages = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString('assets/test_content.json');
    final data = json.decode(jsonData);
    setState(() {
      languages = List<String>.from(data['languages']);
      selectedLanguage = languages[0];

      List<dynamic> pages = data['pages'];
      for (dynamic page in pages) {
        pageTitles += [page["title"]];
        pagesContents += [page["content"]];
      }

      
      // for (var page in data["pages"]) {
      //   Map<String, dynamic> pageInfo = page as Map<String, dynamic>;  // title and content as keys

      //   // Check if 'title' is a list or a map
      //   dynamic titleData = pageInfo["title"];

      //   if (titleData is List) {
      //     // Handle if 'title' is a list
      //     Map<String, String> titleMap = {};
      //     for (int i = 0; i < languages.length && i < titleData.length; i++) {
      //       if (titleData[i] is String) {
      //         titleMap[languages[i]] = titleData[i] as String;
      //       }
      //     }
      //     pageTitles.add(titleMap);
      //   } else if (titleData is Map<String, dynamic>) {
      //     // Handle if 'title' is a map
      //     pageTitles.add(titleData.cast<String, String>());
      //   }

      //   // Check if 'title' is a list or a map
      //   dynamic contentData = pageInfo["content"];  // content data on one page

      //   if (contentData is List) {
      //     // Handle if 'content' is a list
      //     List<Map<String, PageContent>> onePageContents = [];
      //     for (int i = 0; i < contentData.length && i < contentData.length; i++) {
      //       Map<String, dynamic> peiceOfContent = contentData[i] as Map<String, dynamic>;
      //       dynamic contentType = peiceOfContent["content-type"] as String;
      //       Map<String, dynamic> contentValue = peiceOfContent["content"];
      //       Map<String, String> parsedContentValue = {}; // language to content value in that language map
      //       parsedContentValue = contentValue.map((key, value) => MapEntry(key, value.toString()));
      //       Map<String, PageContent> pageContentsEntry = {};
      //       for (var item in parsedContentValue.entries) {
      //         String language = item.key;
      //         String contentTranslation = item.value;
      //         pageContentsEntry[language] = PageContent(contentType: contentType, value: contentTranslation);
      //       }
      //       onePageContents += [pageContentsEntry];
      //     }
      //     pagesContents += [onePageContents];
      //   } else if (contentData is Map<String, dynamic>) {
      //     // Handle if 'title' is a map
      //     break;
      //   }
      // }
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
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}