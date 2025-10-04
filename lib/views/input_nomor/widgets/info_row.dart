import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

Widget infoRow(String label, String value, {bool isTotal = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 6,
        child: Text(
          value,
          textAlign: TextAlign.right,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? Screen.kSize16 : Screen.kSize14,
            color: isTotal ? kOrange : Colors.black,
          ),
        ),
      ),
    ],
  );
}
