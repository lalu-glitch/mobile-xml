import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/services.dart'; // Untuk Clipboard
import 'package:intl/intl.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/utils/error_dialog.dart';
import 'cubit/detail_riwayat_transaksi_cubit.dart';

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

  Widget _buildDetailItem(String label, String? value) => Card(
    margin: const EdgeInsets.symmetric(vertical: 1),
    child: ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value ?? '-'), // tampilkan '-' kalau null
      trailing: IconButton(
        icon: const Icon(Icons.copy, size: 20),
        onPressed: () {
          if (value != null && value.isNotEmpty) {
            Clipboard.setData(ClipboardData(text: value));
            showInfoToast("Text berhasil di copy : $value", kGreenComplete);
          } else {
            showInfoToast("gagal copy", kRed);
          }
        },
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Riwayat Transaksi',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body:
          BlocBuilder<DetailRiwayatTransaksiCubit, DetailRiwayatTransaksiState>(
            builder: (context, state) {
              if (state is DetailRiwayatTransaksiInitial ||
                  state is DetailRiwayatTransaksiLoading) {
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
                          _buildDetailItem("Kode", status.kode.toString()),
                          _buildDetailItem("Produk", status.kodeProduk),
                          _buildDetailItem("Tujuan", status.tujuan),
                          _buildDetailItem(
                            "Waktu",
                            DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(status.tglEntri),
                          ),
                          _buildDetailItem("Status", status.keterangan),
                          _buildDetailItem("Harga", status.harga.toString()),
                          _buildDetailItem("SN", status.sn),
                          _buildDetailItem("Outbox", status.outbox),
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
