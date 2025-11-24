import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/error_handler.dart';
import '../../../core/utils/shimmer.dart';
import '../../../data/models/layanan/layanan_model.dart';
import '../../home/cubit/layanan_cubit.dart';
import '../helper/shop_controller.dart';
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
  late final ShopController controller;

  bool isSearching = false;
  String selectedHeading = 'Semuanya';
  Map<String, List<IconItem>> filteredLayanan = {};

  @override
  void initState() {
    super.initState();

    controller = ShopController(
      searchController: searchController,
      layananCubit: context.read<LayananCubit>(),
    );

    //realtime listener
    searchController.addListener(_updateFilteredData);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<LayananCubit>().fetchLayanan();
      _updateFilteredData();
    });
  }

  void _updateFilteredData() {
    final query = searchController.text;
    filteredLayanan = controller.filter(query: query);
    setState(() {});
  }

  void onClearText() {
    searchController.clear();
    _updateFilteredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kOrange,
        iconTheme: IconThemeData(color: kWhite),
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
        actions: [
          SearchAppBar(
            isSearching: isSearching,
            onSearchChanged: (value) => setState(() => isSearching = value),
            onClear: onClearText,
          ),
        ],
      ),

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
            // Ketika data fresh dari cubit → refresh filter
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateFilteredData();
            });

            final cubit = context.read<LayananCubit>();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Kategori chips
                  ShopsCategoryChips(
                    cubit: cubit,
                    selectedHeading: selectedHeading,
                    onHeadingSelected: (heading) {
                      setState(() => selectedHeading = heading);
                    },
                  ),

                  const Divider(color: kNeutral50, thickness: 4),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
