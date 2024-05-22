import 'package:content_app/change_page_arrow.dart';
import 'package:content_app/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatelessWidget {
  final dynamic onBack;
  final Function(double) onChangeFontSize;
  final Function() onLightModeChange;
  final double fontSize;
  final bool lightMode;

  const Settings({
    super.key,
    required this.onBack,
    required this.onChangeFontSize, 
    required this.onLightModeChange, 
    required this.fontSize, 
    required this.lightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
          children: [
            Row(
              children: [
                ChangePageArrow( 
                  onPressed: onBack,
                  icon: Icon(FontAwesomeIcons.arrowLeft, color: Theme.of(context).colorScheme.onSurface), 
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            FontSizeDropdown(value: fontSize, onChanged: onChangeFontSize,),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            LightModeSwitch(value: lightMode, onChanged: onLightModeChange,),
        ]
      ),
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
    return Row(
      children: [
        Text("Aa", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppFontSizes.bodyLargeSize * 2)),
        const SizedBox(width: 5,),
        Text("Aa", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppFontSizes.bodyLargeSize * 1.5)),
        const SizedBox(width: 5,),
        Text("Aa", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppFontSizes.bodyLargeSize )),
        const SizedBox(width: 20,),
        DropdownButton<double>(
          dropdownColor: Theme.of(context).colorScheme.secondary,
          value: selectedValue,
          onChanged: (double? newSize) {
            if (newSize != null) {
              setState(() {
                selectedValue = newSize;
              });
              widget.onChanged?.call(newSize);
            }
          },
          items: [
            DropdownMenuItem(
              value: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('x1', style: Theme.of(context).textTheme.labelLarge,),
                  const SizedBox(width: 5,),
                  Text("Aa ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppFontSizes.bodyLargeSize)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('x1.5', style: Theme.of(context).textTheme.labelLarge,),
                  const SizedBox(width: 5,),
                  Text("Aa ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppFontSizes.bodyLargeSize * 1.5)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('x2', style: Theme.of(context).textTheme.labelLarge,),
                  const SizedBox(width: 5,),
                  Text("Aa ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: AppFontSizes.bodyLargeSize * 2)),
                ],
              ),
            ),
          ],
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
    return Row(
      children: [
        Icon(Icons.sunny, color: Theme.of(context).colorScheme.onPrimary,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Switch(
            value: selectedValue,
            inactiveTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) {
              setState(() {
                widget.onChanged.call();
                selectedValue = !selectedValue;
            });
          }),
        ),
        Icon(FontAwesomeIcons.solidMoon, color: Theme.of(context).colorScheme.onPrimary,),
      ],
    );
  }
}