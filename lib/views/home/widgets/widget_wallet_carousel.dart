import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../data/models/user/ewallet_model.dart';
import '../../../data/models/user/user_balance_model.dart';
import '../utils/wallet_color.dart';
import 'widget_wallet.dart';

class WalletCarousel extends StatelessWidget {
  const WalletCarousel({this.userBalance, this.ewallet, super.key});
  final UserBalance? userBalance;
  final Ewallet? ewallet;

  @override
  Widget build(BuildContext context) {
    // Penentuan Data
    final String code = ewallet?.kodeDompet ?? 'DEFAULT';
    final Color baseColor = walletColorMap[code] ?? kOrangeAccent400;

    final String title = ewallet?.namaEwallet ?? 'Saldo XML';
    final int balance = ewallet?.saldo ?? userBalance?.saldo ?? 0;

    // Logika Status: Apakah akun ini dianggap "Verified/Connected"?
    // Sesuaikan logika string 'VERIF' ini dengan backend Anda
    final bool isConnected = [
      'VERIF1',
      'VERIF2',
    ].contains(userBalance?.kodeLevel);

    // Flag khusus untuk Saldo XML
    final bool isXmlWallet = title == 'Saldo XML';

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: ModernWalletCard(
            title: title,
            balance: balance,
            themeColor: baseColor,
            isConnected: isConnected,
            isXmlWallet: isXmlWallet,
            onTopUpTap: () {
              // Navigasi Topup
              if (title.toLowerCase().contains('speedcash')) {
                Navigator.pushNamed(context, '/speedcashTopUpPage');
              }
            },
            onTransferTap: () {}, // Isi fungsi transfer
            onQrisTap: () {}, // Isi fungsi QRIS
            onConnectTap: () {},
          ),
        );
      },
    );
  }
}
