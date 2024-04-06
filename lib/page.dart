import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  final List<String> content;

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
    String firstString = widget.content.isNotEmpty ? widget.content[0] : '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Page'),
      ),
      body: Center(
        child: Text(firstString),
      ),
    );
  }
}
