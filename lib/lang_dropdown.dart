import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String> onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged, 
    required this.languages,
  });

  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedLanguage,
      onChanged: (String? newLanguage) {
        widget.onChanged(newLanguage ?? widget.languages[0]);
      },
      items: widget.languages
          .map<DropdownMenuItem<String>>((dynamic language) {
            return DropdownMenuItem<String>(
              key: ValueKey(language),
              value: language,
              child: Text(language),
            );
          }).toList(),
    );
  }
}
