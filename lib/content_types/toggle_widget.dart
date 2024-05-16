import 'package:flutter/material.dart';

class ToggleWidget extends StatefulWidget {
  final String title;
  final String body;
  const ToggleWidget({super.key, required this.title, required this.body});

  @override
  _ToggleWidgetState createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle the state
            });
          },
          child: Row(
            children: [
              
              AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                turns: _isExpanded ? 0.0 : -0.5,  
                child: Icon(
                  Icons.arrow_drop_down,  
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
            child: Text(widget.body, style: Theme.of(context).textTheme.bodyLarge),
          ),
      ],
    );
  }
}
