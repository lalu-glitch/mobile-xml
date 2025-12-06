import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class VerifikasiTukarPoinPage extends StatelessWidget {
  const VerifikasiTukarPoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: const .fromLTRB(16, 150, 16, 16),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Container(
                padding: .all(20),
                margin: .fromLTRB(0, 50, 0, 0),
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: .circular(100),
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
                'Verifikasi',
                style: TextStyle(
                  color: kOrange,
                  fontSize: 18,
                  fontWeight: .w600,
                ),
              ),

              Text(
                'PENUKARAN POIN',
                style: TextStyle(
                  color: kBlack,
                  fontSize: 18,
                  fontWeight: .w600,
                ),
              ),
              SizedBox(height: kSize8),
              Text(
                'Verifikasi penukaran poin menjadi [Product] akan dilakukan penukaran!',
                style: TextStyle(
                  color: kNeutral90,
                  fontSize: 12,
                  fontWeight: .w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/statusTukarPoinPage'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      padding: const .symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(16),
                      ),
                    ),
                    child: Text(
                      "Verifikasi Transaksi",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: .w600,
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
