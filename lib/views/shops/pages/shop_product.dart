import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';

class ShopProducts extends StatelessWidget {
  const ShopProducts({
    required this.layananDataToDisplay,
    required this.selectedHeading,
    required this.isSearchingActive,
    super.key,
  });

  final Map<String, List<IconItem>> layananDataToDisplay;
  final String selectedHeading;
  final bool isSearchingActive;

  @override
  Widget build(BuildContext context) {
    if (layananDataToDisplay.isEmpty) {
      return const Center(child: Text("Tidak ada layanan tersedia."));
    }

    final bool shouldFilterByCategory =
        !isSearchingActive && selectedHeading != 'Semuanya';

    final Iterable<MapEntry<String, List<IconItem>>> entries =
        shouldFilterByCategory
        ? layananDataToDisplay.entries.where(
            (entry) => entry.key == selectedHeading,
          )
        : layananDataToDisplay.entries;

    return Column(
      crossAxisAlignment: .start,
      children: entries.expand((entry) {
        final kategori = entry.key;
        final layananList = entry.value;

        final bool showCategoryHeader =
            isSearchingActive || selectedHeading == 'Semuanya';

        return [
          if (showCategoryHeader || entries.length > 1) ...[
            Text(
              kategori.toUpperCase(),
              style: TextStyle(fontSize: kSize18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const .symmetric(horizontal: 8, vertical: 16),
            margin: .only(bottom: (entries.last == entry) ? 0 : 24),
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
                final item = layananList[i];
                return GestureDetector(
                  onTap: () {
                    final sequence = pageSequences[item.flow] ?? [];
                    context.read<FlowCubit>().startFlow(item.flow!, item);
                    context.read<TransaksiHelperCubit>().setKodeCatatan(
                      item.kodeCatatan,
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
          if (entries.last != entry) const SizedBox(height: 12),
        ];
      }).toList(),
    );
  }
}
