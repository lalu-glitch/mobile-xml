import 'package:flutter/material.dart';

import '../helper/constant_finals.dart';

Widget infoRow(
  String label,
  String value, {
  bool isTotal = false,
  Color color = kOrange,
}) {
  return Row(
    crossAxisAlignment: .start,
    children: [
      Expanded(
        flex: 4,
        child: Text(
          label,
          style: TextStyle(color: kNeutral80, fontWeight: .w400),
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
          maxLines: 4,
          style: TextStyle(
            fontWeight: isTotal ? .bold : .w600,
            fontSize: isTotal ? kSize16 : kSize14,
            color: isTotal ? color : kBlack,
          ),
        ),
      ),
    ],
  );
}

List<Widget> buildDynamicInfoRows(Map<String, dynamic> fields) {
  final widgets = <Widget>[];

  fields.forEach((label, value) {
    final text = value?.toString().trim();

    if (text != null && text.isNotEmpty && text != "-") {
      widgets.add(infoRow(label, text));
      widgets.add(const Divider(height: 24));
    }
  });

  return widgets;
}
