import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String displayText;
  final String linkedPageId;
  final dynamic onChangePage;

  const Link({
    super.key,
    required this.displayText, 
    required this.linkedPageId, 
    required this.onChangePage,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onChangePage(linkedPageId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(displayText, style: Theme.of(context).textTheme.labelLarge,),
      ),
    );
  }
}
