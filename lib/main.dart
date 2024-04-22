// import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// import 'custom_page.dart';
// import 'page_content.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;


// int selectedPageIndex = 0;  // tracks which page is being displayed. 0 is menu page and increments from that in order of pages added
// String selectedLanguage = "";  // tracks current language

// // for storing data once parsed from json
// var languages = [];
// var pageTitles = <Map<String, String>>[];
// var pagesContents = <List<Map<String, PageContent>>>[];

// // loads the app content data from the json file into data structures
// Future<void> loadJsonData() async {
//     // Load the JSON file
//     String jsonData = await rootBundle.loadString('assets/test_content.json');
      
//     // Parse the JSON string
//     Map<String, dynamic> data = json.decode(jsonData);
      
//     // Get language options for the app and sets current language
//     for (var language in data["languages"]) {
//       languages.add(language.toString());
//     }
//     selectedLanguage = languages[0];

//     for (var page in data["pages"]) {
//       Map<String, dynamic> pageInfo = page as Map<String, dynamic>;  // title and content as keys

//       // Check if 'title' is a list or a map
//       dynamic titleData = pageInfo["title"];

//       if (titleData is List) {
//         // Handle if 'title' is a list
//         Map<String, String> titleMap = {};
//         for (int i = 0; i < languages.length && i < titleData.length; i++) {
//           if (titleData[i] is String) {
//             titleMap[languages[i]] = titleData[i] as String;
//           }
//         }
//         pageTitles.add(titleMap);
//       } else if (titleData is Map<String, dynamic>) {
//         // Handle if 'title' is a map
//         pageTitles.add(titleData.cast<String, String>());
//       }

//       // Check if 'title' is a list or a map
//       dynamic contentData = pageInfo["content"];  // content data on one page

//       if (contentData is List) {
//         // Handle if 'content' is a list
//         List<Map<String, PageContent>> onePageContents = [];
//         for (int i = 0; i < contentData.length && i < contentData.length; i++) {
//           Map<String, dynamic> peiceOfContent = contentData[i] as Map<String, dynamic>;
//           dynamic contentType = peiceOfContent["content-type"] as String;
//           Map<String, dynamic> contentValue = peiceOfContent["content"];
//           Map<String, String> parsedContentValue = {}; // language to content value in that language map
//           parsedContentValue = contentValue.map((key, value) => MapEntry(key, value.toString()));
//           Map<String, PageContent> pageContentsEntry = {};
//           for (var item in parsedContentValue.entries) {
//             String language = item.key;
//             String contentTranslation = item.value;
//             pageContentsEntry[language] = PageContent(contentType: contentType, value: contentTranslation);
//           }
//           onePageContents += [pageContentsEntry];
//         }
//         pagesContents += [onePageContents];
//       } else if (contentData is Map<String, dynamic>) {
//         // Handle if 'title' is a map
//         break;
//       }


//     }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await loadJsonData();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Content App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 70, 70, 70)),
//         useMaterial3: true,
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(
//             fontSize: 72,
//             fontWeight: FontWeight.bold,
//           ),
//           // ···
//           titleLarge: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//           headlineLarge: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//           headlineMedium: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//           ),
          
//         ),
//       ),
//       home: const MyHomePage(title: 'Content App Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   final String title;

//   const MyHomePage({super.key, required this.title});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).primaryColor,
//             leading: IconButton(
//               icon: const Icon(Icons.home),
//               onPressed: () {
//                 setState(() {
//                   selectedPageIndex = 0;
//                 });
//               },
//             ),
//             title: Row(
//               children: [
//                 Text('Content App: $selectedLanguage'),
//               ],
//             ),
//           ),
//           body: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     LanguageDropdown(
//                       key: const ValueKey('languageDropdown'),
//                       selectedLanguage: selectedLanguage,
//                       onChanged: (String newLanguage) {
//                         setState(() {
//                           selectedLanguage = newLanguage;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: selectedPageIndex == 0
//                     ? Center(
//                         child: MenuPage(
//                           pageTitles: pageTitles,
//                           onSelectPage: (index) {
//                             setState(() {
//                               selectedPageIndex = index + 1;
//                             });
//                           },
//                         ),
//                       )
//                     : CustomPage(
//                         content: pagesContents[selectedPageIndex - 1],
//                         title: pageTitles[selectedPageIndex - 1],
//                         language: selectedLanguage,
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class MenuPage extends StatelessWidget {
//   final List<Map<String, String>> pageTitles;
//   final Function(int) onSelectPage;

//   const MenuPage({
//     super.key,
//     required this.pageTitles,
//     required this.onSelectPage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: pageTitles.length,
//       itemBuilder: (context, index) {
//         return PageButton(
//           pageLabel: pageTitles[index][selectedLanguage] ?? "Page not available in $selectedLanguage",
//           onPressed: () {
//             onSelectPage(index);
//           },
//         );
//       },
//     );
//   }
// }

// class PageButton extends StatelessWidget {
//   final String pageLabel;
//   final VoidCallback onPressed;

//   const PageButton({
//     super.key,
//     required this.pageLabel,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textStyle = theme.textTheme.headlineSmall!.copyWith(
//       color: const Color.fromARGB(255, 0, 0, 0), // theme.colorScheme.onPrimary,
//     );

//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: Color.fromARGB(255, 205, 205, 205), // Specify border color here
//                 width: 1.0, // Specify border width here
//               ),
//             ),
//           ),
//           child: TextButton(
//             onPressed: onPressed,
//             style: TextButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0), // Adjust the value as needed
//                 ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 10.0),
//               child: Text(
//                 pageLabel,
//                 style: textStyle,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class LanguageDropdown extends StatefulWidget {
//   final String selectedLanguage;
//   final ValueChanged<String> onChanged;

//   const LanguageDropdown({
//     super.key,
//     required this.selectedLanguage,
//     required this.onChanged,
//   });

//   @override
//   LanguageDropdownState createState() => LanguageDropdownState();
// }

// class LanguageDropdownState extends State<LanguageDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: widget.selectedLanguage,
//       onChanged: (String? newLanguage) {
//         widget.onChanged(newLanguage ?? languages[0]);
//       },
//       items: languages
//           .map<DropdownMenuItem<String>>((dynamic language) {
//             return DropdownMenuItem<String>(
//               key: ValueKey(language),
//               value: language,
//               child: Text(language),
//             );
//           }).toList(),
//     );
//   }
// }


// reading from pages.json 
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'custom_page.dart';
import 'lang_dropdown.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Content App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> pages = [];
  List<String> languages = [];
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString('assets/pages.json');
    final data = json.decode(jsonData);
    setState(() {
      languages = List<String>.from(data['languages']);
      selectedLanguage = languages[0];
      pages = data['pages'];
    });
  }

  void _handleLanguageChange(String newLanguage) {
    setState(() {
      selectedLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content Viewer: $selectedLanguage'),
        actions: [
          LanguageDropdown(
            selectedLanguage: selectedLanguage,
            onLanguageChanged: _handleLanguageChange,
            languages: languages,
          ),
        ],
      ),
      body: pages.isEmpty
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pages[index]['title'][selectedLanguage] ?? 'No title'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CustomPage(
                    //       content: pages[index]['content'],
                    //       title: Map<String, String>.from(pages[index]['title']),
                    //       language: selectedLanguage,
                    //     ),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomPage(
                        content: pages[index]['content'],
                        title: Map<String, String>.from(pages[index]['title']),
                        language: selectedLanguage,
                        onLanguageChanged: _handleLanguageChange,
                        languages: languages,
                      ),
                    ),
                  );
                  },
                );
              },
            ),
    );
  }
}


