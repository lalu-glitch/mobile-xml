import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../viewmodels/balance_viewmodel.dart';

class StokXMLHeader extends StatelessWidget {
  const StokXMLHeader({super.key, required this.balanceVM});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet, // ikon uang dompet
              color: kOrange,
              size: 28,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stok XML",
                  style: TextStyle(fontSize: 13.sp, color: kNeutral90),
                ),
                Text(
                  CurrencyUtil.formatCurrency(
                    balanceVM.userBalance?.saldo ?? 0,
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: kBlack,
                  ),
                ),
              ],
            ),
          ],
        ),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/webView',
              arguments: {
                'url': 'https://youtube.com',
                'title': 'Registrasi Speedcash',
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          icon: Icon(Icons.add_box, size: 24, color: kWhite),
          label: Text(
            "Isi Stok",
            style: TextStyle(
              color: kWhite,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
