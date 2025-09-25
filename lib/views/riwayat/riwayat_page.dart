import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../../core/helper/constant_finals.dart';

import '../../data/models/transaksi/transaksi_riwayat.dart';
import 'cubit/riwayat_transaksi_cubit.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  @override
  void initState() {
    super.initState();
    context.read<RiwayatTransaksiCubit>().loadRiwayat();
  }

  Color _statusColor(RiwayatTransaksi t) {
    switch (t.status) {
      case 20:
        return kGreen;
      case 40:
      case 43:
      case 50:
      case 52:
      case 53:
      case 55:
        return kRed;
      default:
        return kOrange;
    }
  }

  IconData _statusIcon(RiwayatTransaksi t) {
    switch (t.status) {
      case 20:
        return Icons.check_circle;
      case 40:
      case 43:
      case 50:
      case 52:
      case 53:
      case 55:
        return Icons.error;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: BlocBuilder<RiwayatTransaksiCubit, RiwayatTransaksiState>(
        builder: (context, state) {
          if (state is RiwayatTransaksiInitial ||
              state is RiwayatTransaksiLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RiwayatTransaksiError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(fontSize: Screen.kSize16, color: Colors.red),
              ),
            );
          }

          List<RiwayatTransaksi> riwayatList = [];
          int currentPage = 1;
          int totalPages = 1;
          bool isLoadingMore = false;

          if (state is RiwayatTransaksiSuccess) {
            riwayatList = state.riwayatList;
            currentPage = state.currentPage;
            totalPages = state.totalPages;
          } else if (state is RiwayatTransaksiLoadingMore) {
            riwayatList = state.riwayatList;
            currentPage = state.currentPage;
            totalPages = state.totalPages;
            isLoadingMore = true;
          }

          if (riwayatList.isEmpty) {
            return Center(
              child: Text(
                "Belum ada transaksi",
                style: TextStyle(fontSize: Screen.kSize16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: riwayatList.length,
                  itemBuilder: (context, index) {
                    RiwayatTransaksi t = riwayatList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 1,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: Icon(
                            _statusIcon(t),
                            color: _statusColor(t),
                            size: 32,
                          ),
                          title: Text(
                            t.tujuan,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Screen.kSize16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(t.tglEntri)}",
                                  style: TextStyle(
                                    fontSize: Screen.kSize14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Status: ${t.keterangan}",
                                  style: TextStyle(
                                    fontSize: Screen.kSize14,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(t),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Text(
                            "Rp ${t.harga.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () {
                            print('KODE: ${t.kode}');
                            Navigator.pushNamed(
                              context,
                              '/detailRiwayatTransaksi',
                              arguments: {'kode': t.kode},
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (currentPage < totalPages)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: kOrange,
                      ),
                      onPressed: isLoadingMore
                          ? null
                          : () => context
                                .read<RiwayatTransaksiCubit>()
                                .loadNextPage(),
                      child: isLoadingMore
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kWhite,
                              ),
                            )
                          : Text(
                              "Lainnya",
                              style: TextStyle(
                                fontSize: Screen.kSize16,
                                fontWeight: FontWeight.bold,
                                color: kWhite,
                              ),
                            ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
