import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String text;

  const Heading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.displayMedium,
    );
  }
}