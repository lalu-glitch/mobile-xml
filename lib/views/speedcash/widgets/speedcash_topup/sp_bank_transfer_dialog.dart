import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../cubit/request_topup_cubit.dart';
import 'sp_info_card.dart';

class BankTransferDialog extends StatelessWidget {
  const BankTransferDialog({required this.state, super.key});
  final RequestTopUpSuccess state;

  @override
  Widget build(BuildContext context) {
    final d = state.data;
    return AlertDialog(
      backgroundColor: kBackground,
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(Icons.warning_rounded, color: kRed, size: 60),
            const SizedBox(height: 16),
            const Text(
              'OPS!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: kBlack,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              d.message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kNeutral90,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            InfoCard(
              title: 'Bank',
              value: d.bank,
              footer: 'Atas nama: ${d.atasNama}',
              additional: {
                'Nomor Rekening': d.rekening,
                'Nominal transfer': CurrencyUtil.formatCurrency(
                  double.tryParse(d.nominal.toString()) ?? 0,
                ),
              },
              onCopy: (val) {
                if (val == d.rekening) {
                  Clipboard.setData(ClipboardData(text: val));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nomor rekening disalin')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Kembali',
            style: TextStyle(color: kNeutral90, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
