import 'package:flutter/material.dart';

class Subheading extends StatelessWidget {
  final String text;

  const Subheading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.displaySmall,
    );
  }
}