import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/produk/provider_kartu.dart';
import '../../../input_nomor/utils/contact_handler.dart';
import '../../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../cubit/flow_cubit.dart';
import '../cubit/provider_prefix_cubit.dart';

class DetailPrefixController {
  final TextEditingController nomorController;
  final ProviderPrefixCubit prefixCubit;
  final TransaksiHelperCubit transaksiCubit;
  final FlowCubit flowCubit;
  final void Function(void Function()) refresh;
  String? selectedProductCode;
  double selectedPrice = 0;
  dynamic selectedProduk;

  Timer? _debounce;

  DetailPrefixController({
    required this.nomorController,
    required this.prefixCubit,
    required this.transaksiCubit,
    required this.flowCubit,
    required this.refresh,
  });

  /// Init: clear any existing providers (call after first frame)
  void initClear() {
    prefixCubit.clear();
  }

  /// Dispose timer
  void dispose() {
    _debounce?.cancel();
  }

  /// Called by TextField.onChanged
  void onNomorChanged(String value) {
    // cancel previous debounce
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.length >= 4) {
      _debounce = Timer(const Duration(milliseconds: 800), () {
        _fetchProvider(value);
      });
    } else {
      prefixCubit.clear();
    }
  }

  Future<void> _fetchProvider(String value) async {
    try {
      final readTransaksi = transaksiCubit.getData();
      await prefixCubit.fetchProvidersPrefix(
        readTransaksi.kodeCatatan ?? '-',
        value,
      );
    } catch (e) {
      // let cubit handle errors; optionally log
    }
  }

  /// Helper untuk pick contact — menggunakan ContactFlowHandler (yang sudah ada)
  Future<void> pickContact(BuildContext context) async {
    final handler = ContactFlowHandler(
      context: context,
      nomorController: nomorController,
      setStateCallback: refresh,
    );
    await handler.pickContact();
  }

  void onProdukSelected(BuildContext context, Produk produk) {
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
}
