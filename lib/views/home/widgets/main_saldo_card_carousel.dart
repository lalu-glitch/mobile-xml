import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/shimmer.dart';
import '../../../data/models/user/user_balance.dart';
import '../../../core/helper/constant_finals.dart';
import '../cubit/balance_cubit.dart';
import 'home_balance_carousel.dart';

class MainSaldoCardCarousel extends StatefulWidget {
  const MainSaldoCardCarousel({super.key});

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
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        //loading state
        if (state is BalanceLoading) {
          return loadingAndErrorWidget();
        }
        //loaded state
        if (state is BalanceLoaded) {
          final int itemCount = 1 + (state.data.ewallet?.length ?? 0);
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
                      // Item pertama (index 0) adalah Saldo XML
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: HomeBalanceCarousel(),
                        );
                      }

                      // Item selanjutnya adalah e-wallet
                      final BalanceWallet ewallet =
                          state.data.ewallet![index - 1];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: HomeBalanceCarousel(
                          userBalance: state.data,
                          ewallet: ewallet,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(itemCount, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8.0,
                      width: _currentPage == index ? 24.0 : 8.0,
                      decoration: BoxDecoration(
                        color: kOrange,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }
        if (state is BalanceError) {
          return loadingAndErrorWidget();
        }
        return SizedBox.shrink();
      },
    );
  }

  Positioned loadingAndErrorWidget() {
    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: kWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ShimmerBox.buildMainShimmerCard(),
        ),
      ),
    );
  }
}
