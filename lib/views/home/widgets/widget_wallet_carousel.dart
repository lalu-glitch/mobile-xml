import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../data/models/user/ewallet_model.dart';
import '../../../data/models/user/user_balance_model.dart';
import '../utils/wallet_color.dart';
import 'widget_wallet.dart';

class WalletCarousel extends StatelessWidget {
  const WalletCarousel({this.userBalance, this.ewallet, super.key});
  final UserBalance? userBalance;
  final Ewallet? ewallet; // Asumsi model Ewallet punya field 'bind' (int)

  @override
  Widget build(BuildContext context) {
    // 1. Tentukan Identitas Wallet
    // Jika ewallet null, berarti ini kartu Saldo Utama (XML)
    final bool isXmlWallet =
        ewallet == null || ewallet?.namaEwallet == 'Saldo XML';

    final String title = isXmlWallet
        ? 'Saldo XML'
        : (ewallet?.namaEwallet ?? 'Unknown');
    final String code = ewallet?.kodeDompet ?? 'DEFAULT';

    // 2. Tentukan Saldo
    final int balance = isXmlWallet
        ? (userBalance?.saldo ?? 0)
        : (ewallet?.saldo ?? 0);

    // 3. Tentukan Warna
    final Color baseColor = walletColorMap[code] ?? kOrangeAccent500;

    final bool isConnected = isXmlWallet ? true : (ewallet?.bind == 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ModernWalletCard(
        title: title,
        balance: balance,
        themeColor: baseColor,
        isConnected: isConnected, // Mengirim status bind (1=true, 0=false)
        isXmlWallet: isXmlWallet,
        onTopUpTap: () {
          if (title.toLowerCase().contains('speedcash')) {
            Navigator.pushNamed(context, '/speedcashTopUpPage');
          }
        },
        // Callback lain bisa diisi sesuai kebutuhan
        onTransferTap: () {},
        onQrisTap: () {},
        onConnectTap: () {
          if (title.toLowerCase().contains('speedcash')) {
            Navigator.pushNamed(context, '/speedcashBindingPage');
          }
        },
      ),
    );
  }
}
