import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ActionItem({
    super.key,
    required this.icon,
    required this.label,
    this.color = kOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        Container(
          padding: const .all(4),
          decoration: BoxDecoration(color: color, borderRadius: .circular(8)),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: .w400,
              color: kNeutral90,
            ),
          ),
        ),
      ],
    );
  }
}
