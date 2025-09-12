import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant_finals.dart';

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
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}
