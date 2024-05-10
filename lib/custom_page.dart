import 'package:flutter/material.dart';
import 'content_types/heading.dart';
import 'content_types/subheading.dart';
import 'content_types/image_widget.dart';
import 'content_types/audio_widget.dart';
import 'content_types/callout_widget.dart';
import 'content_types/link.dart';
import 'toggle_widget.dart';
class CustomPage extends StatefulWidget {
  final List<dynamic> content;
  final Map<dynamic, dynamic> title;
  final String language;
  final dynamic onChangePage;

  const CustomPage({
    super.key,
    required this.content,
    required this.title,
    required this.language,
    required this.onChangePage,
  });

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Focus(
                child: Text(
                  widget.title[widget.language] ?? "No title translation found",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
              child: Divider(
                color: Color.fromARGB(255, 205, 205, 205), // Customize divider color as needed
                height: 1, // Customize divider height as needed
                thickness: 1, // Customize divider thickness as needed
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ListView(
                  children: widget.content.map((item) {
                    dynamic contentType = item["content-type"];
                    dynamic content = item["content"];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Focus(child: _buildContentWidget(contentType, content[widget.language])),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        )
  );
}


  Widget _buildContentWidget(String contentType, dynamic value) {
    switch (contentType) {
      case 'Heading':
        return Heading(text: value);
      case 'Subheading':
        return Subheading(text: value);
      case 'Text':
        return Text(value);
      case 'Image':
        return ImageWidget(imagePath: value['path'], altText: value['alt'] ?? 'No alt text provided');
      case 'Audio':
        return AudioWidget(audioAsset: 'assets/downloads/${value['path']}');
      case 'Callout':
        return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0), 
            child: CalloutWidget(
            text: value['text'],
            iconPath: 'assets/downloads/${value['path']}', 
            ),
        );
      case 'Spacer':
        return value.runtimeType == String ? const SizedBox(height: 0) : SizedBox(height: value.toDouble());
      case 'Toggle':
        return ToggleWidget(title: value['title'], body: value['body']);
      case 'Link':
        return Link(
            displayText: value['displayText'], 
            linkedPageId: value['page'],
            onChangePage: (pageId) {
              widget.onChangePage(pageId);
            },
        );
      default:
        return Text('Unsupported content type: $contentType');
    }
  }
}
