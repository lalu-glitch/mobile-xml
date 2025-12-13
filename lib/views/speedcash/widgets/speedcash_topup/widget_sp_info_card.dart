import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.value,
    this.footer,
    this.onCopy,
    this.additional,
    super.key,
  });

  final String title;
  final String value;
  final String? footer;
  final ValueChanged<String>? onCopy;
  final Map<String, String>? additional;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: kOrangeAccent300, width: 2),
        borderRadius: .circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const .all(16),
            width: double.infinity,
            color: kOrangeAccent300.withAlpha(50),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                buildRow(context, title, value, null),
                if (additional != null)
                  ...additional!.entries.map(
                    (e) => Padding(
                      padding: const .only(top: 8),
                      child: buildRow(
                        context,
                        e.key,
                        e.value,
                        onCopy != null ? () => onCopy!(e.value) : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const .all(12),
              child: Text(footer!, style: const TextStyle(color: kNeutral100)),
            ),
        ],
      ),
    );
  }

  Widget buildRow(
    BuildContext context,
    String label,
    String value,
    VoidCallback? copy,
  ) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(label, style: const TextStyle(color: kNeutral90, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  color: kBlack,
                  fontSize: 20,
                  fontWeight: .w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (copy != null)
              InkWell(
                onTap: copy,
                borderRadius: .circular(8),
                child: Container(
                  padding: const .symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: .circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.copy, size: 16, color: kNeutral80),
                      SizedBox(width: 6),
                      Text(
                        'Salin',
                        style: TextStyle(color: kNeutral100, fontWeight: .w600),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
