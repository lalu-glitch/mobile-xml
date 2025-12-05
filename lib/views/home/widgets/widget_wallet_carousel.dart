import 'package:flutter/material.dart';
import 'package:xmlapp/data/models/user/user_balance_model.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../data/models/user/ewallet_model.dart';
import '../utils/wallet_color.dart';
import 'widget_wallet.dart';

class WalletCarousel extends StatelessWidget {
  const WalletCarousel({this.userBalance, this.ewallet, super.key});
  final UserBalance? userBalance;
  final Ewallet? ewallet;

  @override
  Widget build(BuildContext context) {
    final String code = ewallet?.kodeDompet ?? '';
    final Color themeColor = walletColorMap[code] ?? kOrange;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: kWhite,
          child: Padding(
            padding: const .symmetric(horizontal: 16, vertical: 16),
            child: ewallet != null
                ? CardWallet(
                    title: ewallet!.namaEwallet,
                    balance: ewallet!.saldo,
                    themeColor: themeColor,
                    data: userBalance,
                  )
                : CardWallet(
                    title: 'Saldo XML',
                    balance: userBalance?.saldo ?? 0,
                    themeColor: kOrange,
                    data: userBalance,
                  ),
          ),
        );
      },
    );
  }
}
