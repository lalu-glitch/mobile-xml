import 'package:flutter/material.dart';
import 'package:xmlapp/core/helper/currency.dart';

import '../../../../../core/helper/constant_finals.dart';
import '../../../../../data/models/mitra/mitra_model.dart';

class DownlineCard extends StatelessWidget {
  final Mitra mitra;

  const DownlineCard({super.key, required this.mitra});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: kNeutral30, width: 1),
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
                  child: Text(
                    mitra.initials,
                    style: const TextStyle(
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
                      Text(
                        mitra.nama,
                        style: const TextStyle(
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
                            mitra.kode,
                            style: const TextStyle(
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
                        value: CurrencyUtil.formatCurrency(mitra.saldo),
                        valueColor: kNeutral90,
                        isCurrency: true,
                      ),
                      const SizedBox(height: 16),
                      StatItem(
                        label: 'Upline',
                        value: mitra.kode,
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
                        value: mitra.trxSukses.toString(),
                        valueColor: kGreen,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),
                      StatItem(
                        label: 'Trx Gagal',
                        value: mitra.trxGagal.toString(),
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
