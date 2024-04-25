import 'package:flutter/material.dart';
import 'image_widget.dart';

class ContentScreen extends StatelessWidget {
  final Map<String, dynamic> contentData;
  final String language;

  const ContentScreen({super.key, required this.contentData, required this.language});

  @override
  Widget build(BuildContext context) {
    List<Widget> contentWidgets = contentData['content'].map<Widget>((contentItem) {
      if (contentItem['content-type'] == 'image') {
        var imageData = contentItem['content'][language];
        return ImageWidget(imagePath: imageData['path'], altText: imageData['alt'] ?? '');
      } else {
        var textData = contentItem['content'][language];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(textData),
        );
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(contentData['title'][language] ?? 'Content Page'),
      ),
      body: ListView(children: contentWidgets),
    );
  }
}
