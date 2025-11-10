import 'package:flutter/material.dart';
import 'package:xmlapp/data/models/user/user_balance.dart';
import '../../../core/helper/constant_finals.dart';
import 'saldo_header_card.dart';

class HomeBalanceCarousel extends StatelessWidget {
  const HomeBalanceCarousel({this.userBalance, this.ewallet, super.key});
  final UserBalance? userBalance;
  final BalanceWallet? ewallet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: kWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ewallet != null
                ? HeaderSaldo(
                    title: ewallet!.nama,
                    balance: ewallet!.saldoEwallet,
                    themeColor: kBlue,
                  )
                : HeaderSaldo(
                    title: 'Saldo XML',
                    balance: userBalance?.saldo ?? 0,
                  ),
          ),
        );
      },
    );
  }
}
