import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:xmlapp/core/helper/currency.dart';
import 'package:xmlapp/views/input_nomor/transaksi_cubit.dart';

import '../core/helper/constant_finals.dart';
import '../core/helper/dynamic_app_page.dart';
import '../core/helper/flow_cubit.dart';
import '../core/utils/error_dialog.dart';

class InputNomorTujuanPage extends StatefulWidget {
  const InputNomorTujuanPage({
    super.key,
    required String kode_produk,
    required String namaProduk,
    required String total,
  });

  @override
  State<InputNomorTujuanPage> createState() => _InputNomorTujuanPageState();
}

class _InputNomorTujuanPageState extends State<InputNomorTujuanPage> {
  final TextEditingController _nomorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiCubit>().getData();
    final sendTransaksi = context.read<TransaksiCubit>();

    final flowState = context.watch<FlowCubit>().state!;
    final flowCubit = context.read<FlowCubit>();
    final iconItem = flowState.iconItem;
    final int flow = flowState.flow;
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;

    final bool isLastPage = currentIndex == sequence.length - 1;

    return WillPopScope(
      onWillPop: () async {
        if (flowState.currentIndex > 0) {
          // ✅ betul
          flowCubit.previousPage(); // sync Cubit
          Navigator.pop(context); // kembali ke page sebelumnya
          return false; // jangan biarkan default pop
        }
        return true; // kalau sudah di index 0 → exit
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            "Input Nomor Tujuan",
            style: TextStyle(color: kWhite),
          ),
          leading: BackButton(
            onPressed: () {
              final flowCubit = context.read<FlowCubit>();
              if (flowCubit.state!.currentIndex > 0) {
                flowCubit.previousPage(); // ✅ sync dengan Cubit
              }
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xFFFF6D00),
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Info Produk ===
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _infoRow("Nama Produk", transaksi.namaProduk ?? '-'),
                          const Divider(height: 24),
                          _infoRow(
                            "Total Pembayaran",
                            CurrencyUtil.formatCurrency(transaksi.total),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Masukkan Nomor Tujuan"),
              const SizedBox(height: 8),
              TextField(
                controller: _nomorController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Input Nomor Tujuan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.contact_page),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: kWhite,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_nomorController.text.isEmpty) {
                    showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
                    return;
                  }

                  //update data
                  sendTransaksi.setTujuan(_nomorController.text);

                  if (!isLastPage) {
                    // update index ke halaman berikut
                    final nextPage =
                        flowState.sequence[flowState.currentIndex + 1];

                    flowCubit.previousPage();

                    Navigator.pushNamed(context, pageRoutes[nextPage]!);
                  } else {
                    // halaman terakhir → langsung ke konfirmasi
                    Navigator.pushNamed(context, '/konfirmasiPembayaran');
                  }
                },
                child: const Text(
                  "Selanjutnya",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Maksimal 2 baris, ubah jika mau multi-line
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? Screen.kSize16 : Screen.kSize14,
              color: isTotal ? kOrange : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
