import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../widgets/bank_card.dart';

class SpeedcashDepositPage extends StatelessWidget {
  const SpeedcashDepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          'Speedcash Deposit',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 16),
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, int index) {
              return BankCard(
                title: 'Bank Pukimai Woi Pencuri',
                minimumTopUp: 'Rp. 10.000',
                onTap: () {},
              );
            },
          ),
        ),
      ),
    );
  }
}
