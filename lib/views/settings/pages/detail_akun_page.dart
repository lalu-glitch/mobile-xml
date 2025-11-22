import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';
import 'package:xmlapp/views/settings/cubit/info_akun/info_akun_cubit.dart';

import '../../../core/helper/currency.dart';
import '../widgets/detail_row.dart';
import '../widgets/section_title.dart';
import '../widgets/setting_user_header.dart';

class DetailInfoAkun extends StatelessWidget {
  const DetailInfoAkun({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          'Detail Akun',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: kOrange,
        foregroundColor: kWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    SizedBox(height: kSize12),
                    SizedBox(
                      height: kSize50 * 2,
                      child: UserProfileCard(state: state, color: kOrange),
                    ),
                    SizedBox(height: kSize32),

                    // Account Section
                    SectionTitle(title: "Informasi Akun"),
                    SizedBox(height: kSize12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          DetailRow(
                            label: "Nama",
                            value: data.nama ?? '-',
                            isNavigate: true,
                          ),
                          _buildDivider(),
                          DetailRow(
                            label: "Kode Level",
                            value: data.kodeLevel ?? 'N/A',
                          ),
                          _buildDivider(),
                          DetailRow(
                            label: "Kode Referral",
                            value: data.kodeReferral,
                            isNavigate: true,
                          ),
                          _buildDivider(),
                          DetailRow(
                            label: "Markup Referral",
                            value: data.markupReferral.toString(),
                            isNavigate: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: kSize24),

                    // Financial Section
                    SectionTitle(title: "Finansial"),
                    SizedBox(height: kSize12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          DetailRow(
                            label: "Saldo",
                            value: CurrencyUtil.formatCurrency(data.saldo),
                          ),
                          _buildDivider(),
                          DetailRow(
                            label: "Komisi",
                            value: data.komisi.toString(),
                          ),
                          _buildDivider(),
                          DetailRow(label: "Poin", value: data.poin.toString()),
                          _buildDivider(),
                          DetailRow(
                            label: "Piutang",
                            value: data.piutang.toString(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: kSize24),

                    // Activity Section
                    SectionTitle(title: "Aktivitas"),
                    SizedBox(height: kSize12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          DetailRow(
                            label: "Downline",
                            value: data.downline.toString(),
                          ),
                          _buildDivider(),
                          DetailRow(
                            label: "Transaksi",
                            value: data.trx.toString(),
                          ),
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
