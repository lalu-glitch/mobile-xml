import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/panduan_topup_cubit.dart';
import '../cubit/request_topup_cubit.dart';
import '../topup_dummy/cubit/topup_dummy_speedcash_cubit.dart';
import '../widgets/rupiah_text_field.dart';

class SpeedCashDetailDepo extends StatefulWidget {
  const SpeedCashDetailDepo({
    required this.imageUrl,
    required this.title,
    required this.minimumTopUp,
    super.key,
  });

  final String? title;
  final String? imageUrl;
  final String minimumTopUp;

  @override
  State<SpeedCashDetailDepo> createState() => _SpeedCashDetailDepoState();
}

class _SpeedCashDetailDepoState extends State<SpeedCashDetailDepo> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final infoState = context.read<InfoAkunCubit>().state;
    if (infoState is InfoAkunLoaded) {
      final kodeReseller = infoState.data.data.kodeReseller;
      context.read<PanduanTopUpCubit>().fetchPanduan(
        kodeReseller,
        widget.title ?? '',
      );
      context.read<RequestTopUpCubit>().requestTopUp(
        kodeReseller,
        50000,
        widget.title ?? '',
      );
    }

    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(backgroundColor: kWhite, scrolledUnderElevation: 0.0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child:
                      (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: widget.imageUrl ?? '-',
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.business_rounded),
                        )
                      : const Icon(
                          Icons.business_rounded,
                          size: 30,
                          color: kNeutral70,
                        ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.title?.toUpperCase() ?? 'N/A',
                  style: TextStyle(
                    color: kNeutral100,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            RupiahTextField(controller: controller, fontSize: 25),
            const SizedBox(height: 16),
            Text(
              "Biaya admin ${CurrencyUtil.formatCurrency(double.tryParse(widget.minimumTopUp) ?? 0)}",
              style: TextStyle(color: kNeutral90),
            ),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 16),
            Text(
              ' Panduan',
              style: TextStyle(
                color: kNeutral100,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<PanduanTopUpCubit, PanduanTopUpState>(
              builder: (context, state) {
                if (state is PanduanTopUpLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: kOrange),
                  );
                }
                if (state is PanduanTopError) {
                  return const Center(
                    child: Text(
                      "Terjadi kesalahan, silahkan coba lagi nanti.",
                      style: TextStyle(color: kRed),
                    ),
                  );
                }
                if (state is PanduanTopUpLoaded) {
                  final panduanList = state.data.data;
                  if (panduanList.isEmpty) {
                    return const Center(
                      child: Text(
                        "Panduan belum tersedia.",
                        style: TextStyle(color: kNeutral70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: panduanList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final panduan = panduanList[index];
                      return Card(
                        color: kNeutral30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        child: ExpansionTile(
                          title: Text(
                            panduan.label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: kNeutral100,
                            ),
                          ),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: const Border(),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  panduan.data.length,
                                  (i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text("${i + 1}. ${panduan.data[i]}"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                // Default state (initial)
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            foregroundColor: kWhite,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            context.read<TopupDummySpeedcashCubit>().fetchTopup();
            Navigator.pushNamed(context, '/speedcashTiketTopUpPage');
          },
          child: const Text(
            "Selanjutnya",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
