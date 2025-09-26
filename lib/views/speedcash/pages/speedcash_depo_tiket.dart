import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class SpeedCashTiketDeposit extends StatelessWidget {
  const SpeedCashTiketDeposit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        centerTitle: true,
        title: Text('Konfirmasi Deposit'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              decoration: BoxDecoration(
                color: kOrange,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: kOrange.withAlpha(80), // Warna bayangan (transparan)
                    spreadRadius: 25, // Seberapa jauh bayangan menyebar
                    blurRadius: 30, // Tingkat keburaman bayangan
                    offset: Offset(0, 0), // Posisi bayangan (x, y)
                  ),
                ],
              ),

              child: Icon(Icons.paid_outlined, color: kWhite, size: 80),
            ),
            const SizedBox(height: 100),
            Text(
              'Silahkan Transfer',
              style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Silahkan transfer melalui Bank Mandiri\n Jika tidak dilakukan transfer maka kita baku hantam',
              style: TextStyle(color: kNeutral80, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kOrangeAccent300.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bank',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                      Text(
                        'Mandiri',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nama',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                      Text(
                        'PT. XMLTronik',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nomor Rekening',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                      Text(
                        '1234 5678 90',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Berlaku sampai',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                      Text(
                        '99 Desember 2099',
                        style: TextStyle(color: kBlack, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: kOrange),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Nominal',
                        style: TextStyle(
                          color: kBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Rp. 1.999.999',
                        style: TextStyle(
                          color: kBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            foregroundColor: kWhite,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/transaksiProses');
          },
          child: const Text(
            "Konfirmasi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
