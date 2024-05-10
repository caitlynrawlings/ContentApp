
import 'package:flutter/material.dart';

class CalloutWidget extends StatelessWidget {
  final String text;
  final String? iconPath; // Path to the icon image
  final Color iconColor;

  const CalloutWidget({
    super.key,
    required this.text,
    this.iconPath, 
    this.iconColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconPath != "")
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  iconColor, 
                  BlendMode.srcIn, 
                ),
                child: Image.asset(iconPath!, width: 24, height: 24),
              ),
            )
          else
            Icon(Icons.lightbulb_outline, color: iconColor, size: 24.0), 
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
