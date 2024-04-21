import 'package:flutter/material.dart';
class LanguageDropdown extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;
  final List<String> languages;

  const LanguageDropdown({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.languages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (String? newValue) {
        onLanguageChanged(newValue!);
      },
      items: languages.map<DropdownMenuItem<String>>((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
    );
  }
}
