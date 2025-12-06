// EXTRACTED WIDGET: _ShopGridItem
// Ini mengisolasi logic item dari parent list yang kompleks
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../../transaksi/cubit/transaksi_omni/transaksi_omni_cubit.dart';

class ShopGridItem extends StatelessWidget {
  final IconItem item;

  const ShopGridItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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

        final firstPage = sequence.firstOrNull;
        if (firstPage != null) {
          Navigator.pushNamed(context, pageRoutes[firstPage]!);
        }
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
