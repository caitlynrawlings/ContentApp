import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String displayText;
  final String linkedPageId;
  final dynamic onChangePage;

  const Link({
    super.key,
    required this.displayText, 
    required this.linkedPageId, required this.onChangePage,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () {
        onChangePage(linkedPageId);
      },
      child: Text(displayText),
    );
  }
}