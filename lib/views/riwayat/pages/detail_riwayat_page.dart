import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../cubit/detail_riwayat_transaksi_cubit.dart';
import '../widgets/widget_cetak_struk_button.dart';
import '../widgets/widget_detail_transaksi_row.dart';

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
          'Detail Transaksi',
          style: TextStyle(color: kBlack, fontSize: 18, fontWeight: .w600),
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: kBlack),
        scrolledUnderElevation: 0.0,
      ),
      body: BlocBuilder<DetailRiwayatTransaksiCubit, DetailRiwayatTransaksiState>(
        builder: (context, state) {
          if (state is DetailRiwayatTransaksiLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kOrange, strokeWidth: 5),
            );
          }

          if (state is DetailRiwayatTransaksiError) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: kGrey),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: kGrey)),
                ],
              ),
            );
          }

          if (state is DetailRiwayatTransaksiSuccess) {
            final status = state.statusTransaksi;
            // Tentukan warna status (Hijau jika sukses, Merah jika gagal)
            final bool isSuccess = status.keterangan.toUpperCase().contains(
              "SUKSES",
            );
            final Color statusColor = isSuccess ? kGreen : kRed;
            final IconData statusIcon = isSuccess
                ? Icons.check_circle
                : Icons.cancel;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // --- UTAMA: KARTU TRANSAKSI ---
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: .circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: kBlack.withAlpha(15),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // 1. HEADER (Icon & Amount)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 30,
                                ),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: const .vertical(
                                    top: Radius.circular(20),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(color: kNeutral20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(25),
                                        shape: .circle,
                                      ),
                                      child: Icon(
                                        statusIcon,
                                        color: statusColor,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      isSuccess
                                          ? "Transaksi Berhasil"
                                          : "Transaksi Gagal",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: .bold,
                                        color: statusColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Menampilkan Harga dengan Besar
                                    Text(
                                      CurrencyUtil.formatCurrency(
                                        int.tryParse(status.harga),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: .w800,
                                        color: kBlack,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy • HH:mm',
                                      ).format(status.tglEntri),
                                      style: TextStyle(
                                        color: kNeutral60,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 2. DETAIL LIST
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    _buildSectionTitle("Detail Produk"),
                                    const SizedBox(height: 12),
                                    DetailRiwayatTransaksiRow(
                                      label: "Produk",
                                      value: status.kodeProduk,
                                    ),
                                    DetailRiwayatTransaksiRow(
                                      label: "Tujuan",
                                      value: status.tujuan,
                                    ),
                                    DetailRiwayatTransaksiRow(
                                      label: "Keterangan",
                                      value: status.keterangan,
                                    ),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Divider(),
                                    ),

                                    _buildSectionTitle("Detail Pembayaran"),
                                    const SizedBox(height: 12),
                                    DetailRiwayatTransaksiRow(
                                      label: "Kode Transaksi",
                                      value: status.kode.toString(),
                                      canCopy: true,
                                    ),
                                    // Tampilkan SN jika ada
                                    if (status.sn.isNotEmpty)
                                      DetailRiwayatTransaksiRow(
                                        label: "Serial Number (SN)",
                                        value: status.sn,
                                        isHighlighted:
                                            true, // SN biasanya penting
                                        canCopy: true,
                                      ),

                                    // Tampilkan Outbox/Pesan Operator jika ada
                                    if (status.outbox.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: kYellow.withAlpha(25),
                                          borderRadius: .circular(8),
                                          border: Border.all(color: kNeutral20),
                                        ),
                                        child: Text(
                                          status.outbox,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: kNeutral90,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Branding Footer
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: kNeutral50,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Transaksi Anda aman & terenkripsi",
                              style: TextStyle(color: kNeutral50, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- TOMBOL CETAK (Sticky Bottom) ---
                CetakStrukButton(status: status),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: .bold, color: kBlack),
    );
  }
}
