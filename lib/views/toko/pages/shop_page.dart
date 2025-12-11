import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/error_handler.dart';
import '../../home/cubit/layanan_cubit.dart';
import '../helper/shop_controller.dart';
import '../widgets/widget_shop_category_chips.dart';
import '../../../core/utils/search_appbar_actions.dart';
import 'shop_product.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final searchController = TextEditingController();
  late final ShopController controller; // Helper logic tetap dipisah (bagus)

  bool isSearching = false;
  String selectedHeading = 'Semuanya';

  @override
  void initState() {
    super.initState();
    controller = ShopController(
      searchController: searchController,
      layananCubit: context.read<LayananCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: kWhite),
                // Rebuild hanya saat user berhenti mengetik (opsional) atau tiap ketik
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari layanan',
                  hintStyle: TextStyle(color: kWhite.withAlpha(200)),
                  border: InputBorder.none,
                ),
              )
            : const Text('Toko', style: TextStyle(color: kWhite)),
        actions: [
          SearchAppBar(
            isSearching: isSearching,
            onSearchChanged: (value) {
              setState(() {
                isSearching = value;
                if (!isSearching) searchController.clear();
              });
            },
            onClear: () => setState(() => searchController.clear()),
          ),
        ],
      ),
      body: BlocBuilder<LayananCubit, LayananState>(
        builder: (context, state) {
          if (state is LayananLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kOrange, strokeWidth: 5),
            );
          }

          if (state is LayananError) {
            return ErrorHandler(
              message: 'Gagal memuat layanan',
              onRetry: () => context.read<LayananCubit>().fetchLayanan(),
            );
          }

          if (state is LayananLoaded) {
            final cubit = context.read<LayananCubit>();

            // Filter logic
            final filteredResult = controller.filter(
              dataMentah: state.data.data,
              query: searchController.text,
            );

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
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
                      layananDataToDisplay: filteredResult,
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
    searchController.dispose();
    super.dispose();
  }
}
