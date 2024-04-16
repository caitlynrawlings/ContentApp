import 'package:flutter/material.dart';
import 'custom_page.dart';
import 'page_content.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


int selectedIndex = 0;  // tracks which page is being displayed
String selectedLanguage = "";  // tracks current language

// for storing data once parsed from json
var languages = [];
var pageTitles = <Map<String, String>>[];
var pagesContents = <List<Map<String, PageContent>>>[];

// loads the app content data from the json file into data structures
Future<void> loadJsonData() async {
    // Load the JSON file
    String jsonData = await rootBundle.loadString('content/test_content.json');
      
    // Parse the JSON string
    Map<String, dynamic> data = json.decode(jsonData);
      
    // Get language options for the app and sets current language
    for (var language in data["languages"]) {
      languages.add(language.toString());
    }
    selectedLanguage = languages[0];

    for (var page in data["pages"]) {
      Map<String, dynamic> pageInfo = page as Map<String, dynamic>;  // title and content as keys

      // Check if 'title' is a list or a map
      dynamic titleData = pageInfo["title"];

      if (titleData is List) {
        // Handle if 'title' is a list
        Map<String, String> titleMap = {};
        for (int i = 0; i < languages.length && i < titleData.length; i++) {
          if (titleData[i] is String) {
            titleMap[languages[i]] = titleData[i] as String;
          }
        }
        pageTitles.add(titleMap);
      } else if (titleData is Map<String, dynamic>) {
        // Handle if 'title' is a map
        pageTitles.add(titleData.cast<String, String>());
      }

      // Check if 'title' is a list or a map
      dynamic contentData = pageInfo["content"];  // content data on one page

      if (contentData is List) {
        // Handle if 'content' is a list
        List<Map<String, PageContent>> onePageContents = [];
        for (int i = 0; i < contentData.length && i < contentData.length; i++) {
          Map<String, dynamic> peiceOfContent = contentData[i] as Map<String, dynamic>;
          dynamic contentType = peiceOfContent["content-type"] as String;
          Map<String, dynamic> contentValue = peiceOfContent["content"];
          Map<String, String> parsedContentValue = {}; // language to content value in that language map
          parsedContentValue = contentValue.map((key, value) => MapEntry(key, value.toString()));
          Map<String, PageContent> pageContentsEntry = {};
          for (var item in parsedContentValue.entries) {
            String language = item.key;
            String contentTranslation = item.value;
            pageContentsEntry[language] = PageContent(contentType: contentType, value: contentTranslation);
          }
          onePageContents += [pageContentsEntry];
        }
        pagesContents += [onePageContents];
      } else if (contentData is Map<String, dynamic>) {
        // Handle if 'title' is a map
        break;
      }


    }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadJsonData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 70, 70, 70)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            title: Text('Family Planning Guide in: $selectedLanguage'),
          ),
          body: Column(
            children: [
              LanguageDropdown(
                selectedLanguage: selectedLanguage,
                onChanged: (String newValue) {
                  setState(() {
                    selectedLanguage = newValue;
                  });
                },
              ),
              Expanded(
                child: selectedIndex == 0
                    ? Center(
                        child: MenuPage(
                          pageTitles: pageTitles,
                          onSelectPage: (index) {
                            setState(() {
                              selectedIndex = index + 1;
                            });
                          },
                        ),
                      )
                    : CustomPage(
                        content: pagesContents[selectedIndex - 1],
                        title: pageTitles[selectedIndex - 1],
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

class MenuPage extends StatelessWidget {
  final List<Map<String, String>> pageTitles;
  final Function(int) onSelectPage;

  const MenuPage({
    super.key,
    required this.pageTitles,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pageTitles.length,
      itemBuilder: (context, index) {
        return PageButton(
          pageLabel: pageTitles[index][selectedLanguage] ?? "Not available",
          onPressed: () {
            onSelectPage(index);
          },
        );
      },
    );
  }
}

class PageButton extends StatelessWidget {
  final String pageLabel;
  final VoidCallback onPressed;

  const PageButton({
    super.key,
    required this.pageLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
          ),
          child: Text(
            pageLabel,
            style: style,
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class LanguageDropdown extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedLanguage,
      onChanged: (String? newValue) {
        widget.onChanged(newValue ?? languages[0]);
      },
      items: languages
          .map<DropdownMenuItem<String>>((dynamic value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
    );
  }
}
