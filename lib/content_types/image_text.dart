import 'package:flutter/material.dart';

class ImageTextWidget extends StatelessWidget {
  final String imagePath;
  final String altText;
  final String caption;
  final String text;
  final String imagePlacement;

  const ImageTextWidget({
    super.key,
    required this.imagePath,
    required this.altText,
    required this.caption,
    required this.text,
    required this.imagePlacement,
  });

  @override
  Widget build(BuildContext context) {
    bool isLeft = imagePlacement == "left";
    return Row(
      mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLeft) imageComponent(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        if (!isLeft) imageComponent(context),
      ],
    );
  }

  Widget imageComponent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Semantics(
          label: altText,
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Text(caption, style: Theme.of(context).textTheme.caption),
    ],
  );
}
