import 'package:flutter/material.dart';

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
        child: (balanceVM.isLoading || balanceVM.userBalance == null)
            // Jika loading atau data null, tampilkan satu SaldoCard dengan shimmer-nya
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: HomeBalanceCarousel(balanceVM: balanceVM),
              )
            // Jika data sudah ada, baru bangun PageView
            : PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                padEnds: true,
                clipBehavior: Clip.none,
                // Gunakan ?. dan ?? untuk keamanan
                itemCount: (balanceVM.userBalance?.ewallet?.length ?? 0),
                itemBuilder: (context, index) {
                  // TODO: Buat card terpisah untuk E-Wallet jika desainnya berbeda
                  // Untuk sekarang, kita tampilkan SaldoCard yang sama untuk semua
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: HomeBalanceCarousel(balanceVM: balanceVM),
                  );
                },
              ),
      ),
    );
  }
}
