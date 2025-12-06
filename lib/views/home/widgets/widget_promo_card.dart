import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/shimmer.dart';
import '../../layanan/cubit/flow_cubit.dart';

class PromoCard extends StatelessWidget {
  final dynamic item;

  const PromoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final sequence = pageSequences[item.flow] ?? [];
        context.read<FlowCubit>().startFlow(item.flow!, item);

        if (sequence.isNotEmpty) {
          Navigator.pushNamed(context, pageRoutes[sequence[0]]!);
        }
      },
      child: Container(
        width: 300,
        margin: const .only(right: 24),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CachedNetworkImage(
            imageUrl: item.icon ?? '',
            fit: BoxFit.cover,
            memCacheWidth: 600,
            placeholder: (context, url) => ShimmerBox.buildShimmerCardPromo(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.image_not_supported),
          ),
        ),
      ),
    );
  }
}
