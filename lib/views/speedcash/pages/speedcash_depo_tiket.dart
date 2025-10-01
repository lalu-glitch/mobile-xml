import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/utils/dialog.dart';

import '../../../core/helper/constant_finals.dart';
import '../topup_dummy/cubit/topup_dummy_speedcash_cubit.dart';

class SpeedCashTiketDeposit extends StatelessWidget {
  const SpeedCashTiketDeposit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(backgroundColor: kWhite),
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
                    color: kOrange.withAlpha(80),
                    spreadRadius: 25,
                    blurRadius: 30,
                    offset: Offset(0, 0),
                  ),
                ],
              ),

              child: Icon(Icons.paid_outlined, color: kWhite, size: 80),
            ),
            const SizedBox(height: 100),
            Text(
              'Detail Transfer',
              style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Silahkan cek detail Top Up dibawah ini \n Terimakasih sudah menggunakan layanan di XML Mobile',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: kNeutral80,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            BlocBuilder<TopupDummySpeedcashCubit, TopupDummySpeedcashState>(
              builder: (context, state) {
                if (state is TopupDummySpeedcashLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: kOrange),
                  );
                }
                if (state is TopupDummySpeedcashLoaded) {
                  return Container(
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
                              state.data.namaBank,
                              style: TextStyle(color: kBlack, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Keterangan',
                              style: TextStyle(color: kBlack, fontSize: 14),
                            ),
                            Text(
                              state.data.keterangan,
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
                              state.data.rekening.toString(),
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
                              state.data.expired,
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
                              'Rp. ${state.data.nominal.toString()}',
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
                  );
                }
                if (state is TopupDummySpeedcashError) {
                  return Center(child: Text('Error'));
                }
                return SizedBox();
              },
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
            showAppToast(context, 'Success', ToastType.success);
          },
          child: const Text(
            "Selesai",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
