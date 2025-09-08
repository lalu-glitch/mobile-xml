import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../viewmodels/balance_viewmodel.dart';

class Header extends StatelessWidget {
  const Header({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Halo, Nama User
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Halo, ",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal, // normal untuk 'Halo,'
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    balanceVM.userBalance?.namauser ?? '-',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold, // bold untuk nama user
                      color: Colors.white,
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
                      // showCSBottomSheet(context, "Hubungi CS");
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
