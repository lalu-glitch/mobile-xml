import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helper/constant_finals.dart';

class TransaksiDetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool canCopy;

  const TransaksiDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.canCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: kGrey, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: canCopy
                  ? () {
                      Clipboard.setData(ClipboardData(text: value!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$label berhasil disalin'),
                          duration: const Duration(seconds: 1),
                        ),
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
                      style: const TextStyle(
                        color: kBlack,
                        fontWeight: .w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (canCopy) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.copy_rounded, size: 14, color: kNeutral50),
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
