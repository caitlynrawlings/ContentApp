import 'package:content_app/change_page_arrow.dart';
import 'package:content_app/nav_arrows.dart';
import 'package:content_app/pages/menu.dart';
import 'package:content_app/pages/settings.dart';
import 'package:content_app/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'pages/custom_page.dart';
import 'lang_dropdown.dart'; 

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use ' flutter run --dart-define="FILE=<the file you want to load>" ' to load file other than pages
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
  int lastPageIndex = 0;
  final List<int> undoStack = [];  // stores the page index of the pages 

  String selectedLanguage = "";  // tracks current language and its directionality
  double _fontSizeFactor = 1.0; // Initial font size factor
  bool _lightMode = false;

  List<dynamic> pageIds = [];
  List<dynamic> pageTitles = [];
  List<dynamic> menuPageIds = [];
  List<dynamic> menuPageTitles = [];
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
        if (!page["hidden"]) {
          menuPageTitles += [page["title"]];
          menuPageIds += [page["id"]];
        }
        pagesContents += [page["content"]];
      }
    });
  }

  void _handleLanguageChange(String newLanguage) {
    setState(() {
      selectedLanguage = newLanguage;
    });
  }

  void _handleFontSizeChange(double factor) {
    setState(() {
      _fontSizeFactor = factor;
    });
  }

  void _handleLightModeChange() {
    setState(() {
      _lightMode = !_lightMode;
    });
  }

  void _onUndo() {
    setState(() {
      if (undoStack.isNotEmpty) {
        lastPageIndex = selectedPageIndex;
        selectedPageIndex = undoStack.removeLast();
        SemanticsService.announce('Previous page restored', TextDirection.ltr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);

    final ThemeData lightTheme = _lightMode 
                                    ? AppThemes.darkTheme
                                    : AppThemes.lightTheme;

    final TextTheme textTheme = baseTheme.textTheme.copyWith(
      displayLarge: lightTheme.textTheme.displayLarge?.copyWith(fontSize: AppFontSizes.displayLargeSize * _fontSizeFactor,),
      displayMedium: lightTheme.textTheme.displayMedium?.copyWith(fontSize: AppFontSizes.displayMediumSize * _fontSizeFactor),
      displaySmall: lightTheme.textTheme.displaySmall?.copyWith(fontSize: AppFontSizes.displaySmallSize * _fontSizeFactor),
      headlineMedium: lightTheme.textTheme.headlineMedium?.copyWith(fontSize: AppFontSizes.headlineMediumSize * _fontSizeFactor),
      bodyLarge: lightTheme.textTheme.bodyLarge?.copyWith(fontSize: AppFontSizes.bodyLargeSize * _fontSizeFactor),
      bodySmall: lightTheme.textTheme.bodySmall?.copyWith(fontSize: AppFontSizes.bodySmallSize * _fontSizeFactor),
      labelLarge: lightTheme.textTheme.labelLarge?.copyWith(fontSize: AppFontSizes.labelLargeSize * _fontSizeFactor),
    ).apply(
      displayColor: lightTheme.colorScheme.onSurface,
      bodyColor: lightTheme.colorScheme.onSurface,
    );

    final ThemeData selectedTheme = lightTheme.copyWith(textTheme: textTheme);

    return Theme(
      data: selectedTheme,
      child: Scaffold(
              appBar: AppBar(
                backgroundColor: selectedTheme.colorScheme.primary,
                toolbarHeight: 60,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 6.0,),
                  child: IconButton(
                    icon: Semantics( 
                      label: 'menu', 
                      child: const Icon(Icons.menu, size: 35)),
                        onPressed: () {
                          setState(() {
                            lastPageIndex = selectedPageIndex;
                            undoStack.add(selectedPageIndex);
                            SemanticsService.announce('Menu page Loaded', TextDirection.ltr);
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
                      icon: Semantics(label: 'Settings', child: const Icon(Icons.settings, size: 35)),
                      onPressed: () {
                        setState(() {
                          if (selectedPageIndex != -1) {
                            lastPageIndex = selectedPageIndex;
                            undoStack.add(selectedPageIndex);
                            SemanticsService.announce('Settings page Loaded', TextDirection.ltr);
                          }
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
                Container(
                  color: selectedTheme.colorScheme.surface,
                  child: _buildPage(selectedPageIndex)
                ),
              ),
          ),
        );
  }


  Widget _buildPage(int pageIndex) {
    switch (pageIndex) {
      case -1:
        return Column(
          children: [
            Row(
              children: [
                ChangePageArrow( 
                  onPressed: () {
                    setState(() {
                      SemanticsService.announce('Settings page Loaded', TextDirection.ltr);
                      selectedPageIndex = lastPageIndex;
                    });
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).colorScheme.onSurface), 
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Expanded(
              child: Settings(
                onChangeFontSize: _handleFontSizeChange, 
                onLightModeChange: _handleLightModeChange,
                fontSize: _fontSizeFactor,
                lightMode: _lightMode,
              )
            )
          ]
        );
      case 0:
        return Column(
          children: [
            Row(
              children: [
                NavArrows(leftOnPressed: _onUndo,),
                const Expanded(child: SizedBox()),
              ],
            ),
            Expanded(
              child: Menu(
                pageTitles: menuPageTitles,
                pageIds: menuPageIds,
                selectedLanguage: selectedLanguage,
                onSelectPage: (pageId) {
                  setState(() {
                    lastPageIndex = selectedPageIndex;
                    undoStack.add(selectedPageIndex);
                    SemanticsService.announce('New page Loaded', TextDirection.ltr);
                    selectedPageIndex = pageIds.indexOf(pageId) + 1;
                  });
                },
              )
            )
          ]
        );
      default:
        return Column(
          children: [
            Row(
              children: [
                NavArrows(leftOnPressed: _onUndo,),
                const Expanded(child: SizedBox()),
              ],
            ),
            Expanded(
              child: CustomPage(
                content: pagesContents[selectedPageIndex - 1],
                title: pageTitles[selectedPageIndex - 1],
                language: selectedLanguage,
                onChangePage: (pageId) {
                    setState(() {
                      lastPageIndex = selectedPageIndex;
                      undoStack.add(selectedPageIndex);
                      SemanticsService.announce('New page Loaded', TextDirection.ltr);
                      selectedPageIndex = pageIds.indexOf(pageId) + 1;
                    });
                  },
              ),
            )
          ]
        );
    }
  }
}