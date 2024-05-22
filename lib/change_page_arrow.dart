

import 'package:flutter/material.dart';

class ChangePageArrow extends StatelessWidget {
  final dynamic onPressed;
  final Icon icon;

  const ChangePageArrow({
    super.key, 
    required this.onPressed, 
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: icon
      ),
    );
  }
}

