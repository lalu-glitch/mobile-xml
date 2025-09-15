import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/helper/constant_finals.dart';
import '../core/helper/dynamic_app_page.dart';
import '../data/models/icon_models/icon_data.dart';
import '../core/helper/currency.dart';
import '../viewmodels/provider_kartu_viewmodel.dart';

// class DetailNoPrefixPage extends StatefulWidget {
//   const DetailNoPrefixPage({super.key});

//   @override
//   State<DetailNoPrefixPage> createState() => _DetailNoPrefixPageState();
// }

// class _DetailNoPrefixPageState extends State<DetailNoPrefixPage> {
//   String? selectedProductCode;
//   double selectedPrice = 0;
//   dynamic selectedProduk; // TAMBAH: Simpan data produk yang dipilih

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final iconItem = ModalRoute.of(context)!.settings.arguments as IconItem;
//       Provider.of<ProviderViewModel>(
//         context,
//         listen: false,
//       ).fetchProviders(iconItem.filename, "");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final iconItem = ModalRoute.of(context)!.settings.arguments as IconItem;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(iconItem.filename, style: const TextStyle(color: kWhite)),
//         backgroundColor: kOrange,
//         iconTheme: const IconThemeData(color: kWhite),
//       ),
//       body: Consumer<ProviderViewModel>(
//         builder: (context, vm, child) {
//           if (vm.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (vm.error != null) {
//             return Center(
//               child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
//             );
//           }
//           if (vm.providers.isEmpty) {
//             return const Center(child: Text("Data tidak tersedia"));
//           }

//           return ListView.builder(
//             itemCount: vm.providers.length,
//             itemBuilder: (context, index) {
//               final provider = vm.providers[index];
//               final List produkList = provider.produk;

//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: ExpansionTile(
//                   title: Text(
//                     provider.namaProvider,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   children: [
//                     ...produkList.map((produk) {
//                       final bool isSelected =
//                           selectedProductCode == produk.kode_produk;
//                       final bool isGangguan = produk.gangguan == 1;

//                       return GestureDetector(
//                         onTap: isGangguan
//                             ? null
//                             : () {
//                                 setState(() {
//                                   selectedProductCode = produk.kode_produk;
//                                   selectedPrice = produk.hargaJual.toDouble();
//                                   selectedProduk = produk;
//                                 });
//                               },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             color: isGangguan
//                                 ? Colors.grey.shade200
//                                 : isSelected
//                                 ? kOrange
//                                 : kWhite,
//                             border: Border.all(
//                               color: isGangguan
//                                   ? Colors.red
//                                   : isSelected
//                                   ? Colors.deepOrange
//                                   : Colors.grey.shade300,
//                               width: isGangguan ? 2 : 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Flexible(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (isGangguan)
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.cancel,
//                                             color: Colors.red,
//                                             size: 14,
//                                           ),
//                                           SizedBox(width: 4),
//                                           Text(
//                                             "Gangguan",
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 12.sp,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     Text(
//                                       produk.namaProduk,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: isGangguan
//                                             ? Colors.red
//                                             : isSelected
//                                             ? kWhite
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(
//                                 CurrencyUtil.formatCurrency(produk.hargaJual),
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: isGangguan
//                                       ? Colors.red
//                                       : isSelected
//                                       ? kWhite
//                                       : Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: selectedProductCode != null
//           ? Container(
//               color: kOrange,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Total ${CurrencyUtil.formatCurrency(selectedPrice)}",
//                     style: TextStyle(
//                       color: kWhite,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.sp,
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kWhite,
//                       foregroundColor: kOrange,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pushNamed(
//                         context,
//                         '/inputNomorTujuan',
//                         arguments: {
//                           'kode_produk': selectedProduk.kode_produk,
//                           'namaProduk': selectedProduk.namaProduk,
//                           'total': selectedProduk.hargaJual.toDouble(),
//                         },
//                       );
//                     },
//                     child: const Text(
//                       "Selanjutnya",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : null,
//     );
//   }
// }

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
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final iconItem = args['iconItem'] as IconItem;
      Provider.of<ProviderViewModel>(
        context,
        listen: false,
      ).fetchProviders(iconItem.filename, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ambil arguments sebagai Map
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final iconItem = args['iconItem'] as IconItem;
    final int flow = args['flow'] as int;
    final int currentIndex = args['currentIndex'] as int;
    final List<AppPage> sequence = args['sequence'] as List<AppPage>;
    final String? nomorTujuan =
        args['nomorTujuan'] as String?; // Ambil data sebelumnya jika ada

    final bool isLastPage = currentIndex == sequence.length - 1;

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          // Navigate ke previous page di sequence
          Navigator.pushReplacementNamed(
            context,
            pageRoutes[sequence[currentIndex - 1]]!,
            arguments: {
              'flow': flow,
              'iconItem': iconItem,
              'currentIndex': currentIndex - 1,
              'sequence': sequence,
              'nomorTujuan': nomorTujuan, // Pass data sebelumnya
            },
          );
          return false; // Cegah pop default
        }
        return true; // Pop ke LayananSection jika di page pertama
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
                child: Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (vm.providers.isEmpty) {
              return const Center(child: Text("Data tidak tersedia"));
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
                                    selectedProductCode = produk.kode_produk;
                                    selectedPrice = produk.hargaJual.toDouble();
                                    selectedProduk = produk;
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
                                    ? Colors.red
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
                                        ? Colors.red
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
                        fontSize: 16.sp,
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
                          // Navigate ke next page di sequence
                          Navigator.pushNamed(
                            context,
                            pageRoutes[sequence[currentIndex + 1]]!,
                            arguments: {
                              'flow': flow,
                              'iconItem': iconItem,
                              'currentIndex': currentIndex + 1,
                              'sequence': sequence,
                              'nomorTujuan':
                                  nomorTujuan, // Pass data sebelumnya
                              'kode_produk': selectedProduk.kode_produk,
                              'namaProduk': selectedProduk.namaProduk,
                              'total': selectedProduk.hargaJual.toDouble(),
                            },
                          );
                        } else {
                          // Page terakhir: Ke konfirmasi
                          Navigator.pushNamed(
                            context,
                            '/konfirmasiPembayaran',
                            arguments: {
                              'tujuan':
                                  nomorTujuan ??
                                  '', // Gunakan empty string jika null
                              'kode_produk': selectedProduk.kode_produk,
                              'namaProduk': selectedProduk.namaProduk,
                              'total': selectedProduk.hargaJual.toDouble(),
                            },
                          );
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
