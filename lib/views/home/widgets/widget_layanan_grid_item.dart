import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../../transaksi/cubit/transaksi_omni/transaksi_omni_cubit.dart';

class LayananGridItem extends StatelessWidget {
  final dynamic item;

  const LayananGridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Pindahkan logic pembacaan provider ke sini agar tidak membebani method build parent
        final transaksi = context.read<TransaksiHelperCubit>();
        final transaksiOmni = context.read<TransaksiOmniCubit>();
        final flowCubit = context.read<FlowCubit>();

        transaksi.reset();
        transaksiOmni.reset();
        final sequence = pageSequences[item.flow] ?? [];

        flowCubit.startFlow(item.flow!, item);

        transaksi.pilihMenuLayanan(
          kodeCatatan: item.kodeCatatan,
          kodeCek: item.kodeCek,
          kodeBayar: item.kodeBayar,
        );

        final firstPage = sequence[0];
        Navigator.pushNamed(context, pageRoutes[firstPage]!);
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: item.icon ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              memCacheWidth: 150,
              memCacheHeight: 150,
              placeholder: (context, url) =>
                  const SizedBox(width: 50, height: 50),
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
  }
}
