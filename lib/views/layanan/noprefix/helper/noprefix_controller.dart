import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/dynamic_app_page.dart';
import '../../../../data/models/produk/provider_kartu_model.dart';
import '../../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../cubit/flow_cubit.dart';
import '../cubit/provider_noprefix_cubit.dart';

class DetailNoPrefixController {
  final BuildContext context;
  final FlowCubit flowCubit;
  final TransaksiHelperCubit transaksiCubit;
  final void Function(void Function()) refresh;
  String? selectedProductCode;
  double selectedPrice = 0;
  dynamic selectedProduk;

  DetailNoPrefixController({
    required this.context,
    required this.flowCubit,
    required this.transaksiCubit,
    required this.refresh,
  });

  ProviderNoPrefixCubit get noPrefixCubit =>
      context.read<ProviderNoPrefixCubit>();

  void initFetch() {
    final flowState = flowCubit.state!;
    final layanan = flowState.layananItem;
    noPrefixCubit.fetchProviders(layanan.kodeCatatan, "");
  }

  void onProdukSelected(Produk produk) {
    selectedProductCode = produk.kodeProduk;
    selectedPrice = produk.hargaJual.toDouble();
    selectedProduk = produk;

    context.read<TransaksiHelperCubit>().pilihProduk(
      kode: produk.kodeProduk,
      nama: produk.namaProduk,
      harga: selectedPrice,
      isBebasNominalApi: produk.bebasNominal,
      isEndUserApi: produk.endUser,
    );

    // panggil setState parent
    refresh(() {});
  }

  /// TODO [VERIFY]
  void navigateNext({required bool isLastPage, required String nomorTujuan}) {
    transaksiCubit.setTujuan(nomorTujuan);
    final state = flowCubit.state!;

    if (!isLastPage) {
      final nextPage = state.sequence[state.currentIndex + 1];
      flowCubit.nextPage();
      Navigator.pushNamed(context, pageRoutes[nextPage]!);
    } else {
      Navigator.pushNamed(context, '/konfirmasiPembayaran');
    }
  }
}
