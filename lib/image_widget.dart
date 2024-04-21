import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  final String altText;

  const ImageWidget({
    super.key,
    required this.imagePath,
    required this.altText,
  });

  @override
  Widget build(BuildContext context) {
    // all imgs should be in assets folder then 
    String fullPath = 'assets/$imagePath';
    return Image.asset(
      fullPath,
      key: Key(fullPath),
      semanticLabel: altText,
      width: double.infinity, // size should be adjusted depending???
      fit: BoxFit.cover, // size should be adjusted depending???
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Text(altText.isNotEmpty ? altText : 'Image could not be loaded');
      },
    );
  }
}
