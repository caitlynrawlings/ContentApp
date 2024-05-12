import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final Function(double) onChangeFontSize;
  final Function() onLightModeChange;
  final double fontSize;
  final bool lightMode;

  const Settings({
    super.key,
    required this.onChangeFontSize, 
    required this.onLightModeChange, 
    required this.fontSize, 
    required this.lightMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          ListTile(
            title: const Text('Font Size Selector'),
            trailing: FontSizeDropdown(value: fontSize, onChanged: onChangeFontSize,),
          ),
          ListTile(
            title: const Text('Light Mode Selector'),
            trailing: LightModeSwitch(value: lightMode, onChanged: onLightModeChange,),
          ),
      ]
    );
  }
}

class FontSizeDropdown extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const FontSizeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  _FontSizeDropdownState createState() => _FontSizeDropdownState();
}

class _FontSizeDropdownState extends State<FontSizeDropdown> {
  late double selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<double>(
      value: selectedValue,
      onChanged: (double? newSize) {
        if (newSize != null) {
          setState(() {
            selectedValue = newSize;
          });
          widget.onChanged?.call(newSize);
        }
      },
      items: const [
        DropdownMenuItem(
          value: 1,
          child: Text('Small'),
        ),
        DropdownMenuItem(
          value: 1.5,
          child: Text('Medium'),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('Large'),
        ),
      ],
    );
  }
}

class LightModeSwitch extends StatefulWidget {
  final bool value;
  final Function onChanged;

  const LightModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  _LightModeSwitchState createState() => _LightModeSwitchState();
}

class _LightModeSwitchState extends State<LightModeSwitch> {
  late bool selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          widget.onChanged.call();
      });
    });
  }
}