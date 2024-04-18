import 'package:flutter/material.dart';
import 'page_content.dart';

class CustomPage extends StatefulWidget {
  final List<Map<String, PageContent>> content;
  final Map<String, String> title;
  String language;

  CustomPage({
    super.key,
    required this.content,
    required this.title,
    required this.language,
  });

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {

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
            return const SizedBox();
          }
        }).toList(),
      ),
    );
  }

  Widget _buildContentWidget(String contentType, dynamic value) {
    switch (contentType) {
      case 'Heading':
        return Text(value);
      case 'Subheading':
        return Text(value);
      case 'Text':
        return const Text('Image not supported yet');
      case 'Image':
        return const Text('Video not supported yet');
      case 'Audio':
        return const Text('Audio not supported yet');
      default:
        return Text('Unsupported content type: $contentType');
    }
  }
}
