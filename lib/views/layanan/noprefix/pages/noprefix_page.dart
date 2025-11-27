import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/dynamic_app_page.dart';
import '../../../input_nomor/utils/transaksi_helper_cubit.dart';
import '../../cubit/flow_cubit.dart';
import '../../../../core/helper/currency.dart';
import '../cubit/provider_noprefix_cubit.dart';
import '../helper/noprefix_controller.dart';
import '../widgets/widget_input_nomor_noprefix.dart';

class DetailNoPrefixPage extends StatefulWidget {
  const DetailNoPrefixPage({super.key});

  @override
  State<DetailNoPrefixPage> createState() => _DetailNoPrefixPageState();
}

class _DetailNoPrefixPageState extends State<DetailNoPrefixPage> {
  late DetailNoPrefixController controller;
  String? selectedProductCode;
  double selectedPrice = 0;
  dynamic selectedProduk;

  @override
  void initState() {
    super.initState();
    controller = DetailNoPrefixController(
      context: context,
      flowCubit: context.read<FlowCubit>(),
      transaksiCubit: context.read<TransaksiHelperCubit>(),
      refresh: setState,
    );
    controller.initFetch();
  }

  @override
  Widget build(BuildContext context) {
    final flowState = context.watch<FlowCubit>().state!;
    final flowCubit = context.read<FlowCubit>();
    final iconItem = flowState.layananItem;
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;

    final bool isLastPage = currentIndex == sequence.length - 1;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (currentIndex > 0) {
          flowCubit.previousPage();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: Text(
            iconItem.title ?? '',
            style: const TextStyle(color: kWhite),
          ),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: BlocBuilder<ProviderNoPrefixCubit, ProviderState>(
          builder: (context, state) {
            if (state is ProviderNoPrefixLoading) {
              return const Center(
                child: CircularProgressIndicator(color: kOrange),
              );
            }
            if (state is ProviderNoPrefixError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: kRed)),
              );
            }
            if (state is ProviderNoPrefixSuccess) {
              return ListView.builder(
                itemCount: state.providers.length,
                itemBuilder: (context, index) {
                  final provider = state.providers[index];
                  final List produkList = provider.produk;
                  return Card(
                    margin: const .symmetric(horizontal: 12, vertical: 8),
                    color: kWhite,
                    child: ExpansionTile(
                      title: Text(
                        provider.namaProvider,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      shape: Border(),
                      children: [
                        ...produkList.map((produk) {
                          final bool isSelected =
                              controller.selectedProductCode ==
                              produk.kodeProduk;
                          final bool isGangguan = produk.gangguan == 1;
                          return GestureDetector(
                            onTap: isGangguan
                                ? null
                                : () {
                                    controller.onProdukSelected(produk);
                                  },
                            child: Container(
                              margin: const .symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              padding: const .all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isGangguan
                                    ? Colors.grey.shade200
                                    : isSelected
                                    ? kOrange
                                    : kWhite,
                                border: Border.all(
                                  color: isGangguan
                                      ? kRed
                                      : isSelected
                                      ? Colors.deepOrange
                                      : Colors.grey.shade300,
                                  width: isGangguan ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        if (isGangguan)
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.cancel,
                                                color: kRed,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Gangguan",
                                                style: TextStyle(color: kRed),
                                              ),
                                            ],
                                          ),
                                        Text(
                                          produk.namaProduk,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isGangguan
                                                ? kRed
                                                : isSelected
                                                ? kWhite
                                                : kBlack,
                                          ),
                                        ),
                                        Text(
                                          produk.kodeProduk,
                                          style: TextStyle(
                                            color: isGangguan
                                                ? kRed
                                                : isSelected
                                                ? kWhite
                                                : kBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    CurrencyUtil.formatCurrency(
                                      produk.hargaJual,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isGangguan
                                          ? kRed
                                          : isSelected
                                          ? kWhite
                                          : kBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: kOrange),
            ); // Fallback
          },
        ),
        bottomNavigationBar: controller.selectedProductCode != null
            ? NavigationButtonNoPrefix(
                selectedPrice: controller.selectedPrice,
                isLastPage: isLastPage,
                flowState: flowState,
                flowCubit: flowCubit,
                onPressed: () => controller.navigateNext(
                  isLastPage: isLastPage,
                  nomorTujuan: '',
                ),
              )
            : null,
      ),
    );
  }
}
