import 'package:flutter/cupertino.dart';

class TextSwitch extends StatefulWidget {
  final String label;
  final ValueChanged<bool> onTap;
  final bool initial;

  const TextSwitch({
    super.key,
    required this.label,
    required this.onTap,
    this.initial = false,
  });

  @override
  State<TextSwitch> createState() => _TextSwitchState();
}

class _TextSwitchState extends State<TextSwitch> {
  late bool isActive = widget.initial;

  void onChanged(bool value) {
    setState(() => isActive = value);
    widget.onTap(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.label),
                  CupertinoSwitch(value: isActive, onChanged: onChanged)
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
