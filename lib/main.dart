import 'package:flutter/material.dart';
import 'page.dart';
import 'page_content.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer' as developer;

var languages = [];

var pageToContent = {
  "What are my options?": <PageContent>[
    PageContent(
      contentType: 'header',
      value: 'Content of Page options page',
    ),
    PageContent(
      contentType: 'image',
      value: 'img',
    ),
  ],
  "What will happen to my period?": <PageContent>[
    PageContent(
      contentType: 'header',
      value: 'Content of Page period page',
    ),
    PageContent(
      contentType: 'image',
      value: 'img2',
    ),
  ],
};

const pages = ["What are my options?", "What will happen to my period?"];

Future<void> loadJsonData() async {
    // Load the JSON file
    String jsonData = await rootBundle.loadString('content/test_content.json');
      
    // Parse the JSON string
    Map<String, dynamic> data = json.decode(jsonData);
      
    // Use the data as needed
    for (var language in data["languages"]) {
      developer.log(language, name: 'my.app.category');
      languages.add(language.toString());
    }
  }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadJsonData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  String selectedLanguage = languages[0]; // Variable to store the selected language

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
                          pages: pages,
                          onSelectPage: (index) {
                            setState(() {
                              selectedIndex = index + 1;
                            });
                          },
                        ),
                      )
                    : CustomPage(
                        content: pageToContent[pages[selectedIndex]] ?? [],
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
  final List<String> pages;
  final Function(int) onSelectPage;

  const MenuPage({
    Key? key,
    required this.pages,
    required this.onSelectPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return PageButton(
          pageLabel: pages[index],
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
    Key? key,
    required this.pageLabel,
    required this.onPressed,
  }) : super(key: key);

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
    Key? key,
    required this.selectedLanguage,
    required this.onChanged,
  }) : super(key: key);

  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
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
