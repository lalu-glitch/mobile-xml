import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/shimmer.dart';
import '../../../data/models/user/ewallet_model.dart';
import '../../../core/helper/constant_finals.dart';
import '../cubit/balance_cubit.dart';
import 'widget_wallet_carousel.dart';

class CarouselSection extends StatefulWidget {
  const CarouselSection({super.key});

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
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
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final ewalletCount = state.data.ewallet?.length ?? 0;
                      // Tampilkan e-wallet terlebih dahulu
                      if (index < ewalletCount) {
                        final Ewallet ewallet = state.data.ewallet![index];
                        return Padding(
                          padding: const .symmetric(horizontal: 4),
                          child: WalletCarousel(
                            userBalance: state.data,
                            ewallet: ewallet,
                          ),
                        );
                      }

                      // Item terakhir selalu Saldo XML
                      return Padding(
                        padding: const .symmetric(horizontal: 4),
                        child: WalletCarousel(userBalance: state.data),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
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
        shape: RoundedRectangleBorder(borderRadius: .circular(24)),
        color: kWhite,
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 16),
          child: ShimmerBox.dMainShimmerWallet(),
        ),
      ),
    );
  }
}
