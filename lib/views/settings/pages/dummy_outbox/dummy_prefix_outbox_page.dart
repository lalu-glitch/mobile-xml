// ignore_for_file: unused_import, unnecessary_string_interpolations

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../core/helper/dynamic_app_page.dart';
import '../../../input_nomor/transaksi_cubit.dart';
import '../../../layanan/cubit/flow_cubit.dart';
import '../../../layanan/prefix/cubit/provider_prefix_cubit.dart';
import 'dummy_konfirmasi_pembayaran.dart';

class DummyPrefixOutboxPage extends StatefulWidget {
  const DummyPrefixOutboxPage({super.key});

  @override
  State<DummyPrefixOutboxPage> createState() => _DummyPrefixOutboxPageState();
}

class _DummyPrefixOutboxPageState extends State<DummyPrefixOutboxPage> {
  final TextEditingController _nomorController = TextEditingController();
  Timer? _debounce;
  String? selectedProductCode;
  double selectedPrice = 0;

  @override
  void initState() {
    super.initState();
    _nomorController.text = "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderPrefixCubit>().clear();
    });
  }

  Future<void> _fetchProvider(String value) async {
    if (value.length >= 4) {
      final readTransaksi = context.read<TransaksiCubit>().getData();
      await context.read<ProviderPrefixCubit>().fetchProvidersPrefix(
        readTransaksi.filename ?? '-',
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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "DUMMY PREFIX OUTBOX",
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
                      ),
                      hintText: "0812 1111 2222",
                      suffixIcon: const Icon(Icons.contact_page),
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
                                                        fontSize:
                                                            Screen.kSize12,
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

                  return Container(
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
                            fontSize: Screen.kSize16,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DummyKonfirmasiPembayaranPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Selanjutnya",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
