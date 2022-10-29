import 'package:flutter/material.dart';

import '../../styles.dart';

class BaseSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const BaseSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: Styles.textLight.withOpacity(0.5))),
          SizedBox(
            height: 30,
            child: Slider(
              label: '$label: ${(value * 100).round().toString()}%',
              onChanged: onChanged,
              value: value,
              min: 0,
              max: 2,
            ),
          ),
        ],
      ),
    );
  }
}
