import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../core/helper/dynamic_app_page.dart';
import '../../../../data/models/layanan/flow_state_models.dart';
import '../../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../cubit/flow_cubit.dart';
import '../cubit/provider_prefix_cubit.dart';

class NavigationButtonPrefix extends StatelessWidget {
  const NavigationButtonPrefix({
    super.key,
    required this.selectedProductCode,
    required this.selectedPrice,
    required this.isLastPage,
    required this.sendTransaksi,
    required this.nomorTujuan,
    required this.flowState,
    required this.flowCubit,
  });

  final String? selectedProductCode;
  final double selectedPrice;
  final bool isLastPage;
  final TransaksiHelperCubit sendTransaksi;
  final String nomorTujuan;
  final FlowStateModel flowState;
  final FlowCubit flowCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderPrefixCubit, ProviderPrefixState>(
      builder: (context, state) {
        if (state is! ProviderPrefixSuccess) {
          return const SizedBox.shrink();
        }

        final selectedProduk = state.providers
            .expand((p) => p.produk)
            .where((p) => p.kodeProduk == selectedProductCode)
            .firstOrNull;

        if (selectedProduk == null) return const SizedBox.shrink();

        return SafeArea(
          child: Container(
            color: kOrange,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total ${CurrencyUtil.formatCurrency(selectedPrice)}",
                  style: TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: kSize16,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kWhite,
                    foregroundColor: kOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final bool navigateToBNEUPage =
                        !isLastPage &&
                        (selectedProduk.bebasNominal == 1 ||
                            selectedProduk.endUser == 1);
                    if (navigateToBNEUPage) {
                      sendTransaksi.setTujuan(nomorTujuan);
                      final nextPage =
                          flowState.sequence[flowState.currentIndex + 1];
                      flowCubit.nextPage();
                      Navigator.pushNamed(context, pageRoutes[nextPage]!);
                    } else {
                      sendTransaksi.setTujuan(nomorTujuan);
                      Navigator.pushNamed(context, '/konfirmasiPembayaran');
                    }
                  },
                  child: Text(
                    isLastPage ? "Selanjutnya" : "Selanjutnya",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
