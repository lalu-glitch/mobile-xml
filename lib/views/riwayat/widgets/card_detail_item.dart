import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';

import '../../../core/utils/dialog.dart';

Widget buildInfoTile(
  BuildContext context, {
  required String label,
  required String? value,
  IconData leadingIcon = Icons.info_outline,
}) {
  return Card(
    color: kWhite,
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: kOrangeAccent500.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(leadingIcon, color: kOrange, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: kNiggaBlack,
        ),
      ),
      subtitle: Text(
        value ?? "-",
        style: const TextStyle(fontSize: 13, color: kBlack),
      ),
      trailing: IconButton(
        tooltip: "Copy",
        icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
        onPressed: () {
          if (value != null && value.isNotEmpty) {
            Clipboard.setData(ClipboardData(text: value));
            showAppToast(
              context,
              "Text berhasil di-copy: $value",
              ToastType.complete,
            );
          } else {
            showAppToast(context, "Gagal copy", ToastType.error);
          }
        },
      ),
    ),
  );
}
