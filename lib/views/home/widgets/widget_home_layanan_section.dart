import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/shimmer.dart';
import '../cubit/layanan_cubit.dart';
import 'widget_layanan_grid_item.dart';

class HomeLayananSection extends StatelessWidget {
  const HomeLayananSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayananCubit, LayananState>(
      buildWhen: (previous, current) =>
          current is LayananLoaded || current is LayananLoading,
      builder: (context, state) {
        if (state is LayananLoading) {
          return ShimmerBox.buildShimmerIcons();
        }
        if (state is LayananLoaded) {
          final cubit = context.read<LayananCubit>();

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
                      // Optimization: Menggunakan function terpisah atau class terpisah
                      // membantu Flutter mengenali boundary widget.
                      itemBuilder: (context, i) {
                        return LayananGridItem(item: layananList[i]);
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
