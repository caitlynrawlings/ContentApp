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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            onChangePage(linkedPageId);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          child: Text(displayText, style: Theme.of(context).textTheme.labelLarge,),
        ),
      ]
    );
  }
}