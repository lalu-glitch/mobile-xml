import 'package:flutter/material.dart';

import '../../../data/models/user/user_balance.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import 'home_balance_carousel.dart';

class MainSaldoCardCarousel extends StatelessWidget {
  const MainSaldoCardCarousel({super.key, required this.balanceVM});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 220,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          padEnds: false,
          clipBehavior: Clip.none,
          // Item pertama adalah Saldo XML, sisanya dari ewallet
          itemCount: 1 + (balanceVM.userBalance?.ewallet?.length ?? 0),
          itemBuilder: (context, index) {
            // Tampilkan shimmer jika data belum siap
            if (balanceVM.isLoading || balanceVM.userBalance == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HomeBalanceCarousel(balanceVM: balanceVM),
              );
            }

            // Item pertama (index 0) adalah Saldo XML
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: HomeBalanceCarousel(balanceVM: balanceVM),
              );
            }

            // Item selanjutnya adalah e-wallet
            final EWallet ewallet = balanceVM.userBalance!.ewallet![index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: HomeBalanceCarousel(
                balanceVM: balanceVM,
                ewallet: ewallet,
              ),
            );
          },
        ),
      ),
    );
  }
}
