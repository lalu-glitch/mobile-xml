import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xmlapp/data/models/user/user_balance.dart';

import '../../../core/helper/constant_finals.dart';
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
