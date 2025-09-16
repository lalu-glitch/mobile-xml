import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

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
      body: Center(
        child: Text(
          "This is Speedcash Deposit Page",
          style: TextStyle(fontSize: Screen.kSize20),
        ),
      ),
    );
  }
}
