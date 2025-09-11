import 'package:flutter/material.dart';
import 'package:xmlapp/core/constant_finals.dart';

import '../../../core/utils/cs_bottom_sheet.dart';
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
                    style: Styles.kNunitoRegular.copyWith(
                      color: Colors.white,
                      fontSize: Screen.kSize16,
                    ),
                  ),
                  Text(
                    balanceVM.userBalance?.namauser ?? '-',
                    style: Styles.kNunitoBold.copyWith(
                      color: Colors.white,
                      fontSize: Screen.kSize20,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {
                      // aksi notifikasi
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.headset_mic, color: Colors.white),
                    onPressed: () {
                      // aksi notifikasi
                      showCSBottomSheet(context, "Hubungi CS");
                    },
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
