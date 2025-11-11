import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/shimmer.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../cubit/layanan_cubit.dart';

class HomeLayananSection extends StatelessWidget {
  const HomeLayananSection({super.key});

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>();
    final cubit = context.read<LayananCubit>();

    return BlocBuilder<LayananCubit, LayananState>(
      builder: (context, state) {
        if (state is LayananLoading) {
          return ShimmerBox.buildShimmerIcons();
        }
        if (state is LayananLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cubit.layananByHeading.entries.map((entry) {
              final kategori = entry.key;
              final layananList = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori.toUpperCase(),
                    style: TextStyle(
                      fontSize: kSize18,
                      fontWeight: FontWeight.bold,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: layananList.length,
                      itemBuilder: (context, i) {
                        final iconItem = layananList[i];

                        return GestureDetector(
                          onTap: () {
                            final sequence = pageSequences[iconItem.flow] ?? [];

                            // simpan state awal ke FlowCubit
                            context.read<FlowCubit>().startFlow(
                              iconItem.flow!,
                              iconItem,
                            );

                            // simpan kodeCatatan untuk prefix page
                            transaksi.setKodeCatatan(iconItem.kodeCatatan);

                            // navigasi ke halaman pertama dari flow
                            final firstPage = sequence[0];
                            Navigator.pushNamed(
                              context,
                              pageRoutes[firstPage]!,
                            );
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CachedNetworkImage(
                                  imageUrl: iconItem.url ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const SizedBox(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.apps, color: kOrange),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  iconItem.title ?? '-',
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
                ],
              );
            }).toList(),
          );
        }
        if (state is LayananError) {
          return ShimmerBox.buildShimmerIcons();
        }
        return SizedBox.shrink();
      },
    );
  }
}
