import 'package:flutter/material.dart';
import 'heading.dart';
import 'subheading.dart';
import 'image_widget.dart';

class CustomPage extends StatefulWidget {
  final List<dynamic> content;
  final Map<dynamic, dynamic> title;
  final String language;

  const CustomPage({
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
    body: 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                widget.title[widget.language] ?? "No title translation found",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
                  children: widget.content.map((item) {//return Text(item.toString());
                    dynamic contentType = item["content-type"];
                    dynamic content = item["content"];
                    //return Text(contentType + content[widget.language].toString());
                    return _buildContentWidget(contentType, content[widget.language]);
                    // if (contentTranslation != null) {
                    //   return _buildContentWidget(contentTranslation.contentType, contentTranslation.value);
                    // } else {
                    //   return const SizedBox();
                    // }
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
        return const Text('Audio not supported yet');
      default:
        return Text('Unsupported content type: $contentType');
    }
  }
}