import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/dialog.dart';
import 'widget_sp_info_card.dart';

class VASection extends StatelessWidget {
  const VASection({required this.kodeVA, required this.atasNama, super.key});
  final String kodeVA;
  final String atasNama;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: "Nomor Virtual Account",
      value: kodeVA,
      onCopy: (value) {
        Clipboard.setData(ClipboardData(text: value));
        showAppToast(context, "Nomor VA berhasil disalin", ToastType.success);
      },
      footer: "Atas nama: $atasNama",
    );
  }
}
