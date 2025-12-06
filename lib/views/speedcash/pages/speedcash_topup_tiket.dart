import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../cubit/request_topup_cubit.dart';

class SpeedCashTiketTopUp extends StatelessWidget {
  const SpeedCashTiketTopUp({super.key});

  DateTime parseDate(String data) {
    return DateTime.parse(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(backgroundColor: kWhite, scrolledUnderElevation: 0.0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Detail Transfer',
                style: TextStyle(
                  color: kBlack,
                  fontWeight: .w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Silahkan cek detail Top Up dibawah ini \n Terimakasih sudah menggunakan layanan di XML Mobile',
                style: TextStyle(
                  fontWeight: .w500,
                  color: kNeutral80,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              BlocBuilder<RequestTopUpCubit, RequestTopUpState>(
                builder: (context, state) {
                  if (state is RequestTopUpLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: kOrange),
                    );
                  }
                  if (state is RequestTopUpSuccess) {
                    return Container(
                      padding: .symmetric(horizontal: 16, vertical: 14),
                      margin: .symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: kOrangeAccent300.withAlpha(50),
                        borderRadius: .circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'Bank',
                                style: TextStyle(color: kBlack, fontSize: 14),
                              ),
                              Text(
                                state.data.bank,
                                style: TextStyle(color: kBlack, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: kOrange),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: .start,
                            children: [
                              const Text(
                                'Keterangan',
                                style: TextStyle(color: kBlack, fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  state.data.keterangan,
                                  style: const TextStyle(
                                    color: kBlack,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: kOrange),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: .spaceBetween,
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
                          const SizedBox(height: 8),
                          const Divider(color: kOrange),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'Berlaku sampai',
                                style: TextStyle(color: kBlack, fontSize: 14),
                              ),
                              Text(
                                '${parseDate(state.data.expiredAt.toString())}',
                                style: TextStyle(color: kBlack, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: kOrange),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'Total Nominal',
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 14,
                                  fontWeight: .w600,
                                ),
                              ),
                              Text(
                                'Rp. ${state.data.nominal.toString()}',
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 14,
                                  fontWeight: .w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is RequestTopUpError) {
                    return Center(child: Text('Error'));
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const .fromLTRB(16, 0, 16, 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            foregroundColor: kWhite,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
          ),
          onPressed: () {
            showAppToast(context, 'Berhasil TopUp', ToastType.success);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("Selesai", style: TextStyle(fontWeight: .bold)),
        ),
      ),
    );
  }
}
