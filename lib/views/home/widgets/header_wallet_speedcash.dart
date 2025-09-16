import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../viewmodels/balance_viewmodel.dart';

class SpeedCashWalletHeader extends StatelessWidget {
  const SpeedCashWalletHeader({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    final hasSpeedcash = balanceVM.userBalance?.ewallet.isNotEmpty ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Bagian kiri (ikon + saldo)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.blue,
              size: 28,
            ),
            const SizedBox(width: 8),

            // Informasi saldo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Saldo Speedcash",
                  style: TextStyle(fontSize: Screen.kSize14, color: kNeutral90),
                ),
                if (hasSpeedcash)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: balanceVM.userBalance!.ewallet.map<Widget>((ew) {
                      return Text(
                        CurrencyUtil.formatCurrency(ew.saldoEwallet),
                        style: TextStyle(
                          fontSize: Screen.kSize16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    "Tidak terhubung",
                    style: TextStyle(
                      fontSize: Screen.kSize14,
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                    ),
                  ),
              ],
            ),
          ],
        ),

        // Tombol kanan
        ElevatedButton.icon(
          onPressed: () {
            if (hasSpeedcash) {
              // kalau sudah ada Speedcash → ke halaman deposit
              Navigator.pushNamed(context, '/speedcashDepositPage');
            } else {
              // kalau belum ada Speedcash → ke halaman aktifkan Speedcash
              Navigator.pushNamed(context, '/speedcashBindingPage');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          icon: Icon(
            hasSpeedcash ? Icons.add_box : Icons.link_rounded,
            size: 20,
            color: kWhite,
          ),
          label: Text(
            hasSpeedcash ? "Deposit" : "Hubungkan",
            style: TextStyle(
              color: kWhite,
              fontSize: Screen.kSize12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
