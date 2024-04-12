import 'package:flutter/material.dart';
import 'page_content.dart';

class CustomPage extends StatefulWidget {
  final List<Map<String, PageContent>> content;
  final Map<String, String> title;
  String language;

  CustomPage({
    Key? key,
    required this.content,
    required this.title,
    required this.language,
  }) : super(key: key);

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  bool overrideIndex = false;
  int selectedButtonIndex = 0; // Default value

  List<List<String>> languages = List.generate(3, (_) => <String>[]);
  // Change value to set aspect ratio
  final double _aspectRatio = 16 / 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title[widget.language] ?? "No title translation found"),
      ),
      body: Column(
        children: widget.content.map((item) {
          var contentTranslation = item[widget.language];
          if (contentTranslation != null) {
            return _buildContentWidget(contentTranslation.contentType, contentTranslation.value);
          } else {
            // Handle the case where contentTranslation is null
            return SizedBox(); // or any other widget or null
          }
        }).toList(),
      ),
    );
  }

  Widget _buildContentWidget(String contentType, dynamic value) {
    switch (contentType) {
      case 'header':
        return Text(value);
      case 'body':
        return Text(value);
      case 'image':
        return const Text('Image not supported yet');
      case 'video':
        return const Text('Video not supported yet');
      case 'audio':
        return const Text('Audio not supported yet');
      default:
        return Text('Unsupported content type: $contentType');
    }
  }
}
