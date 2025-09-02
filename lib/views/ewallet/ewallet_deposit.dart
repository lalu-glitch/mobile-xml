import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EwalletDepositPage extends StatelessWidget {
  const EwalletDepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          'Ewallet Deposit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          "This is Ewallet Deposit Page",
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}
