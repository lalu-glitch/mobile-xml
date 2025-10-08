import 'package:flutter/material.dart';

import '../../../core/utils/bottom_sheet.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../viewmodels/balance_viewmodel.dart';

class Header extends StatelessWidget {
  const Header({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTime.now().hour < 11
                        ? 'Selamat Pagi,'
                        : DateTime.now().hour < 15
                        ? 'Selamat Siang,'
                        : DateTime.now().hour < 18
                        ? 'Selamat Sore,'
                        : 'Selamat Malam,',
                    style: TextStyle(color: kWhite, fontSize: Screen.kSize16),
                  ),
                  Text(
                    balanceVM.userBalance?.namauser ?? 'Guest',
                    style: TextStyle(color: kWhite, fontSize: Screen.kSize20),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {},
                    customBorder:
                        const CircleBorder(), // Agar efek splash-nya lingkaran
                    child: Icon(Icons.search, color: kWhite),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {},
                    customBorder: const CircleBorder(),
                    child: Stack(
                      children: [
                        Icon(Icons.notifications_none, color: kWhite),
                        Positioned(
                          left: 12,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: kGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      showCSBottomSheet(context, "Hubungi CS");
                    },
                    customBorder: const CircleBorder(),
                    child: Icon(Icons.headset_mic_rounded, color: kWhite),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Card
        const SizedBox(height: 50),
      ],
    );
  }
}
