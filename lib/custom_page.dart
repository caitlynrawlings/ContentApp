import 'package:flutter/material.dart';
import 'page_content.dart';
import 'heading.dart';
import 'subheading.dart';
import 'image_widget.dart';
import 'lang_dropdown.dart'; 

class CustomPage extends StatefulWidget {
  final List<dynamic> content;
  final Map<String, String> title;
  final String language;
  final Function(String) onLanguageChanged;
  final List<String> languages;

  CustomPage({
    Key? key,
    required this.content,
    required this.title,
    required this.language,
    required this.onLanguageChanged,
    required this.languages,
  }) : super(key: key);

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(widget.title[widget.language] ?? "No title translation found"),
        actions: [
          LanguageDropdown(
            selectedLanguage: widget.language,
            onLanguageChanged: widget.onLanguageChanged,
            languages: widget.languages,
          ),
        ],
      ),
      body: ListView(
        children: widget.content.map<Widget>((item) {
          return _buildContentWidget(item['content-type'], item['content'][widget.language]);
        }).toList(),
      ),
    );
  }

  Widget _buildContentWidget(String contentType, dynamic content) {
    switch (contentType.toLowerCase()) {
      case 'heading':
        return Heading(text: content);
      case 'subheading':
        return Subheading(text: content);
      case 'text':
        return Text(content);
      case 'image':
        return ImageWidget(imagePath: content['path'], altText: content['alt'] ?? 'No alt text provided');
      default:
        return Text('Unsupported content type: $contentType');
    }
  }
}
