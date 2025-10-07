import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';

import '../../layanan/cubit/flow_cubit.dart';
import '../../../viewmodels/layanan_vm.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';

class LayananSection extends StatelessWidget {
  const LayananSection({required this.layananVM, super.key});

  final LayananViewModel layananVM;

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiCubit>();

    if (layananVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (layananVM.error != null) {
      return Center(child: Text("Terjadi kesalahan: ${layananVM.error}"));
    }

    if (layananVM.layananByHeading.isEmpty) {
      return const Center(child: Text("Tidak ada layanan tersedia."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layananVM.layananByHeading.entries.map((entry) {
        final kategori = entry.key; // contoh: "Prabayar", "Tagihan", "E-Wallet"
        final layananList = entry.value; // List<IconItem>

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kategori.toUpperCase(),
              style: TextStyle(
                fontSize: Screen.kSize18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: layananList.length,
                itemBuilder: (context, i) {
                  final item = layananList[i]; // IconItem

                  return GestureDetector(
                    onTap: () {
                      final sequence = pageSequences[item.flow] ?? [];

                      if (sequence.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid flow ID: ${item.flow}'),
                          ),
                        );
                        return;
                      }

                      // Simpan state awal ke FlowCubit
                      context.read<FlowCubit>().startFlow(item.flow!, item);

                      // Simpan filename untuk prefix page
                      transaksi.setFileName(item.filename ?? '');

                      // Navigasi ke halaman pertama dari flow
                      final firstPage = sequence[0];
                      Navigator.pushNamed(context, pageRoutes[firstPage]!);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: item.url ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.apps,
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            item.filename ?? '-',
                            style: TextStyle(fontSize: Screen.kSize12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
}
