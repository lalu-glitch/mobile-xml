import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../widgets/widget_shop_grid_item.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            // Logic margin agar yang terakhir tidak ada margin
            margin: EdgeInsets.only(
              bottom: (entries.last.key == entry.key) ? 0 : 24,
            ),
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
              // PERFORMA FIX: Menggunakan Widget terpisah (const)
              itemBuilder: (context, i) {
                return ShopGridItem(item: layananList[i]);
              },
            ),
          ),
          // Tambahan spacer jika bukan item terakhir (alternatif logic margin di atas)
          if (entries.last.key != entry.key) const SizedBox(height: 12),
        ];
      }).toList(),
    );
  }
}
