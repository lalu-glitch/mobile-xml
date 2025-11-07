import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/shimmer.dart';
import '../../../viewmodels/promo_vm.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../../../core/helper/error_handler.dart';

class HomePromoSection extends StatelessWidget {
  const HomePromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final promoVM = context.watch<PromoViewModel>();

    if (promoVM.isLoading) {
      return ShimmerBox.buildShimmerCardPromo();
    }

    if (promoVM.error != null) {
      return ErrorHandler(
        error: promoVM.error,
        onRetry: () => context.read<PromoViewModel>().fetchPromo(),
      );
    }

    if (promoVM.promoList.isEmpty) {
      return ShimmerBox.buildShimmerCardPromo();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pasti Promo',
          style: TextStyle(fontSize: kSize18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: promoVM.promoList.length,
            itemBuilder: (context, i) {
              final item = promoVM.promoList[i];
              return GestureDetector(
                onTap: () {
                  final sequence = pageSequences[item.flow] ?? [];
                  // Simpan state awal ke FlowCubit
                  context.read<FlowCubit>().startFlow(item.flow!, item);
                  final firstPage = sequence[0];
                  Navigator.pushNamed(context, pageRoutes[firstPage]!);
                },
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl: item.icon ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          ShimmerBox.buildShimmerCardPromo(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
