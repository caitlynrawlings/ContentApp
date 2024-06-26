import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final List<dynamic> pageTitles;
  final List<dynamic> pageIds;
  final String selectedLanguage;
  final Function(String) onSelectPage;

  const Menu({
    super.key,
    required this.pageTitles,
    required this.pageIds,
    required this.onSelectPage, 
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pageTitles.length,
      itemBuilder: (context, index) {
        return PageButton(
          key: ValueKey("Page$index"),
          pageLabel: pageTitles[index][selectedLanguage] ?? "Page not available in $selectedLanguage",
          onPressed: () {
            onSelectPage(pageIds[index]);
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
    final textStyle = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onSurface,
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 205, 205, 205),
                width: 1.0,
              ),
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
              child: Text(
                pageLabel,
                style: textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}