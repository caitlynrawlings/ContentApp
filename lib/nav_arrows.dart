

import 'package:content_app/change_page_arrow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavArrows extends StatelessWidget {
  final dynamic leftOnPressed;
  final dynamic rightOnPressed;

  const NavArrows({
    super.key, 
    required this.leftOnPressed,
    required this.rightOnPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChangePageArrow( 
          onPressed: leftOnPressed,
          icon: Icon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).colorScheme.onSurface), 
        ),
        ChangePageArrow( 
          onPressed: rightOnPressed,
          icon: Icon(FontAwesomeIcons.arrowRight, color: Theme.of(context).colorScheme.onSurface), 
        ),
      ],
    );
  }
}

