import 'package:flutter/material.dart';
import 'page.dart';

const pages = ["What are my options?", "What will happen to my period?"];

void main() {
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
            title: const Text('Family Planning Guide'),
          ),
          body: Column(
            children: [
              Expanded(
                child: selectedIndex == 0
                    ? Center(
                        child: MyMenuPage(
                          pages: pages,
                          onSelectPage: (index) {
                            setState(() {
                              selectedIndex = index + 1;
                            });
                          },
                        ),
                      )
                    : CustomPage(
                        content: ['Content of Page $selectedIndex'],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyMenuPage extends StatelessWidget {
  final List<String> pages;
  final Function(int) onSelectPage;

  const MyMenuPage({
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
