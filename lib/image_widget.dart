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
    String fullPath = 'assets/$imagePath';
    return AspectRatio(
      aspectRatio: 16 / 9, // Adjust the aspect ratio according to your needs
      child: Image.asset(
        fullPath,
        key: Key(fullPath),
        semanticLabel: altText,
        width: double.infinity,
        fit: BoxFit.contain,  // Changed to contain to see entire image
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Text(altText.isNotEmpty ? altText : 'Image could not be loaded');
        },
      ),
    );
  }
}

