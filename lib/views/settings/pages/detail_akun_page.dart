import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';
import 'package:xmlapp/views/settings/cubit/info_akun_cubit.dart';

import '../widgets/detail_row.dart';
import '../widgets/section_title.dart';

class DetailInfoAkun extends StatelessWidget {
  const DetailInfoAkun({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detail Akun',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kWhite,
        foregroundColor: kBlack,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: BlocBuilder<InfoAkunCubit, InfoAkunState>(
          builder: (context, state) {
            if (state is InfoAkunLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InfoAkunLoaded) {
              final data = state.data.data;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info
                    Center(
                      child: Column(
                        children: [
                          Text(
                            data.nama,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data.kodeReseller,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Account Section
                    SectionTitle(title: "Informasi Akun"),
                    DetailRow(label: "Kode Level", value: data.kodeLevel),
                    _buildDivider(),
                    DetailRow(label: "Kode Referral", value: data.kodeReferral),
                    _buildDivider(),
                    DetailRow(
                      label: "Markup Referral",
                      value: data.markupReferral,
                    ),

                    const SizedBox(height: 24),

                    // Financial Section
                    SectionTitle(title: "Finansial"),
                    DetailRow(label: "Saldo", value: data.saldo.toString()),
                    _buildDivider(),
                    DetailRow(label: "Komisi", value: data.komisi.toString()),
                    _buildDivider(),
                    DetailRow(label: "Poin", value: data.poin.toString()),
                    _buildDivider(),
                    DetailRow(label: "Piutang", value: data.piutang.toString()),

                    const SizedBox(height: 24),

                    // Activity Section
                    SectionTitle(title: "Aktivitas"),
                    DetailRow(
                      label: "Downline",
                      value: data.downline.toString(),
                    ),
                    _buildDivider(),
                    DetailRow(label: "Transaksi", value: data.trx.toString()),
                    _buildDivider(),
                    DetailRow(
                      label: "Total Transaksi",
                      value: data.totalTrx.toString(),
                    ),
                    _buildDivider(),
                    DetailRow(
                      label: "Total Pemakaian",
                      value: data.totalPemakaian.toString(),
                    ),
                  ],
                ),
              );
            }

            if (state is InfoAkunError) {
              return const Center(
                child: Text(
                  'Error mengambil Data',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// Divider for detail rows
  Widget _buildDivider() {
    return Divider(color: Colors.grey[300], thickness: 1, height: 1);
  }
}
