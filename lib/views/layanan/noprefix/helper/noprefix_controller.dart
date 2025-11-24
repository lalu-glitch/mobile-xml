import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/dynamic_app_page.dart';
import '../../../input_nomor/utils/transaksi_cubit.dart';
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

  void onProdukSelected(dynamic produk) {
    selectedProductCode = produk.kodeProduk;
    selectedPrice = produk.hargaJual.toDouble();
    selectedProduk = produk;

    transaksiCubit.setKodeproduk(produk.kodeProduk);
    transaksiCubit.setNamaProduk(produk.namaProduk);
    transaksiCubit.setProductPrice(produk.hargaJual);
    transaksiCubit.isEndUser(produk.endUser);
    transaksiCubit.isBebasNominal(produk.bebasNominal);

    // panggil setState parent
    refresh(() {});
  }

  void navigateNext({required bool isLastPage, required String nomorTujuan}) {
    transaksiCubit.setTujuan(nomorTujuan);
    final state = flowCubit.state!;

    if (!isLastPage &&
        (selectedProduk?.bebasNominal == 1 || selectedProduk?.endUser == 1)) {
      flowCubit.nextPage();
      final next = state.sequence[state.currentIndex + 1];
      Navigator.pushNamed(context, pageRoutes[next]!);
    } else {
      Navigator.pushNamed(context, '/konfirmasiPembayaran');
    }
  }
}
