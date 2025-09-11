// ignore_for_file: unused_import, unnecessary_string_interpolations

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../data/models/icon_models/icon_data.dart';
import '../core/utils/currency.dart';
import '../viewmodels/provider_kartu_viewmodel.dart';
import 'konfirmasi_page.dart';

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

  @override
  void initState() {
    super.initState();
    _nomorController.text = "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderViewModel>(context, listen: false).clearProviders();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nomorController.dispose();
    super.dispose();
  }

  Future<void> _fetchProvider(String value) async {
    if (value.length >= 4) {
      final iconItem = ModalRoute.of(context)!.settings.arguments as IconItem;
      final providerVM = Provider.of<ProviderViewModel>(context, listen: false);
      await providerVM.fetchProvidersPrefix(iconItem.filename, value);
    }
  }

  void _onNomorChanged(String value) {
    final providerVM = Provider.of<ProviderViewModel>(context, listen: false);
    providerVM.clearProviders();

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.length >= 4) {
      _debounce = Timer(const Duration(milliseconds: 800), () {
        _fetchProvider(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconItem = ModalRoute.of(context)!.settings.arguments as IconItem;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          iconItem.filename,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
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
                  onSubmitted: _fetchProvider,
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
            child: Consumer<ProviderViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${vm.error}",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  );
                }
                if (vm.providers.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Input Nomor Tujuan"),
                  );
                }

                return ListView.builder(
                  itemCount: vm.providers.length,
                  itemBuilder: (context, index) {
                    final provider = vm.providers[index];
                    final List produkList = provider.produk;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          provider.namaProvider,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          ...produkList.map((produk) {
                            final bool isSelected =
                                selectedProductCode == produk.kode_produk;
                            final bool isGangguan = produk.gangguan == 1;

                            return GestureDetector(
                              onTap: isGangguan
                                  ? null
                                  : () {
                                      setState(() {
                                        selectedProductCode =
                                            produk.kode_produk;
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
                                      ? Colors.orangeAccent[700]
                                      : Colors.white,
                                  border: Border.all(
                                    color: isGangguan
                                        ? Colors.red
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
                                                  color: Colors.red,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Gangguan",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          Text(
                                            produk.namaProduk,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isGangguan
                                                  ? Colors.red
                                                  : isSelected
                                                  ? Colors.white
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
                                            ? Colors.red
                                            : isSelected
                                            ? Colors.white
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
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedProductCode != null
          ? Consumer<ProviderViewModel>(
              builder: (context, vm, child) {
                final selectedProduk = vm.providers
                    .expand((p) => p.produk)
                    .where((p) => p.kode_produk == selectedProductCode)
                    .firstOrNull;

                if (selectedProduk == null) return SizedBox.shrink();

                return Container(
                  color: Colors.orangeAccent[700],
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orangeAccent[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/konfirmasiPembayaran',
                            arguments: {
                              'tujuan': _nomorController.text,
                              'kode_produk': selectedProduk.kode_produk,
                              'namaProduk': selectedProduk.namaProduk,
                              'total': selectedProduk.hargaJual.toDouble(),
                            },
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
    );
  }
}
