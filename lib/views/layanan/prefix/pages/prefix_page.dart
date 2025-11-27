// ignore_for_file: unused_import, unnecessary_string_interpolations

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/dynamic_app_page.dart';
import '../../../../core/utils/dialog.dart';
import '../../../input_nomor/utils/contact_handler.dart';
import '../../cubit/flow_cubit.dart';
import '../../../../data/models/layanan/flow_state_models.dart';
import '../../../../core/helper/currency.dart';
import '../../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../../transaksi/pages/konfirmasi_pembayaran_page.dart';
import '../cubit/provider_prefix_cubit.dart';
import '../helper/prefix_controller.dart';
import '../widgets/widget_input_nomor_prefix.dart';
import '../widgets/widget_navigation_button_prefix.dart';

class DetailPrefixPage extends StatefulWidget {
  const DetailPrefixPage({super.key});

  @override
  State<DetailPrefixPage> createState() => _DetailPrefixPageState();
}

class _DetailPrefixPageState extends State<DetailPrefixPage> {
  final _nomorController = TextEditingController();

  late final DetailPrefixController controller;
  String? selectedProductCode;
  double selectedPrice = 0;

  late final ProviderPrefixCubit prefixCubit;
  late final TransaksiHelperCubit sendTransaksi;
  late final FlowCubit flowCubit;

  @override
  void initState() {
    super.initState();

    // baca cubit dari context
    prefixCubit = context.read<ProviderPrefixCubit>();
    sendTransaksi = context.read<TransaksiHelperCubit>();
    flowCubit = context.read<FlowCubit>();

    controller = DetailPrefixController(
      nomorController: _nomorController,
      prefixCubit: prefixCubit,
      transaksiCubit: sendTransaksi,
      flowCubit: flowCubit,
      setStateCallback: (fn) {
        if (mounted) setState(fn);
      },
    );

    _nomorController.text = "";

    // clear providers frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initClear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _nomorController.dispose();
    super.dispose();
  }

  Future<void> onProdukSelected(dynamic produk) async {
    setState(() {
      selectedProductCode = produk.kodeProduk;
      selectedPrice = (produk.hargaJual ?? 0).toDouble();
    });

    context.read<TransaksiHelperCubit>()
      ..setKodeproduk(produk.kodeProduk)
      ..setNamaProduk(produk.namaProduk)
      ..setProductPrice(produk.hargaJual)
      ..isBebasNominal(produk.bebasNominal)
      ..isEndUser(produk.endUser);
  }

  @override
  Widget build(BuildContext context) {
    final flowState = context.watch<FlowCubit>().state!;
    final iconItem = flowState.layananItem;
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;

    final nomorTujuan = _nomorController.text.trim();
    final bool isLastPage = currentIndex == sequence.length - 1;

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
            // field input nomor
            InputNomorPrefixWidget(
              nomorController: _nomorController,
              controller: controller,
            ),

            // list produk dengan accordion
            Expanded(
              child: BlocBuilder<ProviderPrefixCubit, ProviderPrefixState>(
                builder: (context, state) {
                  if (_nomorController.text.isEmpty) {
                    return const Center(child: Text('Silahkan isi nomor HP'));
                  }

                  if (state is ProviderPrefixLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kOrange),
                    );
                  }

                  if (state is ProviderPrefixError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(state.message, style: TextStyle(color: kRed)),
                    );
                  }

                  if (state is ProviderPrefixSuccess) {
                    if (state.providers.isEmpty) {
                      return const Center(child: Text('Data tidak tersedia'));
                    }

                    return ListView.builder(
                      itemCount: state.providers.length,
                      itemBuilder: (context, index) {
                        final provider = state.providers[index];
                        final List produkList = provider.produk;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          color: kWhite,
                          child: ExpansionTile(
                            title: Text(
                              provider.namaProvider,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: produkList.map<Widget>((produk) {
                              final bool isSelected =
                                  selectedProductCode == produk.kodeProduk;
                              final bool isGangguan =
                                  (produk.gangguan ?? 0) == 1;

                              return GestureDetector(
                                onTap: isGangguan
                                    ? null
                                    : () => onProdukSelected(produk),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isGangguan
                                        ? kNeutral20
                                        : isSelected
                                        ? kOrange
                                        : kWhite,
                                    border: Border.all(
                                      color: isGangguan
                                          ? kRed
                                          : isSelected
                                          ? Colors.deepOrange
                                          : Colors.grey.shade300,
                                      width: isGangguan ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (isGangguan)
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.cancel,
                                                    color: kRed,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Gangguan",
                                                    style: TextStyle(
                                                      color: kRed,
                                                      fontSize: kSize12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Text(
                                              produk.namaProduk,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isGangguan
                                                    ? kRed
                                                    : isSelected
                                                    ? kWhite
                                                    : kBlack,
                                              ),
                                            ),
                                            Text(
                                              produk.kodeProduk,
                                              style: TextStyle(
                                                color: isGangguan
                                                    ? kRed
                                                    : isSelected
                                                    ? kWhite
                                                    : kBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${CurrencyUtil.formatCurrency(produk.hargaJual)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isGangguan
                                              ? kRed
                                              : isSelected
                                              ? kWhite
                                              : kBlack,
                                        ),
                                      ),
                                    ],
                                  ),
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
        // tombol selanjutnya
        bottomNavigationBar: selectedProductCode != null
            ? NavigationButtonPrefix(
                selectedProductCode: selectedProductCode,
                selectedPrice: selectedPrice,
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
}
