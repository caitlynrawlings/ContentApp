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
    return Semantics(
      label: 'Dropdown menu for selecting language',
      child: Container(
        decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Color of the shadow
                  spreadRadius: -10, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: const Offset(0, 3), // Offset in x and y directions
                ),
              ],
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 5),
              DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.secondary,
                value: widget.selectedLanguage,
                onChanged: (String? newLanguage) {
                  widget.onChanged(newLanguage ?? widget.languages[0]);
                },
                items: widget.languages
                    .map<DropdownMenuItem<String>>((dynamic language) {
                      return DropdownMenuItem<String>(
                        key: ValueKey(language),
                        value: language,
                        child: Row(
                          children: [
                            Text(language, style: Theme.of(context).textTheme.labelLarge,),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
