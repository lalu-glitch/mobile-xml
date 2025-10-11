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
      backgroundColor: kNeutral20,
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
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: kOrange,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.nama,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              letterSpacing: 0.5,
                              color: kWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: kWhite.withAlpha(80),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: kWhite.withAlpha(100)),
                            ),
                            child: Text(
                              data.kodeReseller,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
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
                      value: data.markupReferral.toString(),
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
                  style: TextStyle(color: kRed),
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
    return Divider(color: kNeutral40, thickness: 1, height: 1);
  }
}
