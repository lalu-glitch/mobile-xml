// ignore_for_file: unused_import, unnecessary_string_interpolations
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/dynamic_app_page.dart';
import '../../../../core/utils/dialog.dart';
import '../../../../data/models/produk/provider_kartu_model.dart';
import '../../../input_nomor/utils/contact_handler.dart';
import '../../cubit/flow_cubit.dart';
import '../../../../data/models/layanan/flow_state_model.dart';
import '../../../../core/helper/currency.dart';
import '../../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../../transaksi/pages/konfirmasi_pembayaran_page.dart';
import '../cubit/provider_prefix_cubit.dart';
import '../helper/prefix_controller.dart';
import '../widgets/widget_input_nomor_prefix.dart';
import '../widgets/widget_navigation_button_prefix.dart';
import '../widgets/widget_product_item_prefix.dart';

class DetailPrefixPage extends StatefulWidget {
  const DetailPrefixPage({super.key});

  @override
  State<DetailPrefixPage> createState() => _DetailPrefixPageState();
}

class _DetailPrefixPageState extends State<DetailPrefixPage> {
  // Controllers
  final _nomorController = TextEditingController();
  late final DetailPrefixController controller;

  // Selected produk
  String? selectedProductCode;
  double selectedPrice = 0;

  // Cubits
  late final ProviderPrefixCubit prefixCubit;
  late final TransaksiHelperCubit sendTransaksi;
  late final FlowCubit flowCubit;

  @override
  void initState() {
    super.initState();

    // Ambil cubit dari context
    prefixCubit = context.read<ProviderPrefixCubit>();
    sendTransaksi = context.read<TransaksiHelperCubit>();
    flowCubit = context.read<FlowCubit>();

    // Init controller utama
    controller = DetailPrefixController(
      nomorController: _nomorController,
      prefixCubit: prefixCubit,
      transaksiCubit: sendTransaksi,
      flowCubit: flowCubit,
      refresh: setState,
    );

    // Clear controller ketika pertama tampil
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initClear();
    });
  }

  // Ketika user memilih produk
  Future<void> onProdukSelected(Produk produk) async {
    setState(() {
      selectedProductCode = produk.kodeProduk;
      selectedPrice = produk.hargaJual.toDouble();
    });

    // Set produk terpilih ke TransaksiHelperCubit
    sendTransaksi.pilihProduk(
      kode: produk.kodeProduk,
      nama: produk.namaProduk,
      harga: selectedPrice,
      isBebasNominalApi: produk.bebasNominal,
      isEndUserApi: produk.endUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flowState = context.watch<FlowCubit>().state!;
    final iconItem = flowState.layananItem;

    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;
    final bool isLastPage = currentIndex == sequence.length - 1;

    final nomorTujuan = _nomorController.text.trim();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (currentIndex > 0) {
          flowCubit.previousPage();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: Text(
            iconItem.title ?? '',
            style: const TextStyle(color: kWhite),
          ),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),

        body: Column(
          children: [
            // Input nomor HP
            InputNomorPrefixWidget(
              nomorController: _nomorController,
              controller: controller,
            ),

            // List provider + produk
            Expanded(
              child: BlocBuilder<ProviderPrefixCubit, ProviderPrefixState>(
                builder: (context, state) {
                  if (_nomorController.text.isEmpty) {
                    return const Center(child: Text('Silahkan isi nomor HP'));
                  }

                  // Loading
                  if (state is ProviderPrefixLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kOrange),
                    );
                  }

                  // Error
                  if (state is ProviderPrefixError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: kRed),
                      ),
                    );
                  }

                  // Success
                  if (state is ProviderPrefixSuccess) {
                    if (state.providers.isEmpty) {
                      return const Center(child: Text('Data tidak tersedia'));
                    }

                    return ListView.builder(
                      itemCount: state.providers.length,
                      itemBuilder: (context, index) {
                        final provider = state.providers[index];
                        final produkList = provider.produk;

                        return Card(
                          margin: const .symmetric(horizontal: 12, vertical: 6),
                          color: kWhite,
                          child: ExpansionTile(
                            title: Text(
                              provider.namaProvider,
                              style: const TextStyle(fontWeight: .bold),
                            ),
                            children: produkList.map<Widget>((produk) {
                              final bool isSelected =
                                  controller.selectedProductCode ==
                                  produk.kodeProduk;

                              final bool isGangguan = (produk.gangguan) == 1;

                              return GestureDetector(
                                onTap: isGangguan
                                    ? null
                                    : () => controller.onProdukSelected(
                                        context,
                                        produk,
                                      ),
                                child: PrefixProductItem(
                                  produk: produk,
                                  isSelected: isSelected,
                                  isGangguan: isGangguan,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),

        bottomNavigationBar: controller.selectedProductCode != null
            ? NavigationButtonPrefix(
                selectedProductCode: controller.selectedProductCode,
                selectedPrice: controller.selectedPrice,
                isLastPage: isLastPage,
                sendTransaksi: sendTransaksi,
                nomorTujuan: nomorTujuan,
                flowState: flowState,
                flowCubit: flowCubit,
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _nomorController.clear();
    _nomorController.dispose();
    super.dispose();
  }
}
