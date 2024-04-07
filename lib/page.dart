import 'package:flutter/material.dart';
import 'page_content.dart';

class CustomPage extends StatefulWidget {
  final List<PageContent> content;

  const CustomPage({
    Key? key,
    required this.content,
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
        title: Text('Page'),
      ),
      body: Column(
        children: [
          for (final item in widget.content)
            _buildContentWidget(item.contentType, item.value),
        ]
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
