import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/helper/constant_finals.dart';
import '../cubit/detail_riwayat_transaksi_cubit.dart';
import '../widgets/card_detail_item.dart';

class DetailRiwayatPage extends StatelessWidget {
  final String kode;

  const DetailRiwayatPage({super.key, required this.kode});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailRiwayatTransaksiCubit>().loadDetailRiwayat(kode);
    });

    return Scaffold(
      backgroundColor: kBackground,
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
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: kNeutral40,
                        highlightColor: kBackground,
                        child: Card(
                          color: kWhite,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Container(
                              width: double.infinity,
                              height: 14,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                            ),
                            subtitle: Container(
                              width: double.infinity,
                              height: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SafeArea(
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
                                fontSize: kSize16,
                                fontWeight: FontWeight.bold,
                                color: kWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); // Fallback, though unlikely wkwk
            },
          ),
    );
  }
}
