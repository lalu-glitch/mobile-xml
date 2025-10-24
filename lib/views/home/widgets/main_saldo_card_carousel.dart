import 'package:flutter/material.dart';

import '../../../data/models/user/user_balance.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import 'home_balance_carousel.dart';
import '../../../core/helper/constant_finals.dart'; // Import kOrange

class MainSaldoCardCarousel extends StatefulWidget {
  // Changed to StatefulWidget
  const MainSaldoCardCarousel({super.key, required this.balanceVM});

  final BalanceViewModel balanceVM;

  @override
  State<MainSaldoCardCarousel> createState() => _MainSaldoCardCarouselState();
}

class _MainSaldoCardCarouselState extends State<MainSaldoCardCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount =
        1 + (widget.balanceVM.userBalance?.ewallet?.length ?? 0);

    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              clipBehavior: Clip.none,
              // Item pertama adalah Saldo XML, sisanya dari ewallet
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Tampilkan shimmer jika data belum siap
                if (widget.balanceVM.isLoading ||
                    widget.balanceVM.userBalance == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: HomeBalanceCarousel(balanceVM: widget.balanceVM),
                  );
                }

                // Item pertama (index 0) adalah Saldo XML
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: HomeBalanceCarousel(balanceVM: widget.balanceVM),
                  );
                }

                // Item selanjutnya adalah e-wallet
                final EWallet ewallet =
                    widget.balanceVM.userBalance!.ewallet![index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: HomeBalanceCarousel(
                    balanceVM: widget.balanceVM,
                    ewallet: ewallet,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16), // Spacing between carousel and indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(itemCount, (index) {
              return AnimatedContainer(
                // Use AnimatedContainer for smooth transitions
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: _currentPage == index
                    ? 24.0
                    : 8.0, // Active indicator is wider
                decoration: BoxDecoration(
                  color: kOrange, // All indicators are kOrange
                  borderRadius: BorderRadius.circular(4.0),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
