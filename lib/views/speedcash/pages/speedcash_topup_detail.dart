import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/utils/dialog.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/panduan_topup_cubit.dart';
import '../cubit/request_topup_cubit.dart';
import '../widgets/rupiah_text_field.dart';

class SpeedCashDetailDepo extends StatefulWidget {
  const SpeedCashDetailDepo({
    this.isBank = false,
    this.kodeVA = '',
    this.atasNama = '',
    required this.imageUrl,
    required this.title,
    required this.minimumTopUp,
    super.key,
  });
  final String? title;
  final String? imageUrl;
  final String minimumTopUp;

  final String kodeVA;
  final String atasNama;
  final bool isBank;

  @override
  State<SpeedCashDetailDepo> createState() => _SpeedCashDetailDepoState();
}

class _SpeedCashDetailDepoState extends State<SpeedCashDetailDepo> {
  late final TextEditingController controller;
  String? kodeReseller;
  @override
  void initState() {
    super.initState();
    final infoState = context.read<InfoAkunCubit>().state;
    if (infoState is InfoAkunLoaded) {
      kodeReseller = infoState.data.data.kodeReseller;
      context.read<PanduanTopUpCubit>().fetchPanduan(
        kodeReseller ?? '',
        widget.title ?? '',
      );
    }

    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RequestTopUpCubit, RequestTopUpState>(
        listener: (context, state) {
          log('[state] : $state', name: "reqtopupcubit");
          if (state is RequestTopUpSuccess) {
            if (state.data.state == 1) {
              Navigator.pushNamed(context, '/speedcashTiketTopUpPage');
            } else if (state.data.state == 2) {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    backgroundColor: kBackground,
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            color: kRed,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'OPS!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: kBlack,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.data.message,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kNeutral90,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          //informasi
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kOrangeAccent300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: double.infinity,
                              // height: 150, // Dihapus agar tinggi bisa menyesuaikan
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    width: double.infinity,
                                    color: kOrangeAccent300.withAlpha(50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bank',
                                          style: TextStyle(
                                            color: kNeutral90,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          state.data.bank,
                                          style: const TextStyle(
                                            color: kBlack,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Nomor Rekening',
                                          style: TextStyle(
                                            color: kNeutral90,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                state.data.rekening,
                                                style: const TextStyle(
                                                  color: kBlack,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: state.data.rekening,
                                                  ),
                                                );
                                                showAppToast(
                                                  context,
                                                  'Nomor rekening berhasil disalin',
                                                  ToastType.complete,
                                                );
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.copy,
                                                      size: 16,
                                                      color: kNeutral80,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Salin',
                                                      style: TextStyle(
                                                        color: kNeutral100,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Nominal transfer',
                                          style: TextStyle(
                                            color: kNeutral90,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                CurrencyUtil.formatCurrency(
                                                  double.tryParse(
                                                        state.data.nominal
                                                            .toString(),
                                                      ) ??
                                                      0,
                                                ),
                                                style: const TextStyle(
                                                  color: kBlack,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: state.data.nominal
                                                        .toString(),
                                                  ),
                                                );
                                                showAppToast(
                                                  context,
                                                  'Nominal transfer berhasil disalin',
                                                  ToastType.complete,
                                                );
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.copy,
                                                      size: 16,
                                                      color: kNeutral80,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Salin',
                                                      style: TextStyle(
                                                        color: kNeutral100,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      'Atas nama: ${state.data.atasNama}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: kNeutral90,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          } else if (state is RequestTopUpError) {
            showAppToast(context, state.message, ToastType.error);
          }
        },
        child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(backgroundColor: kWhite, scrolledUnderElevation: 0),
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
                          (widget.imageUrl != null &&
                              widget.imageUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: widget.imageUrl ?? '-',
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                widget.isBank
                    ? RupiahTextField(controller: controller, fontSize: 25)
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: kOrangeAccent300, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          width: double.infinity,
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  color: kOrangeAccent300.withAlpha(50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nomor Virtual Account',
                                        style: TextStyle(
                                          color: kNeutral80,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.kodeVA,
                                              style: const TextStyle(
                                                color: kBlack,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text: widget.kodeVA,
                                                ),
                                              );
                                              showAppToast(
                                                context,
                                                'Nomor Virtual Account berhasil disalin',
                                                ToastType.complete,
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: kWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.copy,
                                                    size: 16,
                                                    color: kNeutral80,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    'Salin',
                                                    style: TextStyle(
                                                      color: kNeutral100,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('Atas nama: ${widget.atasNama}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                Text(
                  widget.isBank
                      ? "Minimal Top up ${CurrencyUtil.formatCurrency(double.tryParse(widget.minimumTopUp) ?? 0)}"
                      : "Biaya Admin ${CurrencyUtil.formatCurrency(double.tryParse(widget.minimumTopUp) ?? 0)}",
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
                    log('[state] : $state', name: "panduancubit");
                    if (state is PanduanTopUpLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: kOrange),
                      );
                    }
                    if (state is PanduanTopError) {
                      return SizedBox.shrink();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      panduan.data.length,
                                      (i) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Text(
                                          "${i + 1}. ${panduan.data[i]}",
                                        ),
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
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SafeArea(
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
                  if (widget.isBank == true) {
                    if (controller.text.isEmpty) {
                      return showAppToast(
                        context,
                        'Nominal tidak boleh kosong',
                        ToastType.error,
                      );
                    }
                  }

                  final format = controller.text.replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  );
                  int nominal = int.parse(format);

                  if (nominal < int.parse(widget.minimumTopUp)) {
                    return showAppToast(
                      context,
                      'Minimal Top up ${CurrencyUtil.formatCurrency(double.tryParse(widget.minimumTopUp))}',
                      ToastType.error,
                    );
                  }

                  context.read<RequestTopUpCubit>().requestTopUp(
                    kodeReseller!,
                    nominal,
                    widget.title ?? '',
                  );
                },

                child: const Text(
                  "Selanjutnya",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
