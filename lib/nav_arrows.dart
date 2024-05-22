

import 'package:content_app/change_page_arrow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavArrows extends StatelessWidget {
  final dynamic leftOnPressed;
  // TODO: add rightOnPressed

  const NavArrows({
    super.key, 
    required this.leftOnPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return ChangePageArrow( 
      onPressed: leftOnPressed,
      icon: Icon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).colorScheme.onSurface), 
    );
  }
}

