import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class DownlineCard extends StatelessWidget {
  // Idealnya data di-pass melalui constructor tapi nanti
  // final DownlineModel data;

  const DownlineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: kNeutral30, width: 1),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha(75),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kOrange.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Y', //nanti buat fungsi buat ambil inisial
                    style: TextStyle(
                      color: kOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yeni',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: kNeutral90,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.copy_rounded, size: 12, color: kNeutral60),
                          const SizedBox(width: 4),
                          Text(
                            'SMS0795632',
                            style: TextStyle(
                              fontSize: 12,
                              color: kNeutral60,
                              fontFamily: 'Monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kGreen.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Aktif',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: kNeutral30),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatItem(
                        label: 'Sisa Saldo',
                        value: 'Rp 10.020.864',
                        valueColor: kNeutral90,
                        isCurrency: true,
                      ),
                      const SizedBox(height: 16),
                      StatItem(
                        label: 'Upline',
                        value: 'SMS0795632',
                        valueColor: kNeutral90,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  height: 60,
                  color: kNeutral30,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatItem(
                        label: 'Trx Sukses',
                        value: '500',
                        valueColor: kGreen,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),
                      StatItem(
                        label: 'Trx Gagal',
                        value: '3',
                        valueColor: kRed,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isCurrency;
  final bool isBold;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    this.isCurrency = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: kNeutral60,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold || isCurrency
                ? FontWeight.w700
                : FontWeight.w600,
            color: valueColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
