import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../widgets/bank_card.dart';

class SpeedcashTopUpPage extends StatelessWidget {
  const SpeedcashTopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int itemCount = 15;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Speedcash TopUp', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: SafeArea(
        child: Padding(
          // Gunakan EdgeInsets.symmetric
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, int index) {
              return BankCard(
                title: 'Bank Central Asia ${index + 1}',
                minimumTopUp: 'Rp. 10.000',
                klik: () {
                  Navigator.pushNamed(context, '/speedcashDetailTopUpPage');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
