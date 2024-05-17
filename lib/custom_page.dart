import 'package:flutter/material.dart';
import 'content_types/body_text.dart';
import 'content_types/heading.dart';
import 'content_types/subheading.dart';
import 'content_types/image_widget.dart';
import 'content_types/audio_widget.dart';
import 'content_types/callout_widget.dart';
import 'content_types/link.dart';
import 'content_types/toggle_widget.dart';
import 'content_types/icon_subheading.dart';

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
  List<dynamic> processedContent = [];

  @override
  void initState() {
    super.initState();
    processContent();
  }

  @override
  void didUpdateWidget(covariant CustomPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content || oldWidget.title != widget.title || oldWidget.language != widget.language) {
      processContent();
    }
  }

  void processContent() {
    List<dynamic> newProcessedContent = [];

    for (int i = 0; i < widget.content.length; i++) {
      dynamic item = deepCopyMap(widget.content[i]);
      dynamic contentType = item["content-type"];
      if (contentType == "Link") {
        dynamic content = item["content"];
        dynamic newContent = {};
        content.forEach((languageKey, value) {
          dynamic linkArray = [value];
          newContent[languageKey] = linkArray;
        });
        for (int j = i + 1; j < widget.content.length; j++) {
          dynamic nextItem = deepCopyMap(widget.content[j]);
          dynamic contentType = nextItem["content-type"];
          if ((contentType == "Link")) {
            dynamic linkContent = nextItem["content"];
            linkContent.forEach((languageKey, value) {
              dynamic linkArray = newContent[languageKey];
              linkArray += [value];
              newContent[languageKey] = linkArray;
            });
            i++;
          } else {
            break;
          }
        }
        item['content'] = newContent;
        item['content-type'] = 'Links';
      }
      newProcessedContent.add(item);
    }

    setState(() {
      processedContent = newProcessedContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
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
                color: Color.fromARGB(255, 205, 205, 205),
                height: 1,
                thickness: 1,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ListView(
                  children: processedContent.map((item) {
                    dynamic contentType = item["content-type"];
                    dynamic content = item["content"];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Focus(
                        child: _buildContentWidget(contentType, content[widget.language]),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentWidget(String contentType, dynamic value) {
    switch (contentType) {
      case 'Heading':
        return Heading(text: value);
      case 'Subheading':
        return Subheading(text: value);
      case 'Text':
        return BodyText(text: value);
      case 'Image':
        return ImageWidget(imagePath: value['path'], altText: value['alt'] ?? 'No alt text provided');
      case 'Audio':
        return AudioWidget(
          audioAsset: 'assets/downloads/${value['path']}',
          transcript: value['caption'] ?? 'No transcript available',
        );
      case 'Callout':
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CalloutWidget(
            text: value['text'],
            iconPath: 'assets/downloads/${value['path']}',
          ),
        );
      case 'Spacer':
        return value.runtimeType == String ? const SizedBox(height: 0) : SizedBox(key: ValueKey("spacer$value"), height: value.toDouble());
      case 'IconSubheading':
        if (value is Map && value.containsKey('path') && value.containsKey('subheading')) {
          return IconSubheading(
            iconPath: value['path'] ?? '',
            subheadingText: value['subheading'] ?? 'No subheading available',
            language: widget.language,
          );
        } else {
          return Text("Incorrect data for IconSubheading");
        }
      case 'Toggle':
        return ToggleWidget(title: value['title'], body: value['body']);
      case 'Links':
        return Wrap(
          children: value.map<Widget>((link) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Link(
                    displayText: link['displayText'],
                    linkedPageId: link['page'],
                    onChangePage: (pageId) {
                      widget.onChangePage(pageId);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      default:
        return Text(
          'Unsupported content type: $contentType',
          style: Theme.of(context).textTheme.bodyLarge,
        );
    }
  }
}

Map<String, dynamic> deepCopyMap(Map<String, dynamic> original) {
  Map<String, dynamic> copy = {};
  original.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      copy[key] = deepCopyMap(value);
    } else if (value is List) {
      copy[key] = deepCopyList(value);
    } else {
      copy[key] = value;
    }
  });
  return copy;
}

List<dynamic> deepCopyList(List<dynamic> original) {
  return original.map((element) {
    if (element is Map<String, dynamic>) {
      return deepCopyMap(element);
    } else if (element is List) {
      return deepCopyList(element);
    } else {
      return element;
    }
  }).toList();
}
