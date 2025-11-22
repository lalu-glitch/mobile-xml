import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/shimmer.dart';
import '../../../data/models/transaksi/riwayat_transaksi.dart';

import '../cubit/riwayat_transaksi_cubit.dart';
import '../widgets/card_transaksi.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    ///fungsi refresh
    void refresh() {
      context.read<RiwayatTransaksiCubit>().loadRiwayat();
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: BlocBuilder<RiwayatTransaksiCubit, RiwayatTransaksiState>(
          builder: (context, state) {
            if (state is RiwayatTransaksiInitial) {
              context.read<RiwayatTransaksiCubit>().loadRiwayat();
              return ShimmerBox.buildShimmerRiwayatTransaksi();
            }

            if (state is RiwayatTransaksiLoading) {
              return ShimmerBox.buildShimmerRiwayatTransaksi();
            }

            if (state is RiwayatTransaksiError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: kNeutral60,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
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
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<RiwayatTransaksiCubit>().loadRiwayat(),
                color: kOrange,
                child: Center(
                  child: Text(
                    "Belum ada transaksi",
                    style: TextStyle(fontSize: kSize16, color: Colors.grey),
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => refresh(),
                    color: kOrange,
                    child: ListView.builder(
                      itemCount: riwayatList.length,
                      itemBuilder: (context, index) {
                        RiwayatTransaksi transaksi = riwayatList[index];
                        return Padding(
                          padding: const .symmetric(horizontal: 12),
                          child: TransactionCard(
                            key: ValueKey(transaksi.kode),
                            t: transaksi,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (currentPage < totalPages)
                  Padding(
                    padding: const .symmetric(vertical: 8, horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const .symmetric(vertical: 14),
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
                                  fontSize: kSize16,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
