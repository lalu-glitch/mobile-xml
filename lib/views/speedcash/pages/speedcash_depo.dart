import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../widgets/bank_card.dart';

class SpeedcashDepositPage extends StatefulWidget {
  const SpeedcashDepositPage({super.key});

  @override
  State<SpeedcashDepositPage> createState() => _SpeedcashDepositPageState();
}

class _SpeedcashDepositPageState extends State<SpeedcashDepositPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Speedcash Deposit', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 16),
          child: ListView.builder(
            itemCount: 15,
            itemBuilder: (context, int index) {
              return BankCard(
                title: 'Bank Central Asia',
                minimumTopUp: 'Rp. 10.000',
                klik: () =>
                    Navigator.pushNamed(context, '/speedcashDetailDepositPage'),
              );
            },
          ),
        ),
      ),
    );
  }
}
