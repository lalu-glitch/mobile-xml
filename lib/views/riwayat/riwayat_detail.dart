import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/helper/constant_finals.dart';
import 'cubit/detail_riwayat_transaksi_cubit.dart';
import 'widgets/card_detail_item.dart';

class DetailRiwayatPage extends StatefulWidget {
  const DetailRiwayatPage({super.key});

  @override
  State<DetailRiwayatPage> createState() => _DetailRiwayatPageState();
}

class _DetailRiwayatPageState extends State<DetailRiwayatPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final String kode = args?['kode'] ?? '';
      if (kode.isNotEmpty) {
        context.read<DetailRiwayatTransaksiCubit>().loadDetailRiwayat(kode);
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Riwayat Transaksi',
          style: TextStyle(color: kWhite),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body:
          BlocBuilder<DetailRiwayatTransaksiCubit, DetailRiwayatTransaksiState>(
            builder: (context, state) {
              if (state is DetailRiwayatTransaksiLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DetailRiwayatTransaksiError) {
                return Center(child: Text(state.message));
              }

              if (state is DetailRiwayatTransaksiSuccess) {
                final status = state.statusTransaksi;

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          buildInfoTile(
                            context,
                            label: "Kode",
                            value: status.kode.toString(),
                          ),
                          buildInfoTile(
                            context,
                            label: "Produk",
                            value: status.kodeProduk,
                          ),
                          buildInfoTile(
                            context,
                            label: "Tujuan",
                            value: status.tujuan,
                          ),
                          buildInfoTile(
                            context,
                            label: "Waktu",
                            value: DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(status.tglEntri),
                          ),
                          buildInfoTile(
                            context,
                            label: "Status",
                            value: status.keterangan,
                          ),
                          buildInfoTile(
                            context,
                            label: "Harga",
                            value: status.harga.toString(),
                          ),
                          buildInfoTile(context, label: "SN", value: status.sn),
                          buildInfoTile(
                            context,
                            label: "Outbox",
                            value: status.outbox,
                          ),
                        ],
                      ),
                    ),
                    // Tombol Struk di paling bawah
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            shadowColor: Colors.orangeAccent.shade100,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/struk',
                              arguments: {'transaksi': status},
                            );
                          },
                          child: Text(
                            "Cetak Struk",
                            style: TextStyle(
                              fontSize: Screen.kSize16,
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); // Fallback, though unlikely
            },
          ),
    );
  }
}
