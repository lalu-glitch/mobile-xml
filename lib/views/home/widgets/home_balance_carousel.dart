import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import 'saldo_header_card.dart';

class HomeBalanceCarousel extends StatelessWidget {
  const HomeBalanceCarousel({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

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
            child: balanceVM.isLoading || balanceVM.userBalance == null
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title shimmer
                        Container(
                          width: 150,
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        // Balance shimmer
                        Container(
                          width: constraints.maxWidth,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        // 3 small shimmer boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(3, (index) {
                            return Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 20,
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                : HeaderSaldo(balanceVM: balanceVM),
          ),
        );
      },
    );
  }
}
