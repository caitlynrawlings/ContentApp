import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final List<dynamic> pageTitles;
  final String selectedLanguage;
  final Function(int) onSelectPage;

  const Menu({
    super.key,
    required this.pageTitles,
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
    final textStyle = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onBackground,
                width: 1.0,
              ),
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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