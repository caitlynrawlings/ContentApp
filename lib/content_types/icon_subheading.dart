import 'package:flutter/material.dart';

class IconSubheading extends StatelessWidget {
    final String iconPath;
    final String subheadingText;
    final String language;

    const IconSubheading({
        Key? key,
        required this.iconPath,
        required this.subheadingText,
        required this.language,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        String effectivePath = iconPath.isNotEmpty ? 'assets/downloads/$iconPath' : 'assets/downloads/info_icon.png';
        String effectiveText = subheadingText.isNotEmpty ? subheadingText : 'Default Subheading';

        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Image.asset(
                    effectivePath,
                    width: 30,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                        effectiveText,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ),
            ],
        );
    }
}
