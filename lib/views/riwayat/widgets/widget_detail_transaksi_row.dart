import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';

class DetailRiwayatTransaksiRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool canCopy;
  final bool isHighlighted;

  const DetailRiwayatTransaksiRow({
    super.key,
    required this.label,
    required this.value,
    this.canCopy = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: kNeutral80, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: canCopy
                  ? () {
                      Clipboard.setData(ClipboardData(text: value!));
                      showAppToast(
                        context,
                        '$label berhasil disalin',
                        ToastType.success,
                      );
                    }
                  : null,
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  Flexible(
                    child: Text(
                      value!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: isHighlighted ? kBlack : kBlack,
                        fontWeight: isHighlighted ? .w900 : .w600,
                        fontSize: isHighlighted ? 15 : 14,
                        fontFamily: isHighlighted ? 'Monospace' : null,
                      ),
                    ),
                  ),
                  if (canCopy) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.copy_rounded, size: 14, color: kOrange),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
