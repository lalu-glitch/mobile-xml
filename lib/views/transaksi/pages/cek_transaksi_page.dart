import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/core/helper/currency.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/dynamic_app_page.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/utils/info_row.dart';
import '../../../data/models/transaksi/cek_transaksi.dart';
import '../../input_nomor/utils/base_state.dart';
import '../../input_nomor/utils/transaksi_cubit.dart';
import '../../layanan/cubit/flow_cubit.dart';
import '../cubit/websocket_cektransaksi_cubit.dart';

class CekTransaksiPage extends StatefulWidget {
  const CekTransaksiPage({super.key});

  @override
  State<CekTransaksiPage> createState() => _CekTransaksiPageState();
}

class _CekTransaksiPageState extends BaseInput<CekTransaksiPage> {
  CekTransaksiModel? cekTransaksiData;
  @override
  void initState() {
    super.initState();
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    final cubit = context.read<WebSocketCekTransaksiCubit>();
    cubit.reset();
    cubit.cekTransaksi(transaksi.tujuan ?? '', transaksi.kodeProduk ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiHelperCubit>().getData();

    return buildPopScope(
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: const Text(
            "Cek Produk Dan Bayar",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kOrange,
          iconTheme: IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              BlocBuilder<
                WebSocketCekTransaksiCubit,
                WebSocketCekTransaksiState
              >(
                builder: (context, state) {
                  if (state is WebSocketCekTransaksiLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kOrange),
                    );
                  }
                  if (state is WebSocketCekTransaksiSuccess) {
                    cekTransaksiData = state.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: kWhite,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...buildDynamicRows(state.data),
                                infoRow(
                                  "Fee",
                                  CurrencyUtil.formatCurrency(
                                    transaksi.productPrice,
                                  ),
                                  isTotal: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kOrange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: handleNextButtonPress,
                          child: const Text(
                            "Selanjutnya",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is WebSocketCekTransaksiError) {
                    return Center(child: Text(state.message));
                  }
                  return SizedBox.shrink();
                },
              ),
        ),
      ),
    );
  }

  List<Widget> buildDynamicRows(CekTransaksiModel model) {
    const fieldMapping = {
      "Nama Reseller": "nama_reseller",
      "Kode": "kode",
      "Tujuan": "tujuan",
      "Nama Pelanggan": "namapelanggan",
      "Total Tagihan": "rptagihan",
      "Admin": "admin",
      "Periode": "periode",
    };
    final List<Widget> rows = [];
    fieldMapping.forEach((label, key) {
      final value = model.data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        String displayValue = value.toString();
        if (key == "rptagihan") {
          final clean = displayValue.replaceAll(RegExp(r'[.,]'), '');
          final amount = int.tryParse(clean) ?? 0;
          displayValue = CurrencyUtil.formatCurrency(amount);
        }
        if (key == "admin") {
          final clean = displayValue.replaceAll(RegExp(r'[.,]'), '');
          final amount = int.tryParse(clean) ?? 0;
          displayValue = CurrencyUtil.formatCurrency(amount);
        }
        rows.add(infoRow(label, displayValue));
        rows.add(const Divider(height: 20));
      }
    });
    return rows;
  }

  @override
  void handleNextButtonPress() {
    final transaksi = context.read<TransaksiHelperCubit>().getData();
    final sendTransaksi = context.read<TransaksiHelperCubit>();
    final flowCubit = context.read<FlowCubit>();
    final flowState = flowCubit.state!;
    final currentIndex = flowState.currentIndex;

    final String first = transaksi.kodeProduk?.substring(0, 1) ?? "";

    final rawTagihan = cekTransaksiData?.data["rptagihan"]?.toString() ?? "0";
    final clean = rawTagihan.replaceAll(RegExp(r'[.,]'), '');
    final tagihan = int.tryParse(clean) ?? 0;

    final fee = (transaksi.productPrice ?? 0.0).toInt();

    sendTransaksi.setFee(fee);
    sendTransaksi.setFinalTotalTagihan(tagihan);

    if (first == 'C') {
      Navigator.pushNamedAndRemoveUntil(context, '/homepage', (route) => false);
      sendTransaksi.reset();
      return;
    }

    final bool isLastPage = currentIndex == flowState.sequence.length - 1;

    if (!isLastPage) {
      final nextPage = flowState.sequence[currentIndex + 1];
      flowCubit.nextPage();

      if (pageRoutes.containsKey(nextPage)) {
        Navigator.pushNamed(context, pageRoutes[nextPage]!);
      } else {
        showErrorDialog(context, "Rute halaman berikutnya tidak ditemukan.");
      }
    } else {
      Navigator.pushNamed(context, '/konfirmasiPembayaran');
    }
  }
}
