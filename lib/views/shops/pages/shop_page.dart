import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/error_handler.dart';
import '../../../core/utils/shimmer.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../../home/cubit/layanan_cubit.dart';
import '../widgets/shop_category_chips.dart';
import '../../../core/utils/search_appbar_actions.dart';
import 'shop_product.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final searchController = TextEditingController();
  bool isSearching = false;
  String selectedHeading = 'Semuanya';
  Map<String, List<IconItem>> filteredLayanan = {};

  @override
  void initState() {
    super.initState();

    // Jalankan fetch setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<LayananCubit>().fetchLayanan();
      _updateFilteredData();
    });

    // Listener realtime pencarian
    searchController.addListener(_updateFilteredData);
  }

  void _updateFilteredData() {
    final query = searchController.text.toLowerCase();
    final allData = context.read<LayananCubit>().layananByHeading;

    setState(() {
      if (query.isEmpty) {
        filteredLayanan = Map.from(allData);
      } else {
        filteredLayanan = {
          for (final entry in allData.entries)
            if (entry.value.any(
              (item) => item.title?.toLowerCase().contains(query) ?? false,
            ))
              entry.key: entry.value
                  .where(
                    (item) =>
                        item.title?.toLowerCase().contains(query) ?? false,
                  )
                  .toList(),
        };
      }
    });
  }

  void onClearText() {
    setState(() {
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: kWhite),
                decoration: InputDecoration(
                  hintText: 'Cari layanan',
                  hintStyle: TextStyle(color: kWhite.withAlpha(200)),
                  border: InputBorder.none,
                ),
              )
            : Text('Layanan Toko', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: IconThemeData(color: kWhite),
        actions: [
          SearchAppBar(
            isSearching: isSearching,
            onSearchChanged: (value) => setState(() => isSearching = value),
            onClear: onClearText,
          ),
        ],
      ),

      // === BODY ===
      body: BlocBuilder<LayananCubit, LayananState>(
        builder: (context, state) {
          if (state is LayananLoading) {
            return Column(
              children: [
                ShimmerBox.buildShimmerChips(),
                const Divider(color: kNeutral50, thickness: 4),
                ShimmerBox.buildShimmerIcons(),
              ],
            );
          }

          if (state is LayananError) {
            return ErrorHandler(
              message: 'Gagal memuat layanan',
              onRetry: () => context.read<LayananCubit>().fetchLayanan(),
            );
          }

          if (state is LayananLoaded) {
            // Update data filter dengan data terbaru
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateFilteredData();
            });

            final cubit = context.read<LayananCubit>();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Kategori
                  ShopsCategoryChips(
                    cubit: cubit,
                    selectedHeading: selectedHeading,
                    onHeadingSelected: (heading) =>
                        setState(() => selectedHeading = heading),
                  ),

                  const Divider(color: kNeutral50, thickness: 4),

                  // Produk
                  Padding(
                    padding: const .all(16.0),
                    child: ShopProducts(
                      layananDataToDisplay: filteredLayanan,
                      selectedHeading: selectedHeading,
                      isSearchingActive:
                          isSearching && searchController.text.isNotEmpty,
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_updateFilteredData);
    searchController.dispose();
    super.dispose();
  }
}
