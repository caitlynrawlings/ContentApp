import 'package:flutter/material.dart';

class IconSubheading extends StatelessWidget {
    final String iconPath;
    final String subheadingText;
    final String language;

    const IconSubheading({
        super.key,
        required this.iconPath,
        required this.subheadingText,
        required this.language,
    });

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
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                        effectiveText,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ),
            ],
        );
    }
}
