import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: kWhite,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(label: 'Batal', color: kBlack, onPressed: () {}),
        const SizedBox(width: 12),
        ActionButton(
          label: 'Konfirmasi',
          color: kOrange,
          onPressed: () {
            // TODO: Konfirmasi aksi
          },
        ),
      ],
    );
  }
}
