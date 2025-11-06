import 'package:flutter/material.dart';
import 'package:xmlapp/data/models/user/user_balance.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/shimmer.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import 'saldo_header_card.dart';

class HomeBalanceCarousel extends StatelessWidget {
  const HomeBalanceCarousel({required this.balanceVM, this.ewallet, super.key});

  final BalanceViewModel balanceVM;
  final EWallet? ewallet;

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
            child:
                (balanceVM.isLoading && ewallet == null) ||
                    balanceVM.userBalance == null
                ? ShimmerBox.buildMainShimmerCard()
                : ewallet != null
                ? HeaderSaldo(
                    title: ewallet!.nama,
                    balance: ewallet!.saldoEwallet,
                    themeColor: kBlue,
                  )
                : HeaderSaldo(
                    title: 'Saldo XML',
                    balance: balanceVM.userBalance?.saldo ?? 0,
                  ),
          ),
        );
      },
    );
  }
}
