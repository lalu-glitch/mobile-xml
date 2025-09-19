import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/helper/constant_finals.dart';
import '../core/helper/dynamic_app_page.dart';
import '../core/helper/flow_cubit.dart';
import '../core/helper/currency.dart';
import '../viewmodels/provider_kartu_viewmodel.dart';
import 'input_nomor/transaksi_cubit.dart';

class DetailNoPrefixPage extends StatefulWidget {
  const DetailNoPrefixPage({super.key});

  @override
  State<DetailNoPrefixPage> createState() => _DetailNoPrefixPageState();
}

class _DetailNoPrefixPageState extends State<DetailNoPrefixPage> {
  String? selectedProductCode;
  double selectedPrice = 0;
  dynamic selectedProduk;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flowState = context.read<FlowCubit>().state!;
      final iconItem = flowState.iconItem;

      Provider.of<ProviderViewModel>(
        context,
        listen: false,
      ).fetchProviders(iconItem.filename, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final flowState = context.watch<FlowCubit>().state!;
    final flowCubit = context.read<FlowCubit>();
    final transaksi = context.read<TransaksiCubit>();
    final iconItem = flowState.iconItem;
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;

    final bool isLastPage = currentIndex == sequence.length - 1;

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          flowCubit.previousPage();
          Provider.of<ProviderViewModel>(
            context,
            listen: false,
          ).clearProviders();
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(iconItem.filename, style: const TextStyle(color: kWhite)),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: Consumer<ProviderViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(
                child: Text(vm.error!, style: const TextStyle(color: kRed)),
              );
            }
            if (vm.providers.isEmpty) {
              return const Center(child: Text('Data tidak tersedia'));
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
                            selectedProductCode == produk.kodeProduk;
                        final bool isGangguan = produk.gangguan == 1;
                        return GestureDetector(
                          onTap: isGangguan
                              ? null
                              : () {
                                  setState(() {
                                    selectedProductCode = produk.kodeProduk;
                                    selectedPrice = produk.hargaJual.toDouble();
                                    selectedProduk = produk;
                                  });
                                  // update TransaksiCubit sekaligus
                                  transaksi.setKodeproduk(produk.kodeProduk);
                                  transaksi.setNamaProduk(produk.namaProduk);
                                  transaksi.setNominal(produk.hargaJual);
                                  transaksi.setBebasNominal(
                                    produk.bebasNominal,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isGangguan)
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.cancel,
                                              color: kRed,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Gangguan",
                                              style: TextStyle(color: kRed),
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
                                  CurrencyUtil.formatCurrency(produk.hargaJual),
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
          },
        ),
        bottomNavigationBar: selectedProductCode != null
            ? Container(
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
                        if (!isLastPage) {
                          // update index ke halaman berikut
                          final nextPage =
                              flowState.sequence[flowState.currentIndex + 1];

                          flowCubit.nextPage();
                          Navigator.pushNamed(context, pageRoutes[nextPage]!);
                        } else {
                          // halaman terakhir → langsung ke konfirmasi
                          Navigator.pushNamed(context, '/konfirmasiPembayaran');
                        }
                      },
                      child: Text(
                        isLastPage ? "Selanjutnya" : "Next",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
