// ignore_for_file: unused_import, unnecessary_string_interpolations

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/dialog.dart';
import '../../input_nomor/utils/contact_handler.dart';
import '../cubit/flow_cubit.dart';
import '../../../data/models/layanan/flow_state_models.dart';
import '../../../core/helper/currency.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../../transaksi/konfirmasi_pembayaran_page.dart';
import 'cubit/provider_prefix_cubit.dart';

class DetailPrefixPage extends StatefulWidget {
  const DetailPrefixPage({super.key});

  @override
  State<DetailPrefixPage> createState() => _DetailPrefixPageState();
}

class _DetailPrefixPageState extends State<DetailPrefixPage> {
  final TextEditingController _nomorController = TextEditingController();
  Timer? _debounce;
  String? selectedProductCode;
  double selectedPrice = 0;

  late final ContactFlowHandler handler;

  @override
  void initState() {
    super.initState();
    _nomorController.text = "";

    handler = ContactFlowHandler(
      context: context,
      nomorController: _nomorController,
      setStateCallback: (fn) {
        if (mounted) {
          setState(fn);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderPrefixCubit>().clear();
    });
  }

  Future<void> _fetchProvider(String value) async {
    if (value.length >= 4) {
      final readTransaksi = context.read<TransaksiCubit>().getData();
      print('transaksi : ${readTransaksi.kodeCatatan}');
      await context.read<ProviderPrefixCubit>().fetchProvidersPrefix(
        readTransaksi.kodeCatatan ?? '-',
        value,
      );
    }
  }

  void _onNomorChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.length >= 4) {
      _debounce = Timer(const Duration(milliseconds: 800), () {
        _fetchProvider(value);
      });
    } else {
      context.read<ProviderPrefixCubit>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flowState = context.watch<FlowCubit>().state!;
    final flowCubit = context.read<FlowCubit>();
    final sendTransaksi = context.read<TransaksiCubit>();
    final iconItem = flowState.layananItem;
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;

    final nomorTujuan = _nomorController.text;
    final bool isLastPage = currentIndex == sequence.length - 1;

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          flowCubit.previousPage();
          Navigator.pop(context);
          return false;
        }
        return true;
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
            // Input Nomor
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nomor Tujuan"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nomorController,
                    onChanged: _onNomorChanged,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: kOrange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: kOrange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: kOrange),
                      ),
                      hintText: "0812 1111 2222",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.contact_page),
                        onPressed: handler.pickContact,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // LIST PROVIDER DENGAN ACCORDION
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
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red[400]),
                      ),
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
                            children: [
                              ...produkList.map((produk) {
                                final bool isSelected =
                                    selectedProductCode == produk.kodeProduk;
                                final bool isGangguan = produk.gangguan == 1;

                                return GestureDetector(
                                  onTap: isGangguan
                                      ? null
                                      : () {
                                          setState(() {
                                            selectedProductCode =
                                                produk.kodeProduk;
                                            selectedPrice = produk.hargaJual
                                                .toDouble();
                                          });
                                          sendTransaksi.setKodeproduk(
                                            produk.kodeProduk,
                                          );
                                          sendTransaksi.setNamaProduk(
                                            produk.namaProduk,
                                          );
                                          sendTransaksi.setNominal(
                                            produk.hargaJual,
                                          );
                                        },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: isGangguan
                                          ? Colors.grey.shade200
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
                                                      : Colors.black,
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
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
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
        bottomNavigationBar: selectedProductCode != null
            ? BlocBuilder<ProviderPrefixCubit, ProviderPrefixState>(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                              if (!isLastPage) {
                                final nextPage = flowState
                                    .sequence[flowState.currentIndex + 1];
                                flowCubit.nextPage();
                                Navigator.pushNamed(
                                  context,
                                  pageRoutes[nextPage]!,
                                );
                              } else {
                                sendTransaksi.setTujuan(nomorTujuan);
                                Navigator.pushNamed(
                                  context,
                                  '/konfirmasiPembayaran',
                                );
                              }
                            },
                            child: Text(
                              isLastPage ? "Selanjutnya" : "Next",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nomorController.dispose();
    super.dispose();
  }
}
