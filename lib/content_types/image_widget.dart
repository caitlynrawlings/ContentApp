import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final dynamic imagePath;
  final dynamic altText;
  final dynamic caption; 

  const ImageWidget({
    super.key,
    required this.imagePath,
    required this.altText,
    this.caption, 
  });

  @override
  Widget build(BuildContext context) {
    String fullPath = 'assets/downloads/$imagePath';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9, 
          child: Image.asset(
            fullPath,
            key: Key(fullPath),
            semanticLabel: altText,
            width: double.infinity,
            fit: BoxFit.contain, 
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Text(altText.isNotEmpty ? altText : 'Image could not be loaded');
            },
          ),
        ),
        if (caption != null && caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              caption,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
