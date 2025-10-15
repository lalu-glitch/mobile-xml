import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: kNeutral90,
            ),
          ),
        ),
      ],
    );
  }
}
