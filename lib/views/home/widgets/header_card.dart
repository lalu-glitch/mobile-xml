import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import 'header_wallet_speedcash.dart';
import 'header_wallet_xml.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: kWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: balanceVM.isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // <-- radius 8
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // <-- radius 12
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(3, (index) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // <-- radius 10
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Saldo speedcash
                      SpeedCashWalletHeader(
                        balanceVM: balanceVM,
                      ), // <-- widget speedcash
                      const SizedBox(height: 10),
                      StokXMLHeader(
                        balanceVM: balanceVM,
                      ), // <-- widget stok xml
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/komisiPage');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // biar ukurannya pas
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: Colors.green,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 4),
                                      Text(
                                        "${balanceVM.userBalance?.poin ?? 0} ",
                                        style: TextStyle(
                                          fontSize: Screen.kSize12,
                                        ),
                                      ),
                                      Text(
                                        " Komisi",
                                        style: TextStyle(
                                          fontSize: Screen.kSize12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min, // biar ukurannya pas
                              children: [
                                const Icon(Icons.star, color: Colors.orange),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      "${balanceVM.userBalance?.poin ?? 0} ",
                                      style: TextStyle(
                                        fontSize: Screen.kSize12,
                                      ),
                                    ),
                                    Text(
                                      "Poin",
                                      style: TextStyle(
                                        fontSize: Screen.kSize12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/riwayatTransaksi',
                                );
                              },
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // biar ada efek ripple bulat
                              child: Row(
                                children: [
                                  Icon(Icons.history, color: Colors.orange),
                                  Text(
                                    " Riwayat",
                                    style: TextStyle(fontSize: Screen.kSize12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.report,
                              color: kWhite,
                              size: Screen.kSize14,
                            ),
                            const Text(
                              " Jangan biarin saldo kamu kosong! Yuk, topup sekarang!",
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold, // bold untuk nama user
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
