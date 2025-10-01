import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../topup_dummy/cubit/topup_dummy_speedcash_cubit.dart';
import '../widgets/rupiah_text_field.dart';

class SpeedCashDetailDepo extends StatelessWidget {
  const SpeedCashDetailDepo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(backgroundColor: kWhite),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kOrangeAccent500,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(Icons.credit_card_rounded, color: kWhite),
                ),
                const SizedBox(width: 16),
                Text(
                  'Bank Central Asia',
                  style: TextStyle(
                    color: kNeutral100,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            RupiahTextField(), // <--- TextField buat masukin nominal topup
            const SizedBox(height: 16),
            Text(
              ' Minimal top up Rp. 10.000',
              style: TextStyle(color: kNeutral90),
            ),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 16),
            Text(
              ' Panduan',
              style: TextStyle(
                color: kNeutral100,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: kNeutral30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: ExpansionTile(
                title: const Text(
                  "Petunjuk top up via ATM",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kNeutral100,
                  ),
                ),
                tilePadding: const EdgeInsets.symmetric(horizontal: 18),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                shape: Border(),
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Masukkan kartu ATM dan PIN."),
                        SizedBox(height: 4),
                        Text("2. Pilih menu 'Transfer'."),
                        SizedBox(height: 4),
                        Text("3. Masukkan nomor rekening tujuan."),
                        SizedBox(height: 4),
                        Text("4. Masukkan nominal top up sesuai."),
                        SizedBox(height: 4),
                        Text("5. Ko pukul ko punya satpam."),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
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
          onPressed: () async {
            context.read<TopupDummySpeedcashCubit>().fetchTopup();
            Navigator.pushNamed(context, '/speedcashTiketDepositPage');
          },
          child: const Text(
            "Selanjutnya",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
