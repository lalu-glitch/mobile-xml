import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../core/utils/dialog.dart';

class CopyableAmount extends StatelessWidget {
  final dynamic amount; // num or string

  const CopyableAmount({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: amount.toString()));
        showAppToast(context, 'Nominal disalin', ToastType.success);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            CurrencyUtil.formatCurrency(amount),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: kOrange,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.copy_rounded, color: kNeutral50, size: 20),
        ],
      ),
    );
  }
}

class CopyableRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const CopyableRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kBlack,
            fontSize: 14,
            fontWeight: .w500,
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            showAppToast(context, "Berhasil Disalin", ToastType.success);
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 4),
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: kBlack,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.copy, size: 14, color: kOrange),
                const SizedBox(width: 4),
                const Text(
                  "Salin",
                  style: TextStyle(
                    color: kOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
