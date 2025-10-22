import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class StatusTukarPoinPage extends StatelessWidget {
  const StatusTukarPoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 150, 16, 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: kOrange.withAlpha(80),
                      spreadRadius: 25,
                      blurRadius: 30,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),

                child: Icon(Icons.paid_outlined, color: kWhite, size: 80),
              ),
              SizedBox(height: kSize60),
              Text(
                'Selamat',
                style: TextStyle(
                  color: kOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                'PENUKARAN POIN BERHASIL',
                style: TextStyle(
                  color: kBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: kSize8),
              Text(
                'Poinmu berhasil ditukar menjadi [Product]. Terus kumpulin poinnya dan nikmati lebih banyak keuntungan bareng XML Mobile!',
                style: TextStyle(
                  color: kNeutral90,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Lanjut Transaksi",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
