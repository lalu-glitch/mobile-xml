import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/dialog.dart';
import 'sp_info_card.dart';

class VASection extends StatelessWidget {
  const VASection({required this.kodeVA, required this.atasNama});
  final String kodeVA;
  final String atasNama;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: "Nomor Virtual Account",
      value: kodeVA,
      onCopy: () {
        Clipboard.setData(ClipboardData(text: kodeVA));
        showAppToast(
          context,
          'Nomor Virtual Account berhasil disalin',
          ToastType.complete,
        );
      },
      footer: "Atas nama: $atasNama",
    );
  }
}
