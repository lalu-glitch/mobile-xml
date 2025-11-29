import 'package:flutter/material.dart';

import '../../../data/models/layanan/layanan_model.dart';
import '../../home/cubit/layanan_cubit.dart';

class ShopController {
  final TextEditingController searchController;
  final LayananCubit layananCubit;

  ShopController({required this.searchController, required this.layananCubit});

  Map<String, List<IconItem>> filter({
    required String query,
    required List<SectionItem> dataMentah,
  }) {
    final allData = layananCubit.layananByHeading;
    if (query.isEmpty) return Map.from(allData);

    final lower = query.toLowerCase();

    return {
      for (final entry in allData.entries)
        if (entry.value.any(
          (item) => item.title?.toLowerCase().contains(lower) ?? false,
        ))
          entry.key: entry.value
              .where(
                (item) => item.title?.toLowerCase().contains(lower) ?? false,
              )
              .toList(),
    };
  }
}
