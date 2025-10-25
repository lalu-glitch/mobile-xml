import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';

import '../../../core/utils/shimmer.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../../../viewmodels/layanan_vm.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';

class HomeContentSection extends StatelessWidget {
  const HomeContentSection({required this.layananVM, super.key});

  final LayananViewModel layananVM;

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>();

    if (layananVM.isLoading) {
      return ShimmerBox.buildShimmerIcons();
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
              style: TextStyle(fontSize: kSize18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              margin: const EdgeInsets.only(bottom: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
                ),
                itemCount: layananList.length,
                itemBuilder: (context, i) {
                  final item = layananList[i]; // IconItem

                  return GestureDetector(
                    onTap: () {
                      final sequence = pageSequences[item.flow] ?? [];

                      // Simpan state awal ke FlowCubit
                      context.read<FlowCubit>().startFlow(item.flow!, item);

                      // // Simpan kodeCatatan untuk prefix page
                      transaksi.setKodeCatatan(item.kodeCatatan);

                      // Navigasi ke halaman pertama dari flow
                      final firstPage = sequence[0];
                      Navigator.pushNamed(context, pageRoutes[firstPage]!);
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: item.url ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.apps, color: kOrange),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            item.title ?? '-',
                            style: TextStyle(fontSize: kSize12),
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
            // const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
}
